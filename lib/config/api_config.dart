import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  // 플랫폼별 개발 환경 URL
  static String get devBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:4000'; // 웹용
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:4000'; // Android 에뮬레이터용
    } else if (Platform.isIOS) {
      return 'http://localhost:4000'; // iOS 시뮬레이터용
    } else {
      return 'http://localhost:4000'; // 기타 플랫폼
    }
  }
  
  // 프로덕션 환경
  static const String prodBaseUrl = 'https://your-production-api.com';
  
  // 현재 환경에 따른 기본 URL 반환
  static String get baseUrl {
    // TODO: 환경 변수나 빌드 설정에 따라 동적으로 변경
    const bool isProduction = false; // 개발 환경으로 설정
    
    return isProduction ? prodBaseUrl : devBaseUrl;
  }
  
  // API 엔드포인트
  static const String kakaoAuthUrl = '/api/auth/kakao/auth-url';
  static const String kakaoCallback = '/api/auth/kakao/callback';
  static const String kakaoLogin = '/api/auth/kakao/login';
  
  static const String naverAuthUrl = '/api/auth/naver/auth-url';
  static const String naverCallback = '/api/auth/naver/callback';
  static const String naverLogin = '/api/auth/naver/login';
  
  // 타임아웃 설정
  static const int connectionTimeout = 30000; // 30초
  static const int receiveTimeout = 30000; // 30초
  
  // 헤더 설정
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
