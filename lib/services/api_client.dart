import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  Dio? _dio;

  Dio get dio {
    _dio ??= Dio(
      BaseOptions(
        baseUrl: _defaultDevBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        validateStatus: (code) => code != null && code >= 200 && code < 300,
      ),
    );
    return _dio!;
  }

  String _defaultDevBaseUrl() {
    if (kIsWeb) {
      return 'http://127.0.0.1:4000';
    }
    if (Platform.isAndroid) {
      // Android 에뮬레이터에서 호스트의 localhost
      return 'http://10.0.2.2:4000';
    }
    return 'http://127.0.0.1:4000';
  }
}


