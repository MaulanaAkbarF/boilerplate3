import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../../utilities/functions/logger_func.dart';
import '../../../utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';

class GoogleSignInProvider extends ChangeNotifier {
  GoogleSignInAccount? _user;
  bool _isInitialized = false;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSubscription;

  GoogleSignInAccount? get user => _user;
  bool get isInitialized => _isInitialized;

  /// Sebelum menggunakan SSO Google, pastikan Anda sudah mengaktifkan layanan Google Sign-In pada Firebase Authentication dan menambahkan kunci SHA1 dan SHA-256 pada Firebase
  /// Dapatkan kunci SHA1 dan SHA-256 dengan cara jalankan terminal pada folder android (bisa juga dengan klik kanan pada folder android > open in terminal)
  /// Ketik ./gradlew signInReport pada terminal, dan enter
  /// Cari atau search "Task :google_sign_in_android:signingReport" dan salin kunci SHA1 dan SHA-256
  /// Buka Firebase dan klik simbol gerigi disamping teks "Project Overview", lalu pilih "Project Setting"
  /// Pada tab "General", klik "Add Fingerprint" dan tambahkan satu persatu kunci SHA1 dan SHA-256

  /// Untuk Web, setelah membuat Google Sign-In, Tambahkan kode berikut dibawah kumpulan tag <meta> pada folder Web > index.html:
  /// <meta name="google-signin-client_id" content="YOUR_CLIENT_ID.apps.googleusercontent.com">
  /// <script src="https://accounts.google.com/gsi/client" async defer></script>
  /// dan kode berikut dibawah tag <body>:
  /// <div id="g_id_signin"></div>
  /// <script src="main.dart.js" type="application/javascript"></script>
  /// Kembali ke Firebase Authentification lalu klik opsi Google pada Sign-In Providers dan klik pada Web SDK configuration
  /// Salin Web client ID
  /// Pada index.html, Ganti "YOUR_CLIENT_ID.apps.googleusercontent.com" dengan Web client ID yang didapat

  /// Jika terjadi error berikut: 403, "People API has not been used in project xxx before or it is disabled., klik link yang tampil dan aktifkan People API
  /// Klik "Enable" dan tunggu proses selesai
  /// Selesai diaktifkan, Anda harus mendapatkan kredensial untuk dapat menggunakan People API. Akan muncul peringatan diatas layar, dan klik "Create Credentials"
  /// Pilih "People API" dan "User Data", lalu klik "Next"
  /// Isi data yang nantinya akan ditampilkan di dialog OAuth (Dialog untuk pemilihan email), lalu klik "Save and Continue"
  /// Klik "Add or Remove Scopes", dan tambahkan 2 scope berikut:
  /// .../auth/userinfo.email
  /// .../auth/userinfo.profile
  /// Setelah itu klik "Save and Continue"
  /// Pada Application Type, pilih "Web Application" karena Flutter Web memerlukan kredensial ini
  /// Pada Name, isi sesuai dengan kebutuhan Anda
  /// Pada Authorized JavaScript origins, tambahkan url domain Anda (Jika lokal, tambahkan http://localhost atau http://localhost:5000)
  /// Pada Authorized redirect URIs, tambahkan url domain Anda (Jika lokal, tambahkan http://localhost atau http://localhost:5000)
  /// Kemudian klik "Create", tunggu hingga proses selesai kemudian download file .json
  /// Terakhir, klik "Done"
  Future<void> initialize({String? clientId, String? serverClientId}) async {
    if (_isInitialized) return;
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;
      await signIn.initialize(clientId: clientId, serverClientId: serverClientId);
      _authSubscription = signIn.authenticationEvents.listen(_handleAuthenticationEvent, onError: _handleAuthenticationError);
      await signIn.attemptLightweightAuthentication();
      _isInitialized = true;
      notifyListeners();
    } catch (e, s) {
      clog('Terjadi kesalahan pada GoogleSignInProvider _initialize: $e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    }
  }

  // Handle authentication events
  Future<void> _handleAuthenticationEvent(GoogleSignInAuthenticationEvent event) async {
    final GoogleSignInAccount? user = switch (event) {GoogleSignInAuthenticationEventSignIn() => event.user, GoogleSignInAuthenticationEventSignOut() => null};
    _user = user;
    notifyListeners();
    if (user != null) {
      await _signInWithFirebase(user);
    } else {
      await FirebaseAuth.instance.signOut();
    }
  }

  // Handle authentication errors
  Future<void> _handleAuthenticationError(Object error) async {
    clog('Terjadi kesalahan pada GoogleSignInProvider _handleAuthenticationError: \n$error');
    await addLogApp(level: ListLogAppLevel.critical.level, title: 'Terjadi kesalahan pada GoogleSignInProvider _handleAuthenticationError', logs: error.toString());
    _user = null;
    notifyListeners();
  }

  // Sign in with Firebase using Google credentials
  Future<void> _signInWithFirebase(GoogleSignInAccount googleUser) async {
    try {
      final credential = GoogleAuthProvider.credential(idToken: googleUser.authentication.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, s) {
      clog('Terjadi kesalahan pada GoogleSignInProvider _signInWithFirebase: $e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    }
  }

  Future<bool> googleLogin(BuildContext context) async {
    try {
      if (kIsWeb){
        /// Implementasi login untuk web
        return false;
      } else {
        if (!_isInitialized) await initialize();
        if (GoogleSignIn.instance.supportsAuthenticate()) {
          await GoogleSignIn.instance.authenticate();
          return _user != null;
        } else {
          clog('Platform tidak mendukung autektikasi!');
          await addLogApp(level: ListLogAppLevel.severe.level, title: 'Platform tidak mendukung autektikasi!', logs: '');
          return false;
        }
      }
    } on FirebaseAuthException catch (e) {
      clog('FirebaseAuthException saat Google Sign-In: ${e.message}');
      await addLogApp(level: ListLogAppLevel.critical.level, title: 'FirebaseAuthException saat Google Sign-In', logs: e.toString());
      return false;
    } catch (e, s) {
      clog('Terjadi masalah saat login menggunakan SSO Google: $e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  Future<bool> googleLogout(BuildContext context) async {
    try {
      if (kIsWeb) {
        /// Implementasi logout untuk web
        return false;
      } else {
        await GoogleSignIn.instance.disconnect();
        _user = null;
        notifyListeners();
        return true;
      }
    } catch (e, s) {
      clog('Terjadi masalah saat logout menggunakan SSO Google: $e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
      return true;
    } catch (e, s) {
      clog('Terjadi kesalahan pada GoogleSignInProvider signOut: $e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  static GoogleSignInProvider watch(BuildContext context) => context.watch();
  static GoogleSignInProvider read(BuildContext context) => context.read();
}