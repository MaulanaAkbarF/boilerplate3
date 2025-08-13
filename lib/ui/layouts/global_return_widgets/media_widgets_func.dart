import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

import '../../../../ui/layouts/styleconfig/themecolors.dart';
import '../../../core/constant_values/_setting_value/log_app_values.dart';
import '../../../core/constant_values/global_values.dart';
import '../../../core/utilities/functions/logger_func.dart';
import '../../../core/utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import '../global_state_widgets/video_player/adaptive_chewie.dart';

Image loadDefaultAppLogoPNG({double? sizeLogo}) {
  return Image.asset('assets/icon/logo.png', width: sizeLogo ?? 120, height: sizeLogo ?? 120,);
}

SvgPicture loadDefaultAppLogoSVG({double? sizeLogo}) {
  return SvgPicture.asset('assets/icon/logo.svg', width: sizeLogo ?? 120, height: sizeLogo ?? 120,);
}

/// Fungsi untuk load gambar PNG dari assets
Image loadImageAssetPNG({required String path, double? width, double? height, Color? color, double? opacity}) {
  return Image.asset(path, width: width ?? 20, height: height ?? 20, color: color?.withValues(alpha: opacity ?? 1.0), fit: BoxFit.cover,
    errorBuilder: (context, e, s) {
      clog('Terjadi masalah ketika loadImageAssetPNG: $e\n$s');
      addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return Container(height: 100, width: double.infinity, color: Colors.transparent, child: Center(child: loadDefaultAppLogoSVG(sizeLogo: 100)));
    },
  );
}

/// Fungsi untuk load gambar SVG dari assets
SvgPicture loadImageAssetSVG({required String path, double? width, double? height, Color? color, double? opacity}) {
  return SvgPicture.asset(path, width: width ?? 20, height: height ?? 20, color: color?.withValues(alpha: opacity ?? 1.0), fit: BoxFit.cover,
    errorBuilder: (context, e, s) {
      clog('Terjadi masalah ketika loadImageAssetSVG: $e\n$s');
      addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return Container(height: 100, width: double.infinity, color: Colors.transparent, child: Center(child: loadDefaultAppLogoSVG(sizeLogo: 100)));
    },
  );
}

DecorationImage loadDecorationImage({required String path, double? width, double? height, Color? color, double? opacity}) {
  return DecorationImage(image: AssetImage(path), fit: BoxFit.cover,
    onError: (context, e) {
      clog('Terjadi masalah ketika loadImageAssetSVG: $e');
      addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: '');
    },
  );
}

/// Fungsi untuk load gambar XFile yang diambil dari kamera atau galeri ponsel
Image loadImageXFile({XFile? file, double? width, double? height, Color? color, double? opacity}) {
  return Image.file(File(file?.path ?? ''), width: width ?? 100, height: height ?? 100, color: color?.withValues(alpha: opacity ?? 1.0), fit: BoxFit.cover,
    errorBuilder: (context, e, s) {
      clog('Terjadi masalah ketika loadImageAssetXFile: $e\n$s');
      addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return Container(height: 100, width: double.infinity, color: Colors.transparent, child: Center(child: loadDefaultAppLogoSVG(sizeLogo: 100)));
    },
  );
}

/// Fungsi untuk load video XFile yang diambil dari kamera atau galeri ponsel menggunakan library video_player
Widget loadVideoXFile({XFile? file, double? width, double? height}) {
  if (file == null || file.path.isEmpty) {
    clog('Terjadi masalah ketika loadVideoAssetXFile: File tidak tersedia');
    addLogApp(level: ListLogAppLevel.severe.level, title: 'Terjadi masalah ketika loadVideoAssetXFile: File tidak tersedia', logs: '');
    return Container(width: width ?? double.infinity, height: height ?? 100, color: Colors.transparent, child: Center(child: loadDefaultAppLogoSVG(sizeLogo: 100)),);
  }

  VideoPlayerController videoController = VideoPlayerController.file(File(file.path));
  return FutureBuilder(
    future: videoController.initialize(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return SizedBox(width: width ?? double.infinity, height: height ?? 200, child: AspectRatio(aspectRatio: videoController.value.aspectRatio, child: VideoPlayer(videoController)));
      } else if (snapshot.hasError) {
        clog('Terjadi masalah ketika loadVideoAssetXFile. snapshot.hasError: ${snapshot.error}');
        addLogApp(level: ListLogAppLevel.severe.level, title: 'Terjadi masalah ketika loadVideoAssetXFile', logs: 'snapshot.hasError: ${snapshot.error}');
        return Container(width: width ?? double.infinity, height: height ?? 100, color: Colors.transparent, child: Center(child: loadDefaultAppLogoSVG(sizeLogo: 100)));
      } else {
        return Container(width: width ?? double.infinity, height: height ?? 100, color: Colors.transparent, child: Center(child: CircularProgressIndicator()));
      }
    },
  );
}

/// Fungsi untuk load video XFile yang diambil dari kamera atau galeri ponsel menggunakan library Chewie (video_player_plus)
Widget loadChewieVideoXFile({XFile? file, double? width, double? height}) {
  return AdaptiveChewiePlayer(file: file, width: width, height: height);
}

/// Fungsi untuk load gambar dari internet
Image loadImageNetwork({required String imageUrl, double? width, double? height}) {
  return Image.network(imageUrl, width: width ?? 20, height: height ?? 20, fit: BoxFit.cover,
    errorBuilder: (context, e, s) {
      clog('Terjadi masalah ketika loadImageNetwork: $e\n$s');
      addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return Container(height: 100, width: double.infinity, color: Colors.transparent, child: Center(child: loadDefaultAppLogoSVG(sizeLogo: 100)));
    },
  );
}

/// Fungsi untuk load animasi dari Lottie
LottieBuilder loadLottieAsset({required String path, double? width, double? height}) {
  return Lottie.asset(path, width: width ?? 200, height: height ?? 200, fit: BoxFit.cover,
    errorBuilder: (context, e, s) {
      clog('Terjadi masalah ketika loadLottieAsset: $e\n$s');
      addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return Container(height: 100, width: double.infinity, color: Colors.transparent, child: Center(child: loadDefaultAppLogoSVG(sizeLogo: 100)));
    },
  );
}

/// Fungsi untuk load gambar profil dari internet (dan penanganan default profile kosong)
Widget loadCircleImage({
  required BuildContext context,
  String? imageUrl,
  String? imageAssetPath,
  File? fileImage,
  Color? backgroundColor,
  double? radius,
}) {
  return CircleAvatar(
    minRadius: radius ?? 20,
    maxRadius: radius ?? 20,
    backgroundColor: backgroundColor ?? ThemeColors.greyVeryLowContrast(context),
    backgroundImage: fileImage != null ? FileImage(fileImage) : (imageUrl != null ? NetworkImage(imageUrl) : null),
    foregroundImage: fileImage != null ? FileImage(fileImage) : (imageUrl != null ? NetworkImage(imageUrl) : null),
    // onForegroundImageError: (e, s) => clog('Terjadi masalah saat loadCircleImage Foreground: $e\n$s'),
    // onBackgroundImageError: (e, s) => clog('Terjadi masalah saat loadCircleImage Background: $e\n$s'),
    child: fileImage == null && imageUrl == null
      ? (imageAssetPath != null
      ? loadImageAssetPNG(path: imageAssetPath, width: radius, height: radius)
        : Icon(Icons.person, size: iconBtnMid, color: ThemeColors.surface(context)))
        : Icon(Icons.person_2, size: iconBtnMid, color: ThemeColors.surface(context)),
  );
}