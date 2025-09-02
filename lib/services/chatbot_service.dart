import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'auth_storage_service.dart';
import 'user_data_service.dart';

class ChatbotService {
  final Dio _dio = Dio();
  final AuthStorageService _auth = AuthStorageService();

  ChatbotService() {
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

  Future<Map<String, dynamic>> sendMessage({required String text}) async {
    final userId = await UserDataService.getUserId();
    final res = await _dio.post('/api/chatbot/message', data: {
      'text': text,
      'userId': userId ?? 'anonymous',
    });
    return Map<String, dynamic>.from(res.data ?? {});
  }
}


