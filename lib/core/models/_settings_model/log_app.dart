import 'dart:typed_data';

class PdfGenerationDataModelSetting {
  final List<Map<String, dynamic>> logData;
  final Uint8List fontBytes;
  final Map<String, String> deviceInfo;
  final String appName;
  final String appVersion;

  PdfGenerationDataModelSetting({
    required this.logData,
    required this.fontBytes,
    required this.deviceInfo,
    required this.appName,
    required this.appVersion,
  });
}