import 'package:local_auth/local_auth.dart';

import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import '../logger_func.dart';

/*
 Sebelum menggunakan fitur Local Auth, jangan lupa menambahkan permission di AndroidManifest:

 - uses-permission android:name="android.permission.USE_BIOMETRIC"

 dan ubah kode mada MainActivity seperti contoh berikut:

 import io.flutter.embedding.android.FlutterFragmentActivity
 import io.flutter.embedding.engine.FlutterEngine
 import io.flutter.plugins.GeneratedPluginRegistrant

 class MainActivity: FlutterFragmentActivity() {
     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
         super.configureFlutterEngine(flutterEngine)
         GeneratedPluginRegistrant.registerWith(flutterEngine)
     }
 }
 */

/// Fungsi untuk cek dan request permintaan autentikasi
Future<bool> checkBiometrics({bool? useOnlyBiometricAuth}) async {
  List<BiometricType> availableBiometrics = await LocalAuthentication().getAvailableBiometrics();
  if (availableBiometrics.contains(BiometricType.weak)) clog('Face Auth tersedia!');
  if (availableBiometrics.contains(BiometricType.strong)) clog('Fingerprint Auth tersedia!');
  return await authenticateBegin(useOnlyBiometricAuth: useOnlyBiometricAuth ?? true);
}

/// Request permintaan autentikasi wajah
Future<bool> authenticateBegin({required bool useOnlyBiometricAuth, String? descriptionInfo}) async {
  try {
    bool didAuthenticate = await LocalAuthentication().authenticate(options: AuthenticationOptions(biometricOnly: useOnlyBiometricAuth, useErrorDialogs: true, stickyAuth: true, sensitiveTransaction: true),
        localizedReason: descriptionInfo ?? 'Posisikan wajah Anda tepat di depan kamera/layar ponsel');
    return didAuthenticate;
  } catch (e, s) {
    clog('Terjadi kesalahan saat request Autentikasi Wajah : $e\n$s');
    await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    return false;
  }
}