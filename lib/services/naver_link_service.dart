import 'dart:async';
import 'package:dio/dio.dart';

class NaverLinkService {
  static const String baseUrl = 'https://your-api-endpoint.com';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
      validateStatus: (code) => code != null && code >= 200 && code < 300,
    ),
  );

  Future<Map<String, dynamic>> login({required String userId, required String password, bool agreed = false}) async {
    final res = await _dio.post(
      '$baseUrl/naver/login',
      data: {
        'userId': userId,
        'password': password,
        'agreed': agreed,
      },
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    final data = res.data;
    if (data is Map<String, dynamic>) return data;
    return {'data': data};
  }

  Future<Map<String, dynamic>> status() async {
    final res = await _dio.get('$baseUrl/naver/status');
    final data = res.data;
    if (data is Map<String, dynamic>) return data;
    return {'data': data};
  }

  Future<Map<String, dynamic>> unlink() async {
    final res = await _dio.post('$baseUrl/naver/unlink');
    final data = res.data;
    if (data is Map<String, dynamic>) return data;
    return {'data': data};
  }

  Future<Map<String, dynamic>> relink() async {
    final res = await _dio.post('$baseUrl/naver/relink');
    final data = res.data;
    if (data is Map<String, dynamic>) return data;
    return {'data': data};
  }

  Future<Map<String, dynamic>> scrape() async {
    final res = await _dio.post('$baseUrl/naver/scrape');
    final data = res.data;
    if (data is Map<String, dynamic>) return data;
    return {'data': data};
  }
} 