import 'dart:async';
import 'package:dio/dio.dart';
import 'package:mybiz_app/services/api_client.dart';
import 'package:mybiz_app/services/auth_storage_service.dart';

class NaverLinkService {
  final Dio _dio = ApiClient().dio;
  final AuthStorageService _auth = AuthStorageService();

  Future<Map<String, dynamic>> setup({
    required String userStoreId,
    required String username,
    required String password,
  }) async {
    final headers = await _authHeaders();
    final res = await _dio.post(
      '/api/naver-credentials/setup',
      data: {
        'userStoreId': userStoreId,
        'username': username,
        'password': password,
      },
      options: Options(headers: headers),
    );
    return _ensureMap(res.data);
  }

  Future<Map<String, dynamic>> status({
    required String userStoreId,
  }) async {
    final headers = await _authHeaders();
    final res = await _dio.get(
      '/api/naver-credentials/status/$userStoreId',
      options: Options(headers: headers),
    );
    return _ensureMap(res.data);
  }

  Future<Map<String, dynamic>> test({
    required String userStoreId,
  }) async {
    final headers = await _authHeaders();
    final res = await _dio.post(
      '/api/naver-credentials/test/$userStoreId',
      options: Options(headers: headers),
    );
    return _ensureMap(res.data);
  }

  Future<Map<String, dynamic>> unlink({
    required String userStoreId,
  }) async {
    final headers = await _authHeaders();
    final res = await _dio.delete(
      '/api/naver-credentials/$userStoreId',
      options: Options(headers: headers),
    );
    return _ensureMap(res.data);
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await _auth.getAccessToken();
    if (token == null || token.isEmpty) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        message: '인증 토큰이 없습니다. 다시 로그인 해주세요.',
        type: DioExceptionType.badResponse,
      );
    }
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _ensureMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    return {'data': data};
  }
}