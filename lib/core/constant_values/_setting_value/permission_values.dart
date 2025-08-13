import 'package:geolocator/geolocator.dart';

enum GetPermissionType {
  locationDisabled(),
  locationWhileInUse(),
  locationDenied(),
  locationDeniedForever(),
  locationAlways(),
  locationUnableToDetermine(),
  notificationGranted(),
  notificationDenied(),
  notificationFirebaseDenied();

  const GetPermissionType();
}

enum ListLocationPermission {
  whileInUse("Diizinkan", LocationPermission.whileInUse),
  denied("Ditolak", LocationPermission.denied),
  deniedForever("Ditolak Permanen", LocationPermission.deniedForever),
  always("Selalu Aktif", LocationPermission.always),
  unableToDetermine("Tidak Teridentifikasi", LocationPermission.unableToDetermine);

  final String text;
  final LocationPermission permission;
  const ListLocationPermission(this.text, this.permission);
}

enum ListNotificationPermission {
  authorized("Diizinkan"),
  denied("Ditolak"),
  notDetermined("Tidak Ditentukan"),
  provisional("Sementara");

  final String text;
  const ListNotificationPermission(this.text);
}