enum ScannerState {
  prepare("Sedang menyiapkan pemindaian"),
  scanning("Mulai memindai..."),
  analyze("Sedang menganalisa..."),
  finished("Analisa selesai!"),
  action("Mohon tunggu sebentar..."),
  completed("Proses selesai, anda sudah melakukan presensi..."),
  fails("Terjadi kegagalan saat memproses");

  final String text;
  const ScannerState(this.text);
}

enum GoogleMapsState {
  initial("Mengisiasi..."),
  loading("Mencari Alamat..."),
  success("Alamat Ditemukan!"),
  failed("Alamat Tidak Ditemukan!"),
  onSearch("Mencari Alamat");

  final String text;
  const GoogleMapsState(this.text);
}

enum MapSearchTechnology {
  openStreet("Cari Lokasi (OSM)"),
  googleMaps("Cari Lokasi (G-Maps)");

  final String text;
  const MapSearchTechnology(this.text);
}