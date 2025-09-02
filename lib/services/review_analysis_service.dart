import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'auth_storage_service.dart';

class ReviewAnalysisService {
  final Dio _dio = Dio();
  final AuthStorageService _auth = AuthStorageService();

  ReviewAnalysisService() {
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

  // 리뷰 분석 수행
  Future<Map<String, dynamic>> analyzeReview({required String userStoreId}) async {
    final res = await _dio.post('/api/reviews/analysis/analyze', data: {
      'userStoreId': userStoreId,
    });
    return Map<String, dynamic>.from(res.data ?? {});
  }

  // 분석 결과 조회
  Future<Map<String, dynamic>> getAnalysisResult({required String userStoreId}) async {
    final res = await _dio.get('/api/reviews/analysis/result/$userStoreId');
    return Map<String, dynamic>.from(res.data ?? {});
  }

  // 저장된 리뷰 조회
  Future<Map<String, dynamic>> getStoredReviews({required String userStoreId}) async {
    final res = await _dio.get('/api/reviews/stored/$userStoreId');
    return Map<String, dynamic>.from(res.data ?? {});
  }
}
