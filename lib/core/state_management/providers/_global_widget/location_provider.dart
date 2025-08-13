import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../../models/_global_widget_model/geocoding.dart';
import '../../../utilities/functions/logger_func.dart';
import '../../../utilities/functions/system_func.dart';
import '../../../utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import '../_settings/permission_provider.dart';

class LocationSettingProvider extends ChangeNotifier{
  GeocodingModel _geocodingModel = GeocodingModel(latitude: 0, longitude: 0, address: '');
  String _thoroughfare = '';
  String _subThoroughfare = '';
  String _subLocality = '';
  String _locality = '';
  String _subAdministrativeArea = '';
  String _administrativeArea = '';
  String _postalCode = '';
  String _country = '';

  GeocodingModel get geocodingModel => _geocodingModel;
  String get thoroughfare => _thoroughfare;
  String get subThoroughfare => _subThoroughfare;
  String get subLocality => _subLocality;
  String get locality => _locality;
  String get subAdministrativeArea => _subAdministrativeArea;
  String get administrativeArea => _administrativeArea;
  String get postalCode => _postalCode;
  String get country => _country;

  /// Fungsi untuk mendapatkan data Latitude, Longitude dan alamat pengguna pada posisi saat ini
  /// Kasih dialogContext ketika pemanggilan fungsi ini untuk menampilkan dialog pemberitahuan [Direkomendasikan]
  Future<GeocodingModel> getCurrentUserLocation(BuildContext context, {BuildContext? dialogContext}) async {
    try {
      bool conn = await checkInternetConnectivity();
      if (!conn) return GeocodingModel(latitude: 0, longitude: 0, address: '');
      bool resp = await PermissionSettingProvider.read(context).requestLocationPermission(context: dialogContext);
      if (!resp) return GeocodingModel(latitude: 0, longitude: 0, address: '');
      final Position initPosition = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high)); // Prosesnya agak lama disini
      String address = await getCurrentUserAddress(initPosition.latitude, initPosition.longitude);
      _geocodingModel = GeocodingModel(latitude: initPosition.latitude, longitude: initPosition.longitude, address: address);
      notifyListeners(); // Data geocoding akan diperbarui jika berhasil mendapatkan data terbaru
      clog('Lokasi Anda Didapatkan!: [Alamat: ${_geocodingModel.address}], [Latitude: ${_geocodingModel.latitude}], [Longitude: ${_geocodingModel.longitude}]');
      return _geocodingModel;
    } catch (e, s) {
      clog('Terjadi masalah saat getCurrentUserLocation: $e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return GeocodingModel(latitude: 0, longitude: 0, address: '');
    }
  }

  /// Fungsi untuk mendapatkan data alamat pengguna pada posisi saat ini
  Future<String> getCurrentUserAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return 'Alamat Tidak Ditemukan';

      List<String> addressParts = [];
      List<String> jalanParts = [];

      void addPart(String? part, List<String> list) {
        if (part != null && part.isNotEmpty) list.add(part);
      }

      addPart(placemarks[0].thoroughfare, jalanParts);
      addPart(placemarks[0].subThoroughfare, jalanParts);
      String jalan = jalanParts.join(' ');
      if (jalan.isNotEmpty) addPart(jalan, addressParts);
      addPart(placemarks[0].subLocality, addressParts);
      addPart(placemarks[0].locality, addressParts);
      addPart(placemarks[0].subAdministrativeArea, addressParts);
      addPart(placemarks[0].administrativeArea, addressParts);
      addPart(placemarks[0].postalCode, addressParts);
      addPart(placemarks[0].country, addressParts);

      _thoroughfare = placemarks[0].thoroughfare ?? '';
      _subThoroughfare = placemarks[0].subThoroughfare ?? '';
      _subLocality = placemarks[0].subLocality ?? '';
      _locality = placemarks[0].locality ?? '';
      _subAdministrativeArea = placemarks[0].subAdministrativeArea ?? '';
      _administrativeArea = placemarks[0].administrativeArea ?? '';
      _postalCode = placemarks[0].postalCode ?? '';
      _country = placemarks[0].country ?? '';
      return addressParts.join(', ');
    } catch (e, s) {
      clog('Terjadi masalah saat getCurrentUserAddress: $e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return 'Alamat Tidak Ditemukan';
    }
  }

  /// Fungsi untuk mendapatkan data Latitude, Longitude dari sebuah alamat
  Future<GeocodingModel> getUserLatLong({required String kelurahan, required String kecamatan, required String kota, required String provinsi}) async {
    try {
      String address = '$kelurahan, $kecamatan, $kota, $provinsi, Indonesia';
      bool conn = await checkInternetConnectivity();
      if (!conn) return GeocodingModel(latitude: 0, longitude: 0, address: '');
      List<Location> locations = await locationFromAddress(address);
      if (locations.isEmpty) return GeocodingModel(latitude: 0, longitude: 0, address: address);
      _geocodingModel = GeocodingModel(latitude: locations.first.latitude, longitude: locations.first.longitude, address: address);
      notifyListeners(); // Data geocoding akan diperbarui jika berhasil mendapatkan data terbaru
      return _geocodingModel;
    } catch (e, s) {
      clog('Terjadi masalah saat getUserLatLong: $e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return GeocodingModel(latitude: 0, longitude: 0, address: '');
    }
  }

  /// Fungsi untuk mendapatkan data alamat dari latitude dan longitude pada Google Maps
  Future<void> getLocationFromMaps(double latitude, double longitude) async {
    bool conn = await checkInternetConnectivity();
    if (!conn) return;
    await getCurrentUserAddress(latitude, longitude).then((value) => _geocodingModel = GeocodingModel(latitude: latitude, longitude: longitude, address: value));
    notifyListeners();
  }

  /// Fungsi untuk mereset semua value
  void reset(){
    _geocodingModel = GeocodingModel(latitude: 0, longitude: 0, address: '');
    _thoroughfare = '';
    _subThoroughfare = '';
    _subLocality = '';
    _locality = '';
    _subAdministrativeArea = '';
    _administrativeArea = '';
    _postalCode = '';
    _country = '';
  }

  static LocationSettingProvider read(BuildContext context) => context.read();
  static LocationSettingProvider watch(BuildContext context) => context.watch();
}