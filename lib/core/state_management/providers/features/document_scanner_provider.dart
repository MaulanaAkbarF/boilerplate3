import 'package:flutter/foundation.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

class DocumentScannerProvider extends ChangeNotifier {
  DocumentScanner? _scanner;
  DocumentScanningResult? _scanResult;
  bool _isScanning = false;
  String? _errorMessage;

  DocumentScanner? get scanner => _scanner;
  DocumentScanningResult? get scanResult => _scanResult;
  bool get isScanning => _isScanning;
  String? get errorMessage => _errorMessage;

  /// Initializes the scanner with given options
  void initializeScanner(DocumentScannerOptions options) {
    _scanner = DocumentScanner(options: options);
    _scanResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Starts the document scanning process
  Future<void> startScanning() async {
    if (_scanner == null) {
      _errorMessage = 'Scanner not initialized';
      notifyListeners();
      return;
    }

    try {
      _isScanning = true;
      _errorMessage = null;
      notifyListeners();

      _scanResult = await _scanner!.scanDocument();
      _isScanning = false;
      notifyListeners();
    } catch (e) {
      _isScanning = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Closes the scanner and releases resources
  Future<void> closeScanner() async {
    if (_scanner != null) {
      await _scanner!.close();
      _scanner = null;
      _scanResult = null;
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Clears the current scan result
  void clearScanResult() {
    _scanResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    closeScanner();
    super.dispose();
  }
}