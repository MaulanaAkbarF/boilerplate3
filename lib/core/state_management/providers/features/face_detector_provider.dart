import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

import '../../../../ui/layouts/styleconfig/themecolors.dart';
import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../../constant_values/enum_values.dart';
import '../../../utilities/functions/logger_func.dart';
import '../../../utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import 'face_detector_util.dart';

class FaceDetectorProvider extends ChangeNotifier {
  final BuildContext context;
  final double brightnessThreshold = 70;
  final bool scanForBrigthness;
  final bool enableFaceComparison;
  final double comparisonThreshold;

  bool _faceFounded = false;
  double _brightness = 0;
  Timer? _faceNotFoundTimeout;
  bool _askForBlink = false;
  CameraController? cameraController;
  ScannerState _scannerState = ScannerState.prepare;
  bool _isProcessing = false;
  double _comparisonScore = -1.0;
  bool _faceMatched = false;
  XFile? _pictureTaken;

  bool _leftEyeOpenProbability = false;
  bool _rightEyeOpenProbability = false;

  // Variabel baru untuk deteksi senyuman dan arah pandangan
  bool _smilingProbability = false;
  double _headEulerAngleX = 0.0; // Mengangguk (pitch)
  double _headEulerAngleY = 0.0; // Menggeleng (yaw)
  double _headEulerAngleZ = 0.0; // Miring kepala (roll)

  int _frameSkipCounter = 0;
  final int _fameSkip = 10;

  FaceDetectorProvider(this.context, {this.scanForBrigthness = true, this.enableFaceComparison = true, this.comparisonThreshold = 0.6});
  FaceDetectorUtil get util => context.read();

  ScannerState get scannerState => _scannerState;
  double get brightness => _brightness;
  bool get brightnessValid => _brightness > brightnessThreshold;
  bool get faceValid => _faceFounded;
  bool get faceMatched => _faceMatched;
  double get comparisonScore => _comparisonScore;

  bool get leftEyeOpen => _leftEyeOpenProbability;
  bool get rightEyeOpen => _rightEyeOpenProbability;

  bool get isSmiling => _smilingProbability;
  double get headPitch => _headEulerAngleX; // Mengangguk
  double get headYaw => _headEulerAngleY;   // Menggeleng
  double get headRoll => _headEulerAngleZ;  // Miring kepala

  /// Getter tambahan untuk interpretasi arah pandangan
  String get headDirection {
    if (_headEulerAngleX > 15) return 'Bawah';
    if (_headEulerAngleX < -15) return 'Atas';
    if (_headEulerAngleY > 15) return 'Kanan';
    if (_headEulerAngleY < -15) return 'Kiri';
    return 'Tengah';
  }

  bool get isLookingCenter => headDirection == 'Tengah';

  /// Kondisi warna pada layout
  Color get validatorColor {
    if (!faceValid) return ThemeColors.red(context);
    if (scanForBrigthness && !brightnessValid) return ThemeColors.yellow(context);
    if (enableFaceComparison && !faceMatched) return ThemeColors.orange(context);
    if (faceValid) return ThemeColors.green(context);
    return ThemeColors.surface(context);
  }

  /// Kondisi teks/informasi pada layout
  String get detectorPrompt {
    if (!faceValid) return 'Wajah tidak ditemukan!';
    if (scanForBrigthness && !brightnessValid) return 'Mohon perbaiki pencahayaan';
    if (enableFaceComparison && !faceMatched) return 'Wajah tidak sama!';
    if (_askForBlink) return "Mohon berkedip";
    if (faceValid) return 'Wajah ditemukan!';
    return 'Memproses...!';
  }

  /// Mengisiasi kamera dan menjalankan proses scan wajah
  void initializeCamera([int attempt = 1]) async {
    if (cameraController != null) return;
    try {
      await util.initialize(context);
      var cameras = await availableCameras();
      var camera = cameras.where((element) => element.lensDirection == CameraLensDirection.front).toList();
      if (camera.isEmpty) {
        clog("Terjadi masalah pada FaceDetectorProvider. Kamera depan tidak ditemukan!");
        addLogApp(level: ListLogAppLevel.severe.level, title: 'Terjadi masalah pada FaceDetectorProvider. Kamera depan tidak ditemukan!', logs: '');
        return;
      }

      cameraController = CameraController(
        camera.first,
        ResolutionPreset.low,
        fps: 30,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );

      await cameraController!.initialize();
      cameraController!.startImageStream((image) => _processImage(image));
      notifyListeners();
    } catch (e, s) {
      clog("Terjadi masalah pada FaceDetectorProvider. Gagal mengisiasi kamera: $e\n$s");
      addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      if (attempt < 3) {
        await Future.delayed(Duration(seconds: 1));
        initializeCamera(attempt + 1);
      }
    }
  }

  /// Proses deteksi wajah menggunakan camera stream
  void _processImage(CameraImage image) async {
    _frameSkipCounter++;
    if (_frameSkipCounter < _fameSkip) return;
    _frameSkipCounter = 0;
    if (_isProcessing || scannerState == ScannerState.finished) return;
    _isProcessing = true;
    try {
      await util.faceScanner(cameraController!, image, onFaceFounded: _onFaceFoundListener, noFaceFounded: _noFaceFoundListener);
    } catch (e, s) {
      clog("Terjadi masalah pada FaceDetectorProvider. Gagal memproses gambar: $e\n$s");
      addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    } finally {
      _isProcessing = false;
    }
  }

  /// Listener ketika wajah ditemukan
  void _onFaceFoundListener(Face face, img.Image image) async {
    await apply(image);

    /// Deteksi mata terbuka/tertutup
    if ((face.leftEyeOpenProbability != null) && face.leftEyeOpenProbability! > 0.5) {
      _leftEyeOpenProbability = true;
    } else {
      _leftEyeOpenProbability = false;
    }

    if ((face.rightEyeOpenProbability != null) && face.rightEyeOpenProbability! > 0.5) {
      _rightEyeOpenProbability = true;
    } else {
      _rightEyeOpenProbability = false;
    }

    /// Deteksi senyuman
    if (face.smilingProbability != null && face.smilingProbability! > 0.7) {
      _smilingProbability = true;
    } else {
      _smilingProbability = false;
    }

    /// Deteksi arah pandangan kepala
    if (face.headEulerAngleX != null) _headEulerAngleX = face.headEulerAngleX!;
    if (face.headEulerAngleY != null) _headEulerAngleY = face.headEulerAngleY!;
    if (face.headEulerAngleZ != null) _headEulerAngleZ = face.headEulerAngleZ!;

    /// Proses pengembilan gambar akan dijalankan bila ScannerState diubah menjadi ScannerState.analyze
    if (cameraController != null && scannerState == ScannerState.analyze) {
      _faceNotFoundTimeout?.cancel();
      final leftEyeOpen = face.leftEyeOpenProbability ?? 0.0;
      final rightEyeOpen = face.rightEyeOpenProbability ?? 0.0;
      if (leftEyeOpen > 0.5 && rightEyeOpen > 0.5) {
        try {
          _pictureTaken = await cameraController!.takePicture();
          setScannerState(ScannerState.finished);
          await cameraController!.pausePreview();
        } catch (e, s) {
          clog("Error taking final picture: $e\n$s");
          addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
          setScannerState(ScannerState.fails);
        }
      }
    }
  }

  /// Listener ketika wajah tidak ditemukan
  void _noFaceFoundListener() {
    reset();
    if (scannerState == ScannerState.analyze) {
      if (_faceNotFoundTimeout?.isActive ?? false) return;
      _faceNotFoundTimeout = Timer(const Duration(seconds: 3), () {
        if (cameraController == null) {
          clog("CameraController is disposed, skipping pausePreview");
          setScannerState(ScannerState.fails);
          return;
        }
        setScannerState(ScannerState.fails);
        cameraController!.pausePreview();
      });
    }
  }

  Future<void> apply(img.Image image) async {
    if (scanForBrigthness) _brightness = util.calculateBrightness(image);
    _faceFounded = true;
    if (enableFaceComparison) {
      _comparisonScore = await util.compareWithReference(image);
      _faceMatched = util.isMatchWithReference(_comparisonScore, threshold: comparisonThreshold);
      clog("Comparison score: $_comparisonScore, Matched: $_faceMatched");
    }

    notifyListeners();
  }

  void reset() {
    _brightness = 0;
    _faceFounded = false;
    _comparisonScore = -1.0;
    _faceMatched = false;
    _leftEyeOpenProbability = false;
    _rightEyeOpenProbability = false;
    _smilingProbability = false;
    _headEulerAngleX = 0.0;
    _headEulerAngleY = 0.0;
    _headEulerAngleZ = 0.0;
    _scannerState = ScannerState.prepare;
    notifyListeners();
  }

  /// Load gambar referensi untuk komparasi
  Future<bool> loadReferenceImage({String? assetPath}) async {
    return await util.loadReferenceImageFromAsset(assetPath: assetPath);
  }

  /// Ketika dijalankan, akan memulai proses scan wajah
  void startScanning(BuildContext context) async {
    _scannerState = ScannerState.scanning;
    notifyListeners();
    try {
      _pictureTaken = await cameraController!.takePicture();
      _scannerState = ScannerState.analyze;
      _askForBlink = true;
      notifyListeners();
    } catch (e, s) {
      clog("Error taking picture: $e\n$s");
      addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      _scannerState = ScannerState.fails;
      notifyListeners();
    }
  }

  /// Fungsi ini digunakan untuk memulai mengambil gambar, melakukan scan dan memperoleh hasilnya
  void setScannerState(ScannerState state) {
    _scannerState = state;
    if (state == ScannerState.action) {
      _askForBlink = true;
    } else {
      _askForBlink = false;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _faceNotFoundTimeout?.cancel();
    if (cameraController != null) {
      cameraController?.stopImageStream();
      cameraController?.pausePreview();
      cameraController?.dispose();
    }
    super.dispose();
  }
}