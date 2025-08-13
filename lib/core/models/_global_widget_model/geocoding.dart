class GeocodingModel{
  final double latitude;
  final double longitude;
  final String? address;

  GeocodingModel({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}