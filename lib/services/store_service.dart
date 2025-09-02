import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'auth_storage_service.dart';

class StoreService {
  final Dio _dio = Dio();
  final AuthStorageService _authStorage = AuthStorageService();

  StoreService() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: ApiConfig.connectionTimeout);
    _dio.options.receiveTimeout = const Duration(milliseconds: ApiConfig.receiveTimeout);
    _dio.options.headers = ApiConfig.defaultHeaders;

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _authStorage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }

  Future<Map<String, dynamic>> createStore(Map<String, dynamic> store, {bool isPrimary = true}) async {
    final payload = {
      'store_name': store['name'] ?? store['store_name'],
      'address': store['address'],
      'road_address': store['roadAddress'] ?? store['road_address'],
      'phone': store['phone'],
      'category': store['businessType'] ?? store['category'],
      'coordinates_x': store['coordinates_x'],
      'coordinates_y': store['coordinates_y'],
      'place_id': store['place_id'],
      'map_url': store['map_url'],
      'is_primary': isPrimary,
    }..removeWhere((key, value) => value == null || (value is String && value.isEmpty));

    final response = await _dio.post('/api/stores', data: payload);
    return Map<String, dynamic>.from(response.data['data'] ?? {});
  }

  Future<Map<String, dynamic>> updateStore(String id, Map<String, dynamic> store) async {
    final payload = {
      if (store['name'] != null) 'store_name': store['name'],
      if (store['address'] != null) 'address': store['address'],
      if (store['roadAddress'] != null) 'road_address': store['roadAddress'],
      if (store['phone'] != null) 'phone': store['phone'],
      if (store['businessType'] != null) 'category': store['businessType'],
      if (store['coordinates_x'] != null) 'coordinates_x': store['coordinates_x'],
      if (store['coordinates_y'] != null) 'coordinates_y': store['coordinates_y'],
      if (store['place_id'] != null) 'place_id': store['place_id'],
      if (store['map_url'] != null) 'map_url': store['map_url'],
    }..removeWhere((key, value) => value == null || (value is String && value.isEmpty));

    final response = await _dio.patch('/api/stores/$id', data: payload);
    return Map<String, dynamic>.from(response.data['data'] ?? {});
  }
}


