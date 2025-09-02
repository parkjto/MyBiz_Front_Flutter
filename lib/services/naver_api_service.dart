import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../services/auth_storage_service.dart';
import '../utils/html_utils.dart';

class NaverApiService {
  final Dio _dio = Dio();
  final AuthStorageService _authStorage = AuthStorageService();

  NaverApiService() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = Duration(milliseconds: ApiConfig.connectionTimeout);
    _dio.options.receiveTimeout = Duration(milliseconds: ApiConfig.receiveTimeout);
    _dio.options.headers = ApiConfig.defaultHeaders;
    
    // 인증 인터셉터 추가
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 액세스 토큰 추가
        final token = await _authStorage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // 토큰 만료 시 리프레시 토큰으로 갱신 시도
          try {
            final refreshToken = await _authStorage.getRefreshToken();
            if (refreshToken != null) {
              // 리프레시 토큰으로 새 액세스 토큰 발급 요청
              final newToken = await _refreshAccessToken(refreshToken);
              if (newToken != null) {
                // 새 토큰으로 재시도
                error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                final response = await _dio.fetch(error.requestOptions);
                handler.resolve(response);
                return;
              }
            }
          } catch (e) {
            print('❌ 토큰 갱신 실패: $e');
          }
        }
        handler.next(error);
      },
    ));
    
    // 로깅 인터셉터 추가
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('🌐 Naver API: $obj'),
    ));
  }

  // 검색/조회 응답을 공통 포맷으로 정규화
  Map<String, dynamic> _normalizeStoreItem(dynamic item) {
    final rawName = item['store_name'] ?? item['name'] ?? item['title'] ?? item['place_name'] ?? '';
    final rawAddress = item['address'] ?? item['jibunAddress'] ?? '';
    final rawRoadAddress = item['road_address'] ?? item['roadAddress'] ?? item['roadAddressName'] ?? '';
    final rawCategory = item['category'] ?? item['categoryName'] ?? item['businessType'] ?? '';

    return {
      'name': HtmlUtils.removeHtmlTags(rawName),
      'address': HtmlUtils.removeHtmlTags(rawAddress),
      'roadAddress': HtmlUtils.removeHtmlTags(rawRoadAddress),
      'businessType': HtmlUtils.removeHtmlTags(rawCategory),
      'coordinates_x': item['coordinates_x'] ?? item['x'] ?? '',
      'coordinates_y': item['coordinates_y'] ?? item['y'] ?? '',
      'place_id': item['place_id'] ?? item['id'] ?? item['placeId'] ?? '',
      'phone': item['phone'] ?? item['tel'] ?? '',
      'map_url': item['map_url'] ?? item['link'] ?? item['url'] ?? '',
    };
  }

  // 액세스 토큰 갱신
  Future<String?> _refreshAccessToken(String refreshToken) async {
    try {
      final response = await _dio.post('/api/auth/refresh', data: {
        'refresh_token': refreshToken,
      });
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final newToken = response.data['access_token'];
        await _authStorage.updateAccessToken(newToken);
        return newToken;
      }
    } catch (e) {
      print('❌ 토큰 갱신 실패: $e');
    }
    return null;
  }

  // 네이버 API 상태 확인 (인증 불필요)
  Future<bool> checkApiStatus() async {
    try {
      print('🔍 네이버 API 상태 확인 중...');
      final response = await _dio.get('/api/naver/status');
      final isAvailable = response.statusCode == 200;
      print('✅ 네이버 API 상태: ${isAvailable ? "사용 가능" : "사용 불가"}');
      return isAvailable;
    } catch (e) {
      print('❌ 네이버 API 상태 확인 실패: $e');
      return false;
    }
  }

  // 매장 검색 (인증 필요)
  Future<List<Map<String, dynamic>>> searchStores(String query) async {
    try {
      print('🔍 매장 검색 시작: $query');
      
      // 먼저 인증 상태 확인
      final token = await _authStorage.getAccessToken();
      if (token == null) {
        print('❌ 인증 토큰이 없습니다. 로그인이 필요합니다.');
        throw Exception('로그인이 필요합니다. 먼저 소셜 로그인을 진행해주세요.');
      }
      
      final response = await _dio.post('/api/naver/search', data: {
        'query': query,
        'limit': 20, // 검색 결과 제한
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> results = response.data['data'] ?? [];
        print('✅ 검색 결과 ${results.length}개 발견');
        
        return results.map<Map<String, dynamic>>((item) => _normalizeStoreItem(item)).toList();
      } else {
        print('⚠️ 검색 결과 없음 또는 API 오류');
        return [];
      }
    } catch (e) {
      print('❌ 매장 검색 실패: $e');
      rethrow; // 에러를 상위로 전파하여 UI에서 처리
    }
  }

  // 매장 검색 (회원가입용, 인증 불필요)
  Future<List<Map<String, dynamic>>> searchStoresForSignup(String query) async {
    try {
      print('🔍 회원가입용 매장 검색 시작: $query');
      
      // 인증 없이 검색 시도 (백엔드에서 회원가입용 엔드포인트 제공 필요)
      final response = await _dio.post('/api/naver/search-public', data: {
        'query': query,
        'limit': 20,
        'for_signup': true, // 회원가입용임을 표시
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> results = response.data['data'] ?? [];
        print('✅ 회원가입용 검색 결과 ${results.length}개 발견');
        
        return results.map<Map<String, dynamic>>((item) => _normalizeStoreItem(item)).toList();
      } else {
        print('⚠️ 회원가입용 검색 결과 없음');
        return [];
      }
    } catch (e) {
      print('❌ 회원가입용 매장 검색 실패: $e');
      rethrow;
    }
  }

  // Place ID로 매장 정보 조회
  Future<Map<String, dynamic>?> findStoreByPlaceId(String placeId) async {
    try {
      print('📍 Place ID로 매장 조회: $placeId');
      
      final response = await _dio.post('/api/naver/find-with-placeid', data: {
        'place_id': placeId,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        print('✅ Place ID 조회 성공');
        
        return _normalizeStoreItem(data);
      } else {
        print('⚠️ Place ID 조회 실패');
        return null;
      }
    } catch (e) {
      print('❌ Place ID 조회 실패: $e');
      return null;
    }
  }

  // 좌표 기반 매장 검색
  Future<List<Map<String, dynamic>>> findStoresByCoordinates(
    String latitude, 
    String longitude, 
    {int radius = 1000}
  ) async {
    try {
      print('📍 좌표 기반 매장 검색: ($latitude, $longitude), 반경: ${radius}m');
      
      final response = await _dio.post('/api/naver/find-by-coordinates', data: {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
        'limit': 20,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> results = response.data['data'] ?? [];
        print('✅ 좌표 기반 검색 결과 ${results.length}개 발견');
        
        return results.map<Map<String, dynamic>>((item) => _normalizeStoreItem(item)).toList();
      } else {
        print('⚠️ 좌표 기반 검색 결과 없음');
        return [];
      }
    } catch (e) {
      print('❌ 좌표 기반 검색 실패: $e');
      return [];
    }
  }
}
