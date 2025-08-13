extension IntManipulator on int {
  /// Mengubah ukuran file menjadi format Bit
  String get readAsBit {
    final bits = this * 8;
    if (bits < 1000) return '$bits Bit';
    if (bits < 1000 * 1000) return '${(bits / 1000).toStringAsFixed(1)} Kbit';
    if (bits < 1000 * 1000 * 1000) return '${(bits / (1000 * 1000)).toStringAsFixed(1)} Mbit';
    return '${(bits / (1000 * 1000 * 1000)).toStringAsFixed(1)} Gbit';
  }

  /// Mengubah ukuran file menjadi format Byte
  String get readAsByte {
    if (this < 1024) return '$this B';
    if (this < 1024 * 1024) return '${(this / 1024).toStringAsFixed(1)} KB';
    if (this < 1024 * 1024 * 1024) return '${(this / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}