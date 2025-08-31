import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'auth_storage_service.dart';

class ReviewScraperService {
  final Dio _dio = Dio();
  final AuthStorageService _auth = AuthStorageService();

  ReviewScraperService() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: ApiConfig.connectionTimeout);
    _dio.options.receiveTimeout = const Duration(milliseconds: ApiConfig.receiveTimeout);
    _dio.options.headers = Map<String, dynamic>.from(ApiConfig.defaultHeaders);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _auth.getAccessToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }

  Future<Map<String, dynamic>> scrapeReviews({required String userStoreId}) async {
    final res = await _dio.post('/api/scraper/reviews', data: {
      'userStoreId': userStoreId,
    });
    return Map<String, dynamic>.from(res.data ?? {});
  }

  Future<Map<String, dynamic>> setSession({
    required String userStoreId,
    required List<Map<String, dynamic>> cookies,
    DateTime? expiresAt,
  }) async {
    final payload = {
      'userStoreId': userStoreId,
      'cookies': cookies,
      if (expiresAt != null) 'expiresAt': expiresAt.toIso8601String(),
    };
    final res = await _dio.post('/api/scraper/session', data: payload);
    return Map<String, dynamic>.from(res.data ?? {});
  }

  Future<Map<String, dynamic>> analyzeReview({required String reviewId}) async {
    final res = await _dio.post('/api/reviews/analysis/analyze', data: {
      'reviewId': reviewId,
    });
    return Map<String, dynamic>.from(res.data ?? {});
  }
}


