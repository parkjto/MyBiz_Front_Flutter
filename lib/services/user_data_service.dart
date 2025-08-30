import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserDataService {
  static const String _userDataKey = 'user_data';
  static const String _userIdKey = 'user_id';
  static const String _userStoreIdKey = 'user_store_id';

  // 사용자 데이터 저장
  static Future<bool> saveUserData({
    required String name,
    required String phone,
    String? birthDate,
    String? email,
    String? businessPhone,
    String? businessName,
    String? businessNumber,
    String? businessType,
    String? address,
    String? userId,
    String? userStoreId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final userData = {
        'name': name,
        'phone': phone,
        'birthDate': birthDate ?? '',
        'email': email ?? '',
        'businessPhone': businessPhone ?? '',
        'businessName': businessName ?? '',
        'businessNumber': businessNumber ?? '',
        'businessType': businessType ?? '',
        'address': address ?? '',
        'userId': userId ?? '',
        'userStoreId': userStoreId ?? '',
        'savedAt': DateTime.now().toIso8601String(),
      };

      // JSON으로 변환하여 저장
      final jsonString = jsonEncode(userData);
      await prefs.setString(_userDataKey, jsonString);
      
      // 개별 키로도 저장 (기존 코드와의 호환성)
      if (userId != null) await prefs.setString(_userIdKey, userId);
      if (userStoreId != null) await prefs.setString(_userStoreIdKey, userStoreId);
      
      print('✅ 사용자 데이터 저장 완료: $name');
      return true;
    } catch (e) {
      print('❌ 사용자 데이터 저장 실패: $e');
      return false;
    }
  }

  // 사용자 데이터 불러오기
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_userDataKey);
      
      if (jsonString != null) {
        final userData = jsonDecode(jsonString) as Map<String, dynamic>;
        print('✅ 사용자 데이터 불러오기 완료: ${userData['name']}');
        return userData;
      }
      
      return null;
    } catch (e) {
      print('❌ 사용자 데이터 불러오기 실패: $e');
      return null;
    }
  }

  // 특정 필드 업데이트
  static Future<bool> updateUserDataField(String field, String value) async {
    try {
      final userData = await getUserData();
      if (userData != null) {
        userData[field] = value;
        userData['updatedAt'] = DateTime.now().toIso8601String();
        
        final prefs = await SharedPreferences.getInstance();
        final jsonString = jsonEncode(userData);
        await prefs.setString(_userDataKey, jsonString);
        
        print('✅ 사용자 데이터 필드 업데이트 완료: $field = $value');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ 사용자 데이터 필드 업데이트 실패: $e');
      return false;
    }
  }

  // 사용자 ID 저장
  static Future<bool> saveUserId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userIdKey, userId);
      
      // 기존 사용자 데이터에도 추가
      final userData = await getUserData();
      if (userData != null) {
        userData['userId'] = userId;
        await saveUserData(
          name: userData['name'] ?? '',
          phone: userData['phone'] ?? '',
          birthDate: userData['birthDate'],
          email: userData['email'],
          businessPhone: userData['businessPhone'],
          businessName: userData['businessName'],
          businessNumber: userData['businessNumber'],
          businessType: userData['businessType'],
          address: userData['address'],
          userId: userId,
          userStoreId: userData['userStoreId'],
        );
      }
      
      return true;
    } catch (e) {
      print('❌ 사용자 ID 저장 실패: $e');
      return false;
    }
  }

  // 사용자 ID 불러오기
  static Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userIdKey);
    } catch (e) {
      print('❌ 사용자 ID 불러오기 실패: $e');
      return null;
    }
  }

  // 사용자 스토어 ID 저장
  static Future<bool> saveUserStoreId(String userStoreId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userStoreIdKey, userStoreId);
      
      // 기존 사용자 데이터에도 추가
      final userData = await getUserData();
      if (userData != null) {
        userData['userStoreId'] = userStoreId;
        await saveUserData(
          name: userData['name'] ?? '',
          phone: userData['phone'] ?? '',
          birthDate: userData['birthDate'],
          email: userData['email'],
          businessPhone: userData['businessPhone'],
          businessName: userData['businessName'],
          businessNumber: userData['businessNumber'],
          businessType: userData['businessType'],
          address: userData['address'],
          userId: userData['userId'],
          userStoreId: userStoreId,
        );
      }
      
      return true;
    } catch (e) {
      print('❌ 사용자 스토어 ID 저장 실패: $e');
      return false;
    }
  }

  // 사용자 스토어 ID 불러오기
  static Future<String?> getUserStoreId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userStoreIdKey);
    } catch (e) {
      print('❌ 사용자 스토어 ID 불러오기 실패: $e');
      return null;
    }
  }

  // 사용자 데이터 삭제 (로그아웃 시)
  static Future<bool> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userStoreIdKey);
      
      print('✅ 사용자 데이터 삭제 완료');
      return true;
    } catch (e) {
      print('❌ 사용자 데이터 삭제 실패: $e');
      return false;
    }
  }

  // 사용자 데이터 존재 여부 확인
  static Future<bool> hasUserData() async {
    try {
      final userData = await getUserData();
      return userData != null && userData['name']?.isNotEmpty == true;
    } catch (e) {
      return false;
    }
  }
}
