import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../constant_values/_setting_value/log_app_values.dart';
import '../../constant_values/_utlities_values.dart';
import '../../state_management/providers/auth/user_provider.dart';
import '../../utilities/functions/logger_func.dart';
import '../../utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import '_global_url.dart';

Response? failedResponse;
Dio globalDio = Dio(
  BaseOptions(
    baseUrl: ApiService.getEndpoint(),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    validateStatus: (status) => true,
  ),
);

abstract class HttpConnection {
  final BuildContext context;

  Dio get _dio => globalDio;

  HttpConnection(this.context);

  /// Fungsi untuk melakukan request ke API.
  Future dioRequest(DioMethod method, String url, {Map<String, String>? params, dynamic body, dynamic headers, bool pure = false}) async {
    try {
      clog(url);
      headers = _preRequestHeaders(headers);
      Response resp;
      switch (method){
        case DioMethod.get: resp = await _dio.get(url + paramsToString(params), options: Options(headers: headers));
        case DioMethod.post: resp = await _dio.post(url + paramsToString(params), data: body, options: Options(headers: headers));
        case DioMethod.put: resp = await _dio.put(url + paramsToString(params), data: body, options: Options(headers: headers));
        case DioMethod.delete: resp = await _dio.delete(url + paramsToString(params), data: body, options: Options(headers: headers));
      }

      clog("Request Body: ${paramsToString(params)}\nHeader: $headers\nURL: $url\nResponse Data: ${resp.data}");
      if (!_postRequestHeaders(resp)) return;
      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } on DioException catch (e, s) {
      clog('DioException. Terjadi kesalahan saat mengakses Endpoint: $url.\n$e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, statusCode: failedResponse?.statusCode, title: e.toString(), logs: s.toString());
      throw HttpErrorConnection(status: e.response?.statusCode ?? -1, message: e.message ?? "Application internal error");
    } catch (e, s) {
      clog('Terjadi kesalahan saat mengakses Endpoint: $url.\n$e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, statusCode: failedResponse?.statusCode, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  /// Tambahkan headers apapun sebelum melakukan request ke API
  Map<String, String>? _preRequestHeaders(Map<String, String>? headers) {
    var userProvider = UserProvider.read(context);
    /// Jika terdapat access token, header akan selalu/wajib ditambahkan Bearer Token
    if (userProvider.auth?.accessToken != null) {
      if (headers != null) {
        headers.addEntries([MapEntry("Authorization", "Bearer ${userProvider.auth?.accessToken}")]);
      } else {
        headers = {"Authorization": "Bearer ${userProvider.auth?.accessToken}"};
      }
    }
    return headers;
  }

  bool _postRequestHeaders(Response response) {
    if (response.statusCode == null) throw Exception("Application error on requests");
    if (response.statusCode == 401) {
      ///Implement refresh token ketimbang suruh user login lagi
      UserProvider.read(context).refresh(context: context);
      throw HttpErrorConnection(status: 401, message: "Token expired");
    }
    if (response.statusCode! > 300) {
      failedResponse = response;
      if (response.data is Map<String, dynamic>) {
        if ((response.data as Map<String, dynamic>).containsKey("message")) {
          throw HttpErrorConnection(status: response.statusCode!, message: "${response.data["message"]}");
        } else {
          throw HttpErrorConnection(status: response.statusCode!, message: response.statusMessage!);
        }
      } else {
        throw HttpErrorConnection(status: response.statusCode!, message: response.data!);
      }
    }
    return true;
  }

  static String paramsToString(Map<String, String>? params) {
    if (params == null) return "";
    String output = "?";
    params.forEach((key, value) {
      output += "$key=$value&";
    });
    return output.substring(0, output.length - 1);
  }
}

class ApiResponse<T> extends Model {
  ApiResponse({
    this.message,
    this.data,
    required this.status,
  });

  final int status;
  bool get success => status >= 200 && status < 300;
  String? message;
  T? data;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    status: json["status"] ?? 999,
    message: json["message"] ?? '',
    data: json["result"] ?? [],
  );

  @override
  Map<String, dynamic> toJson() => {
    "status": status,
    "success": success,
    "message": message,
    "result": data,
  };
}

class HttpErrorConnection implements Exception {
  final int status;
  final String message;

  HttpErrorConnection({required this.status, required this.message});

  @override
  String toString() {
    return "Error $status, $message";
  }
}

abstract class Model {
  Map<String, dynamic> toJson();

  @override
  String toString() => toJson().toString();
}
