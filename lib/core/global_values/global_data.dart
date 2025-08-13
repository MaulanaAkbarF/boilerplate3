class GlobalData {
  static String? isarOpenFailedMessage;
  static String? sqfliteFailedMessage;
  static int? switchMainPageIndex;
  static String? fcmToken;
  static bool isBluetoothHasBeenInitialized = false;
}

class UserDeviceInfo {
  /// Merek HP Pengguna
  static String brand = 'unknown';

  /// Kode Model HP Pengguna
  static String model = 'unknown';

  /// Kode Nama HP Pengguna
  static String device = 'unknown';

  /// Manufaktur/Perusahaan Pembuat HP Pengguna
  static String manufacturer = 'unknown';

  /// Kode Nama SOC HP Pengguna
  static String board = 'unknown';

  /// Nama Perangkat Keras HP Pengguna
  static String hardware = 'unknown';

  /// Versi Android Pengguna
  static String versionRelease = 'unknown';

  /// Versi SDK Android Pengguna
  static int versionSdkInt = 0;

  /// Nama Versi Android Pengguna
  static String versionCodeName = 'unknown';

  /// Pengecekan apakah pengguna menggunakan perangkat fisik atau emulator
  static bool isPhysicalDevice = false;

  static String getPysicalDevice() => isPhysicalDevice ? 'Ya' : 'Tidak';
}