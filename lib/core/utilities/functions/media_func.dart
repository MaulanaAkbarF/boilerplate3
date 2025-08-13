import 'dart:io';

import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/permission/hardware_permission.dart';
import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/permission/storage_permission.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../constant_values/_setting_value/log_app_values.dart';
import '../../constant_values/_utlities_values.dart';
import '../local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import 'logger_func.dart';

/// Fungsi untuk mendapatkan File gambar/video yang diambil dari kamera
Future<XFile?> getMediaFromCamera({bool? requestVideo}) async {
  try {
    bool hasPermission = await getCameraPermission(requestVideo: requestVideo);
    if (hasPermission){
      if (requestVideo != null && requestVideo){
        XFile? selectedMedia = await ImagePicker().pickVideo(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear, maxDuration: Duration(hours: 24));
        return selectedMedia;
      } else {
        XFile? selectedMedia = await ImagePicker().pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear, imageQuality: 100);
        return selectedMedia;
      }
    }
    return null;
  } catch (e, s){
    clog('Terjadi masalah saat getMediaFromCamera: $e\n$s');
    await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    return null;
  }
}

/// Fungsi untuk mendapatkan File gambar/video yang diambil dari galeri ponsel
Future<XFile?> getMediaFromGallery({bool? accessVideoFromGallery}) async {
  try {
    bool hasPermission = await getGalleryPermission(accessVideoFromGallery: accessVideoFromGallery);
    if (hasPermission){
      if (accessVideoFromGallery != null && accessVideoFromGallery){
        XFile? selectedImage = await ImagePicker().pickVideo(source: ImageSource.gallery);
        return selectedImage;
      } else {
        XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
        return selectedImage;
      }
    }
    return null;
  } catch (e, s){
    clog('Terjadi masalah saat getMediaFromGallery: $e\n$s');
    await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    return null;
  }
}

/// Fungsi untuk menyimpan File gambar/video
Future<bool> saveFileToLocalStorage({required XFile file, ListMediaFolder? rootFolder, String? newFolder}) async {
  Directory? mainDirectory;
  String rootPath;
  try{
    if (rootFolder != null){
      bool hasPermission = await getExternalStoragePermission();
      if (hasPermission){
        mainDirectory = await getExternalStorageDirectory();
        if (mainDirectory != null){
          rootPath = '${mainDirectory.path.split('Android')[0]}${rootFolder.path}/${file.path}';
          if (newFolder != null) rootPath = '${mainDirectory.path.split('Android')[0]}${rootFolder.path}/$newFolder/${file.path}';
          final savedFile = await File(file.path).copy(rootPath);
          clog('File berhasil disimpan di: ${savedFile.path}');
          return true;
        } else {
          clog('Tidak mendapatkan External Direktori');
          return false;
        }
      } else {
        clog('Tidak diizinkan membaca file! Status: $hasPermission');
        return false;
      }
    } else {
      mainDirectory = await getApplicationDocumentsDirectory();
      rootPath = '${mainDirectory.path}/${file.name}';
      final savedFile = await File(file.path).copy(rootPath);
      clog('File berhasil disimpan di: ${savedFile.path}');
      return true;
    }
  } catch (e, s) {
    clog('Terjadi masalah saat menyimpan file ke Local Storage: $e\n$s');
    await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    return false;
  }
}

/// Fungsi untuk melakukan kompresi file gambar
Future<Uint8List?> compressImage(String path) async {
  try {
    final bytes = await File(path).readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) return null;
    return Uint8List.fromList(img.encodeJpg(img.copyResize(image, width: 800), quality: 10));
  } catch (e, s) {
    clog('Terjadi masalah saat mengompres gambar: $e\n$s');
    await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    return null;
  }
}