import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../../utilities/functions/input_func.dart';
import '../../../utilities/functions/logger_func.dart';
import '../../../utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';

class FaceDetectorUtil {
  Interpreter? faceRecognition;
  Interpreter? faceSpoofing;
  List<dynamic>? referenceEmbedding;
  File? referenceImageFile;

  bool isInitialized = false;
  bool breath = false;

  static FaceDetectorUtil read(BuildContext context) => context.read();

  FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: false,
      enableContours: true,
      enableTracking: true,
      enableClassification: true,
      minFaceSize: .3,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  /// Mengisiasi FaceDetectorUtil dan load model tflite
  Future initialize(BuildContext context) async {
    if (isInitialized) return;
    faceRecognition = await Interpreter.fromAsset("assets/file/face_model.tflite");
    isInitialized = true; 
  }

  /// Proses deteksi wajah saat stream
  Future<void> faceScanner(CameraController controller, CameraImage cameraImage, {Function(Face face, img.Image image)? onFaceFounded, Function()? noFaceFounded}) async {
    try {
      var visionImage = _inputImageFromCameraImage(controller, cameraImage);
      if (visionImage == null) {
        clog("Gagal membuat vision image");
        return noFaceFounded?.call();
      }

      var faces = await faceDetector.processImage(visionImage);
      if (faces.isNotEmpty) {
        var face = faces.first;
        clog("Batas Wajah: ${face.boundingBox}");
        clog("Probabilitas Mata Kiri Terbuka: ${face.leftEyeOpenProbability}");
        clog("Probabilitas Mata Kanan Terbuka: ${face.rightEyeOpenProbability}");

        try {
          var image = await _convertCameraImage(cameraImage, controller.description.lensDirection);
          if (image == null) {
            clog("Gagal mengkonversi gambar kamera");
            return noFaceFounded?.call();
          }

          image = img.copyCrop(image, x: face.boundingBox.left.toInt(), y: face.boundingBox.top.toInt(), height: face.boundingBox.height.toInt(), width: face.boundingBox.width.toInt());
          image = img.copyResize(image, width: 112, height: 112);
          image = img.copyResizeCropSquare(image, size: 112);
          return onFaceFounded?.call(face, image);
        } catch (e, s) {
          clog("Gagal memproses gambar kamera: $e\n$s");
          addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
          return noFaceFounded?.call();
        }
      } else {
        return noFaceFounded?.call();
      }
    } catch (e, s) {
      clog("Terjadi masalah pada faceScanner: $e\n$s");
      addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return noFaceFounded?.call();
    }
  }

  double calculateBrightness(img.Image image) {
    try {
      int totalLuminance = 0;
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          final pixel = image.getPixel(x, y);
          // Luminance formula: 0.299*R + 0.587*G + 0.114*B
          totalLuminance += (0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b).toInt();
        }
      }

      return totalLuminance / (image.width * image.height);
    } catch (e, s) {
      clog("Terjadi masalah saat calculateBrightness. $e\n$s");
      addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    }

    return -1.0;
  }

  Future<bool> loadReferenceImageFromAsset({String? assetPath}) async {
    try {
      final ByteData data = await rootBundle.load(assetPath ?? 'assets/image/face_example5.jpg');
      final Uint8List bytes = data.buffer.asUint8List();

      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/reference_face.jpg');
      await tempFile.writeAsBytes(bytes);
      final img.Image? image = await img.decodeImageFile(tempFile.path);
      if (image == null) return false;

      final result = await autoCropFace(tempFile);
      if (result == null) return false;

      referenceImageFile = result.$1;
      referenceEmbedding = await interpreterRecogImage(result.$2);
      return referenceEmbedding != null;
    } catch (e, s) {
      clog("Gagal memuat gambar referensi: $e\n$s");
      addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  Future<double> compareWithReference(img.Image currentFace) async {
    if (referenceEmbedding == null) {
      clog("Referensi gambar belum dimuat");
      return -1.0;
    }

    try {
      final currentEmbedding = await interpreterRecogImage(currentFace);
      if (currentEmbedding == null) return -1.0;
      final distance = await euclideanDistance(referenceEmbedding!, currentEmbedding);
      return distance;
    } catch (e, s) {
      clog("Gagal membandingkan dengan referensi: $e\n$s");
      addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return -1.0;
    }
  }

  Future<double> compareImage(File model, File takenPhoto) async {
    var takenImage = await img.decodeJpgFile(takenPhoto.path);
    var intrTakenImage = await interpreterRecogImage(takenImage!);

    var modelImage = await img.decodeJpgFile(model.path);
    var intrModel = await interpreterRecogImage(modelImage!);

    var compareResult = await euclideanDistance(intrTakenImage!, intrModel!);
    clog("Result : $compareResult");

    return compareResult;
  }

  /// Cek apakah wajah cocok dengan referensi
  /// Threshold di set adalah 0.6
  /// Jika presentasi skor lebih dari 0.6 atau 60%, maka dinyatakan valid
  bool isMatchWithReference(double distance, {double threshold = 0.6}) {
    return distance >= 0 && distance >= threshold;
  }

  Future<double> euclideanDistance(List e1, List e2) {
    return Isolate.run(() {
      double sum = 0.0;
      for (int i = 0; i < e1.length; i++) {
        sum += pow((e1[i] - e2[i]), 2);
      }
      return sqrt(sum);
    }).catchError((e, s) async {
      clog("Terjadi masalah saat euclideanDistance. $e\n$s");
      addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return -1.0;
    });
  }

  Future<List?> interpreterRecogImage(img.Image image) {
    List input = imageToByteListFloat32(image, 112, 128, 128);
    List output = List.generate(1, (index) => List.filled(192, 0));

    return Isolate.run(() {
      input = input.reshape([1, 112, 112, 3]);
      faceRecognition?.run(input, output);
      output = output.reshape([192]);
      return output;
    }).catchError((e, s) {
      clog("Terjadi masalah saat interpreterRecogImage. $e\n$s");
      addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return [];
    });
  }

  Future<img.Image?> _convertCameraImage(CameraImage image, CameraLensDirection dir) async {
    try {
      img.Image? output;
      if (image.format.group == ImageFormatGroup.nv21) {
        if (kDebugMode) {
          output = _convertNV21(image);
        } else {
          output = await _convertNV21Isolated(image);
        }
      } else if (image.format.group == ImageFormatGroup.yuv420) {
        output = _convertYUV420(image, dir);
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        output = _convertBGRA8888(image, dir);
      }

      return output;
    } catch (_) {}
    return null;
  }

  Future<img.Image> _convertNV21Isolated(CameraImage image) {
    final width = image.width.toInt();
    final height = image.height.toInt();
    Uint8List yuv420sp = image.planes[0].bytes;

    // Initial conversion from NV21 to RGB
    return Isolate.run(() {
      final outImg = img.Image(height: height, width: width); // Note the swapped dimensions

      for (int j = 0, yp = 0; j < height; j++) {
        int uvp = width * height + (j >> 1) * width, u = 0, v = 0;
        for (int i = 0; i < width; i++, yp++) {
          int y = (0xff & yuv420sp[yp]) - 16;
          if (y < 0) y = 0;
          if ((i & 1) == 0) {
            v = (0xff & yuv420sp[uvp++]) - 128;
            u = (0xff & yuv420sp[uvp++]) - 128;
          }
          int y1192 = 1192 * y;
          int r = (y1192 + 1634 * v);
          int g = (y1192 - 833 * v - 400 * u);
          int b = (y1192 + 2066 * u);

          if (r < 0) {
            r = 0;
          } else if (r > 262143) {
            r = 262143;
          }
          if (g < 0) {
            g = 0;
          } else if (g > 262143) {
            g = 262143;
          }
          if (b < 0) {
            b = 0;
          } else if (b > 262143) {
            b = 262143;
          }

          outImg.setPixelRgba(width - i - 1, j, ((r << 6) & 0xff0000) >> 16, ((g >> 2) & 0xff00) >> 8, (b >> 10) & 0xff, 255);
        }
      }
      return outImg;
    });
    // Rotate the image by 90 degrees (or 270 degrees if needed)
    // return img.copyRotate(outImg, -90); // Use -90 for a 270 degrees rotation
  }

  img.Image _convertNV21(CameraImage image) {
    final width = image.width.toInt();
    final height = image.height.toInt();
    Uint8List yuv420sp = image.planes[0].bytes;

    // Initial conversion from NV21 to RGB
    final outImg = img.Image(height: height, width: width); // Note the swapped dimensions
    final int frameSize = width * height;

    for (int j = 0, yp = 0; j < height; j++) {
      int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
      for (int i = 0; i < width; i++, yp++) {
        int y = (0xff & yuv420sp[yp]) - 16;
        if (y < 0) y = 0;
        if ((i & 1) == 0) {
          v = (0xff & yuv420sp[uvp++]) - 128;
          u = (0xff & yuv420sp[uvp++]) - 128;
        }
        int y1192 = 1192 * y;
        int r = (y1192 + 1634 * v);
        int g = (y1192 - 833 * v - 400 * u);
        int b = (y1192 + 2066 * u);

        if (r < 0) {
          r = 0;
        } else if (r > 262143) {
          r = 262143;
        }
        if (g < 0) {
          g = 0;
        } else if (g > 262143) {
          g = 262143;
        }
        if (b < 0) {
          b = 0;
        } else if (b > 262143) {
          b = 262143;
        }

        outImg.setPixelRgba(width - i - 1, j, ((r << 6) & 0xff0000) >> 16, ((g >> 2) & 0xff00) >> 8, (b >> 10) & 0xff, 255);
      }
    }
    return outImg;

    // Rotate the image by 90 degrees (or 270 degrees if needed)
    // return img.copyRotate(outImg, -90); // Use -90 for a 270 degrees rotation
  }

  img.Image _convertBGRA8888(CameraImage image, CameraLensDirection dir) {
    return img.Image.fromBytes(width: image.width, height: image.height, bytes: image.planes[0].bytes.buffer);
  }

  img.Image _convertYUV420(CameraImage image, CameraLensDirection dir) {
    int width = image.width;
    int height = image.height;
    var output = img.Image(width: width, height: height);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex = image.planes[1].bytesPerPixel ?? -1 * (x / 2).floor() + image.planes[1].bytesPerRow * (y / 2).floor();
        final yp = image.planes[0].bytes[y * width + x];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91).round().clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

        output.setPixelIndex(x, y, 0xFF000000 | (b << 16) | (g << 8) | r);
      }
    }
    return (dir == CameraLensDirection.front) ? img.copyRotate(output, angle: -90) : img.copyRotate(output, angle: 90);
  }

  Float32List imageToByteListFloat32(img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (pixel.r - mean) / std;
        buffer[pixelIndex++] = (pixel.g - mean) / std;
        buffer[pixelIndex++] = (pixel.b - mean) / std;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  final orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraController controller, CameraImage image) {
    final description = controller.description;
    final sensorOrientation = description.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = orientations[controller.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (description.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null || (Platform.isAndroid && format != InputImageFormat.nv21) || (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  Uint8List convertYUV420ToNV21(CameraImage image) {
    final width = image.width;
    final height = image.height;

    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final yBuffer = yPlane.bytes;
    final uBuffer = uPlane.bytes;
    final vBuffer = vPlane.bytes;

    final numPixels = width * height + (width * height ~/ 2);
    final nv21 = Uint8List(numPixels);

    int idY = 0;
    int idUV = width * height;
    final uvWidth = width ~/ 2;
    final uvHeight = height ~/ 2;

    final yPixelStride = yPlane.bytesPerPixel ?? 1;
    final uvPixelStride = uPlane.bytesPerPixel ?? 2;

    for (int y = 0; y < height; ++y) {
      for (int x = 0; x < width; ++x) {
        nv21[idY++] = yBuffer[y * yPlane.bytesPerRow + x * yPixelStride];
      }
    }

    for (int y = 0; y < uvHeight; ++y) {
      for (int x = 0; x < uvWidth; ++x) {
        final bufferIndex = y * uPlane.bytesPerRow + (x * uvPixelStride);
        nv21[idUV++] = vBuffer[bufferIndex]; // V channel
        nv21[idUV++] = uBuffer[bufferIndex]; // U channel
      }
    }
    return nv21;
  }

  Future<(File, img.Image)?> autoCropFace(File fileModel, {String? name}) async {
    var detectedUser = await faceDetector.processImage(InputImage.fromFile(fileModel));
    var filename = name ?? generateRandomString(16);

    if (detectedUser.isNotEmpty) {
      var face = detectedUser.first;
      var image = await img.decodeImageFile(fileModel.path);
      if (image != null) {
        image = img.copyCrop(image, x: face.boundingBox.left.toInt(), y: face.boundingBox.top.toInt(), height: face.boundingBox.height.toInt(), width: face.boundingBox.width.toInt());
        image = img.copyResize(image, width: 112, height: 112);

        try {
          var dir = await getApplicationCacheDirectory();
          var file = File("${dir.path}/$filename.jpg");
          await file.writeAsBytes(img.encodeJpg(image), flush: true);
          return (file, image);
        } catch (e, s) {
          clog("Terjadi masalah saat memotong gambar. $e\n$s");
          addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
        }
      }
    }

    return null;
  }

  void dispose() {
    isInitialized = false;
    faceDetector.close();
  }
}

class FaceDetectorResult {
  final bool success;
  final String message;
  final File? data;

  FaceDetectorResult(this.success, this.message, [this.data]);
}