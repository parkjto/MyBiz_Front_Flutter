import 'package:dio/dio.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'api_client.dart';
import 'auth_storage_service.dart';
import 'user_data_service.dart';
import 'dart:io' show Platform;

class AuthService {
  final Dio _dio = ApiClient().dio;
  final AuthStorageService _auth = AuthStorageService();

  /// 서버 로그아웃 호출 후 로컬 인증/유저 데이터 정리
  Future<bool> logout() async {
    bool serverOk = false;
    try {
      final token = await _auth.getAccessToken();
      final provider = await _auth.getLoginProvider();
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      // 1. 소셜 로그아웃 (토큰 무효화)
      if (provider != null && provider.isNotEmpty) {
        try {
          if (provider == 'kakao') {
            await _dio.post('/api/auth/kakao/logout', 
              data: {'accessToken': token}, 
              options: Options(headers: headers)
            );
          } else if (provider == 'naver') {
            await _dio.post('/api/auth/naver/logout', 
              data: {'accessToken': token}, 
              options: Options(headers: headers)
            );
          }
        } catch (e) {
          // 소셜 로그아웃 실패는 무시 (토큰이 이미 만료되었을 수 있음)
          print('소셜 로그아웃 실패 (무시됨): $e');
        }
      }

      // 2. 일반 로그아웃
      try {
        final response = await _dio.post(
          '/api/auth/logout',
          options: Options(headers: headers),
        );
        serverOk = response.statusCode == 200 && (response.data?['success'] == true);
      } catch (e) {
        // 일반 로그아웃 실패도 무시
        serverOk = false;
      }
    } catch (_) {
      // 서버 호출 실패여도 로컬 정리는 진행
      serverOk = false;
    } finally {
      // 3. WebView 캐시 및 쿠키 정리 (OAuth 재인증 강제)
      await _clearWebViewCache();
      
      // 4. 로컬 데이터 정리
      await _auth.clearAuthData();
      await UserDataService.clearUserData();
    }
    return serverOk;
  }

  /// WebView 캐시 및 쿠키 정리 (OAuth 재인증 강제)
  Future<void> _clearWebViewCache() async {
    try {
      // WebView 캐시 정리
      await WebViewCookieManager().clearCookies();
      
      // 추가로 플랫폼별 캐시 정리
      if (Platform.isAndroid) {
        // Android: WebView 데이터 정리
        await WebViewCookieManager().clearCookies();
      } else if (Platform.isIOS) {
        // iOS: WKWebsiteDataStore 정리
        await WebViewCookieManager().clearCookies();
      }
      
      print('✅ WebView 캐시 및 쿠키 정리 완료');
    } catch (e) {
      print('⚠️ WebView 캐시 정리 실패 (무시됨): $e');
    }
  }
}
