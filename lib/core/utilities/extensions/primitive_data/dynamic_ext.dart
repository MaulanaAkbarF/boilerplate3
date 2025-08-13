extension DynamicManipulator on dynamic {
  /// Melakukan parsing tipe data dari response API dan mengubahnya menjadi tipe data String jika respon tipe data dari API selain String
  String get responseToString{
    try {
      if (this == null) return "-";
      if (runtimeType != String) clog('Respon Tipe Data Tidak Sesuai! responseToString. Runtime Diterima: $runtimeType');
      return toString();
    } catch (e, s) {
      clog('Terjadi masalah saat responseToString: $e\n$s');
      return "-";
    }
  }

  /// Melakukan parsing tipe data dari response API dan mengubahnya menjadi tipe data int jika respon tipe data dari API selain int
  int get responseToInt{
    try {
      if (this == null) return 0;
      if (runtimeType != int) clog('Respon Tipe Data Tidak Sesuai! responseToInt. Runtime Diterima: $runtimeType');
      switch (runtimeType){
        case String : return int.tryParse(toString()) ?? 0;
        case int : return int.parse(toString());
        case double : return int.tryParse(toString()) ?? 0;
        case bool :
          if (this == true) return -0;
          if (this == false) return -1;
      }
      return 0;
    } catch (e, s) {
      clog('Terjadi masalah saat responseToInt: $e\n$s');
      return 0;
    }
  }

  /// Melakukan parsing tipe data dari response API dan mengubahnya menjadi tipe data double jika respon tipe data dari API selain double
  double get responseToDouble{
    try {
      if (this == null) return 0.0;
      if (runtimeType != double) clog('Respon Tipe Data Tidak Sesuai! responseToDouble. Runtime Diterima: $runtimeType');
      switch (runtimeType){
        case String : return double.tryParse(toString()) ?? 0.0;
        case int : return double.parse(toString());
        case double : return double.tryParse(toString()) ?? 0.0;
        case bool :
          if (toString() == "true") return -0.0;
          if (toString() == "false") return -1.0;
      }
      return 0.0;
    } catch (e, s) {
      clog('Terjadi masalah saat responseToDouble: $e\n$s');
      return 0.0;
    }
  }

  /// Melakukan parsing tipe data dari response API dan mengubahnya menjadi tipe data boolean jika respon tipe data dari API selain boolean
  bool get responseToBool{
    try {
      if (this == null) return false;
      if (runtimeType != bool) clog('Respon Tipe Data Tidak Sesuai! responseToBool. Runtime Diterima: $runtimeType');
      switch (runtimeType){
        case String : {
          if (this == '0' || this == '-0') return true;
          if (this == '1' || this == '-1') return false;
        }
        case int : {
          if (this == 0 || this == -0) return true;
          if (this == 1 || this == -1) return false;
        }
        case double : {
          if (this == 0.0 || this == -0.0) return true;
          if (this == 1.0 || this == -1.0) return false;
        }
        case bool : return this;
      }
      return false;
    } catch (e, s) {
      clog('Terjadi masalah saat responseToDouble: $e\n$s');
      return false;
    }
  }
}