import 'logger_func.dart';

/// Melakukan parsing tipe data dari response API dan mengubahnya menjadi tipe data String jika respon tipe data dari API selain String
String funcResponseToString(dynamic data){
  try {
    if (data == null) return "-";
    if (data.runtimeType != String) clog('Respon Tipe Data Tidak Sesuai! responseToString. Runtime Diterima: ${data.runtimeType}');
    return data.toString();
  } catch (e, s) {
    clog('Terjadi masalah saat responseToString: $e\n$s');
    return "-";
  }
}

/// Melakukan parsing tipe data dari response API dan mengubahnya menjadi tipe data int jika respon tipe data dari API selain int
int funcResponseToInt(dynamic data){
  try {
    if (data == null) return 0;
    if (data.runtimeType != int) clog('Respon Tipe Data Tidak Sesuai! responseToInt. Runtime Diterima: ${data.runtimeType}');
    switch (data.runtimeType){
      case String : return int.tryParse(data.toString()) ?? 0;
      case int : return int.parse(data.toString());
      case double : return int.tryParse(data.toString()) ?? 0;
      case bool :
        if (data == true) return -0;
        if (data == false) return -1;
    }
    return 0;
  } catch (e, s) {
    clog('Terjadi masalah saat responseToInt: $e\n$s');
    return 0;
  }
}

/// Melakukan parsing tipe data dari response API dan mengubahnya menjadi tipe data double jika respon tipe data dari API selain double
double funcResponseToDouble(dynamic data){
  try {
    if (data == null) return 0.0;
    if (data.runtimeType != double) clog('Respon Tipe Data Tidak Sesuai! responseToDouble. Runtime Diterima: ${data.runtimeType}');
    switch (data.runtimeType){
      case String : return double.tryParse(data.toString()) ?? 0.0;
      case int : return double.parse(data.toString());
      case double : return double.tryParse(data.toString()) ?? 0.0;
      case bool :
        if (data.toString() == "true") return -0.0;
        if (data.toString() == "false") return -1.0;
    }
    return 0.0;
  } catch (e, s) {
    clog('Terjadi masalah saat responseToDouble: $e\n$s');
    return 0.0;
  }
}