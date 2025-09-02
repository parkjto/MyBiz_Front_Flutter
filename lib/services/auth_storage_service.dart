import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userInfoKey = 'user_info';
  static const String _loginProviderKey = 'login_provider';
  static const String _tokenExpiryKey = 'token_expiry';

  // 토큰 저장
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_tokenKey, accessToken);
    
    if (refreshToken != null) {
      await prefs.setString(_refreshTokenKey, refreshToken);
    }
    
    if (expiresAt != null) {
      await prefs.setString(_tokenExpiryKey, expiresAt.toIso8601String());
    }
  }

  // 액세스 토큰 가져오기
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // 리프레시 토큰 가져오기
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // 토큰 만료 시간 가져오기
  Future<DateTime?> getTokenExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryString = prefs.getString(_tokenExpiryKey);
    if (expiryString != null) {
      try {
        return DateTime.parse(expiryString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // 토큰이 유효한지 확인
  Future<bool> isTokenValid() async {
    final token = await getAccessToken();
    if (token == null) return false;

    final expiry = await getTokenExpiry();
    if (expiry == null) return true; // 만료 시간이 없으면 유효하다고 가정

    return DateTime.now().isBefore(expiry);
  }

  // 사용자 정보 저장
  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userInfoKey, jsonEncode(userInfo));
  }

  // 사용자 정보 가져오기
  Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoString = prefs.getString(_userInfoKey);
    if (userInfoString != null) {
      try {
        return Map<String, dynamic>.from(jsonDecode(userInfoString));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // 로그인 제공자 저장
  Future<void> saveLoginProvider(String provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loginProviderKey, provider);
  }

  // 로그인 제공자 가져오기
  Future<String?> getLoginProvider() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loginProviderKey);
  }

  // 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    if (token == null) return false;
    
    return await isTokenValid();
  }

  // 모든 인증 데이터 삭제 (로그아웃)
  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userInfoKey);
    await prefs.remove(_loginProviderKey);
    await prefs.remove(_tokenExpiryKey);
  }

  // 토큰 갱신
  Future<void> updateAccessToken(String newToken, {DateTime? newExpiry}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, newToken);
    
    if (newExpiry != null) {
      await prefs.setString(_tokenExpiryKey, newExpiry.toIso8601String());
    }
  }
}
