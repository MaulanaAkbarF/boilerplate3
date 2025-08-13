import 'package:geocoding/geocoding.dart';

extension PlacemarkFullAddress on Placemark {
  String get fullAddress {
    List<String> data = [];
    if (administrativeArea?.isNotEmpty ?? false) data.add(administrativeArea!);
    if (subAdministrativeArea?.isNotEmpty ?? false) data.add(subAdministrativeArea!);
    if (locality?.isNotEmpty ?? false) data.add(locality!);
    if (subLocality?.isNotEmpty ?? false) data.add(subLocality!);
    if (thoroughfare?.isNotEmpty ?? false) data.add(thoroughfare!);
    if (subThoroughfare?.isNotEmpty ?? false) data.add(subThoroughfare!);
    if (postalCode?.isNotEmpty ?? false) data.add(postalCode!);

    return data.join(", ");
  }
}