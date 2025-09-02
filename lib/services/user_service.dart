import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'auth_storage_service.dart';

class UserService {
  final Dio _dio = Dio();
  final AuthStorageService _auth = AuthStorageService();

  UserService() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: ApiConfig.connectionTimeout);
    _dio.options.receiveTimeout = const Duration(milliseconds: ApiConfig.receiveTimeout);
    _dio.options.headers = ApiConfig.defaultHeaders;
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      final token = await _auth.getAccessToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
      handler.next(options);
    }));
  }

  Future<Map<String, dynamic>> getMe() async {
    final res = await _dio.get('/api/auth/me');
    return Map<String, dynamic>.from(res.data['user'] ?? {});
  }

  Future<List<Map<String, dynamic>>> listStores() async {
    final res = await _dio.get('/api/stores');
    final List data = (res.data['data'] ?? []) as List;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}


