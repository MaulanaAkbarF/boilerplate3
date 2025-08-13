// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide User;
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:convert';

import 'package:boilerplate_3_firebaseconnect/core/utilities/extensions/primitive_data/string_ext.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/auth_model/data_user.dart';
import '../../../utilities/functions/logger_func.dart';
import 'google_sign_in_provider.dart';

class UserProvider extends ChangeNotifier {
  UserAuth? _auth;

  UserAuth? get auth => _auth;
  User? get user => _auth?.user;
  bool get isLoggedIn => _auth != null;

  /// Fungsi untuk mengisiasi data user di awal dengan mengambil data tersimpan di dalam Shared Preferences
  Future<void> initialize() async {
    var pref = await AuthHelper.instance();
    if (pref.userAuth != null) {
      _auth = pref.userAuth;
      notifyListeners();
    }
  }

  /// Fungsi ketika pengguna melakukan login dengan Google
  Future<bool?> loginWithGoogle({required BuildContext context}) async {
    try {
      final googleProvider = GoogleSignInProvider.read(context);
      final success = await googleProvider.googleLogin(context);
      if (!success || googleProvider.user == null) return false;
      final googleUser = googleProvider.user!;
      final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        clog('Firebase User Kosong!');
        return false;
      }

      final userAuth = UserAuth(
        isVerify: firebaseUser.emailVerified,
        accessToken: await firebaseUser.getIdToken() ?? '',
        user: User(id: firebaseUser.uid.hashCode, name: googleUser.displayName ?? '', email: googleUser.email, photoUrl: googleUser.photoUrl),
      );
      await setAuth(userAuth);
      return true;
    } catch (e) {
      clog('Login Error: $e');
      return false;
    }
  }

  /// Fungsi ketika pengguna melakukan login manual (jika ada)
  Future<bool?> login({required BuildContext context, required String email, required String name}) async {
    try {
      final userAuth = UserAuth(
        isVerify: true,
        accessToken: 'manual_token_${DateTime.now().millisecondsSinceEpoch}',
        user: User(id: DateTime.now().millisecondsSinceEpoch, name: name, email: email, photoUrl: null),
      );
      await setAuth(userAuth);
      return true;
    } catch (e) {
      clog('Manual Login Error: $e');
      return false;
    }
  }

  /// Fungsi ketika token pengguna saat ini sudah kadaluarsa/expires/unauthenticated
  Future<void> refresh({required BuildContext context}) async {
    try {
      final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser != null && _auth != null) {
        final newToken = await firebaseUser.getIdToken(true);
        await setAuth(UserAuth(isVerify: _auth!.isVerify, accessToken: newToken ?? '', user: _auth!.user));
        clog('Token refreshed successfully');
      }
    } catch (e) {
      clog('Refresh Token Error: $e');
      await logout(context);
    }
  }

  /// Fungsi untuk menetapkan data Auth/User aktif saat ini dan menyimpannya ke Shared Preferences
  Future<void> setAuth(UserAuth? value) async {
    _auth = value;
    await AuthHelper.instance().then((shared) => shared.userAuth = _auth);
    if (_auth == null) clog('Auth Kosong!');
    if (_auth != null) clog('Berhasil menetapkan UserAuth!\n${jsonEncode(_auth?.toJson()).convertToJsonStyle}');
    notifyListeners();
  }

  /// Fungsi ketika pengguna melakukan logout
  Future<void> logout(BuildContext context) async {
    try {
      await GoogleSignInProvider.read(context).googleLogout(context);
      await firebase_auth.FirebaseAuth.instance.signOut();
      await setAuth(null);
      clog('Logout berhasil');
    } catch (e) {
      clog('Logout Error: $e');
      await setAuth(null);
    }
  }

  /// Fungsi untuk mengecek apakah user masih terautentikasi
  Future<bool> isAuthenticated() async {
    if (_auth == null) return false;
    try {
      final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
      return firebaseUser != null;
    } catch (e) {
      return false;
    }
  }

  static UserProvider read(BuildContext context) => context.read();
  static UserProvider watch(BuildContext context) => context.watch();
}

/// Class untuk menyimpan data Auth Setting ke dalam Shared Preferences
class AuthHelper {
  final SharedPreferences shared;

  AuthHelper(this.shared);

  set userAuth(UserAuth? userAuth) {
    if (userAuth == null) {
      shared.remove("auth");
    } else {
      shared.setString("auth", jsonEncode(userAuth.toJson()));
    }
  }

  UserAuth? get userAuth {
    if (shared.getString("auth") != null) return UserAuth.fromJson(jsonDecode(shared.getString("auth")!));
    return null;
  }

  static Future<AuthHelper> instance() => SharedPreferences.getInstance().then((value) => AuthHelper(value));
}
