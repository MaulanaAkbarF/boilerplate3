import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_bar_code/code/code.dart';

import '../../../../ui/layouts/global_state_widgets/selected_item/expansion_tile.dart';

class QRCodeProvider with ChangeNotifier {
  TextEditingController _tecUrl = TextEditingController();
  CodeType _codeType = CodeType.qrCode();
  Barcode? _barcode;
  bool _isScanning = false;
  bool _isCodeError = false;

  TextEditingController get tecUrl => _tecUrl;
  CodeType get codeType => _codeType;
  Barcode? get barcode => _barcode;
  bool get isScanning => _isScanning;
  bool get isCodeError => _isCodeError;

  /// Mengatur hasil scan
  void setBarcode(BarcodeCapture barcodes) {
    _barcode = barcodes.barcodes.firstOrNull;
    notifyListeners();
  }

  /// Reset hasil scan
  void changeCodeType(Expansion data) {
    switch (data.text) {
      case 'QR Code':
        _codeType = CodeType.qrCode();
        break;
      case 'Aztec':
        _codeType = CodeType.aztec();
        break;
      case 'Code Bar':
        _codeType = CodeType.codeBar();
        break;
      case 'Code39':
        _codeType = CodeType.code39();
        break;
      case 'Code93':
        _codeType = CodeType.code93();
        break;
      case 'Code128':
        _codeType = CodeType.code128(useCode128A: true, useCode128B: true);
        break;
      case 'Data Matrix':
        _codeType = CodeType.dataMatrix();
        break;
      case 'EAN2':
        _codeType = CodeType.ean2();
        break;
      case 'EAN5':
        _codeType = CodeType.ean5();
        break;
      case 'EAN8':
        _codeType = CodeType.ean8();
        break;
      case 'EAN13':
        _codeType = CodeType.ean13(drawEndChar: false);
        break;
      case 'GS128':
        _codeType = CodeType.gs128(useCode128A: true, useCode128B: true);
        break;
      case 'ISBN':
        _codeType = CodeType.isbn(drawEndChar: false, drawIsbn: true);
        break;
      case 'ITF':
        _codeType = CodeType.itf(addChecksum: false, zeroPrepend: false);
        break;
      case 'ITF14':
        _codeType = CodeType.itf14(drawBorder: true, borderWidth: 1.0);
        break;
      case 'ITF16':
        _codeType = CodeType.itf16(drawBorder: true, borderWidth: 1.0);
        break;
      case 'PDF417':
        _codeType = CodeType.pdf417();
        break;
      case 'RM4 SSC':
        _codeType = CodeType.rm4scc();
        break;
      case 'Telepen':
        _codeType = CodeType.telepen();
        break;
      case 'upcA':
        _codeType = CodeType.upcA();
        break;
      case 'upcE':
        _codeType = CodeType.upcE(fallback: false);
        break;
      default:
        _codeType = CodeType.qrCode();
        break;
    }
    notifyListeners();
  }

  /// Mengatur status scanning
  void setScanning(bool value) {
    _isScanning = value;
    notifyListeners();
  }

  /// Reset hasil scan
  void clearBarcode() {
    _barcode = null;
    notifyListeners();
  }

  /// Menetapkan code error agar saat Code Builder gagal menampilkan Code, pengguna tidak dapat mencetak Code
  void setCodeError(bool value) => _isCodeError = value;

  /// Fungsi untuk membuat barcode dengan men-trigger perubahan UI aja wkwk
  /// Barcode dibuat menggunakan URL yang diambil dari input pengguna
  void makeBarcode() => notifyListeners();

  static QRCodeProvider read(BuildContext context) => context.read();
  static QRCodeProvider watch(BuildContext context) => context.watch();
}