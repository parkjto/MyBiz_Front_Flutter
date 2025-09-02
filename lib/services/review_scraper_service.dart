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

  // 비동기 스크래핑 시작
  Future<Map<String, dynamic>> startScraping({required String userStoreId}) async {
    final res = await _dio.post('/api/scraper/reviews', data: {
      'userStoreId': userStoreId,
    });
    return Map<String, dynamic>.from(res.data ?? {});
  }

  // 스크래핑 작업 상태 조회
  Future<Map<String, dynamic>> getScrapingJobStatus({required String jobId}) async {
    final res = await _dio.get('/api/scraper/jobs/$jobId');
    return Map<String, dynamic>.from(res.data ?? {});
  }

  // 사용자의 스크래핑 작업 목록 조회
  Future<Map<String, dynamic>> getUserScrapingJobs({required String userStoreId}) async {
    final res = await _dio.get('/api/scraper/jobs/user/$userStoreId');
    return Map<String, dynamic>.from(res.data ?? {});
  }

  // 기존 동기 스크래핑 (호환성 유지)
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


