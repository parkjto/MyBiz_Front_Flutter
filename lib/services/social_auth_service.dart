import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import '../config/api_config.dart';

class SocialAuthService {
  late final Dio _dio;

  SocialAuthService() {
    print('🔧 SocialAuthService 초기화 - BaseURL: ${ApiConfig.baseUrl}');
    
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(milliseconds: ApiConfig.connectionTimeout),
      receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
      headers: ApiConfig.defaultHeaders,
    ));

    // Dio 인터셉터 추가로 요청/응답 로깅
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🌐 Dio 요청: ${options.method} ${options.uri}');
        print('🔗 BaseURL: ${options.baseUrl}');
        print('📡 전체 URL: ${options.uri.toString()}');
        handler.next(options);
      },
      onError: (error, handler) {
        print('❌ Dio 오류: ${error.message}');
        print('🔗 요청 URL: ${error.requestOptions.uri}');
        handler.next(error);
      },
    ));
  }

  // 카카오 로그인 URL 생성
  Future<String?> getKakaoAuthUrl() async {
    try {
      print('🔍 카카오 인증 URL 요청 시작');
      print('🎯 API 엔드포인트: ${ApiConfig.kakaoAuthUrl}');
      print('🌐 전체 URL: ${ApiConfig.baseUrl}${ApiConfig.kakaoAuthUrl}');
      
      final response = await _dio.get(ApiConfig.kakaoAuthUrl);
      
      print('✅ 카카오 인증 URL 응답 성공: ${response.statusCode}');
      
      if (response.statusCode == 200 && response.data['authUrl'] != null) {
        return response.data['authUrl'];
      }
      throw Exception('카카오 인증 URL을 가져올 수 없습니다.');
    } catch (e) {
      print('❌ 카카오 인증 URL 요청 실패: $e');
      throw Exception('카카오 인증 URL 요청 실패: $e');
    }
  }

  // 네이버 로그인 URL 생성
  Future<String?> getNaverAuthUrl() async {
    try {
      print('🔍 네이버 인증 URL 요청 시작');
      print('🎯 API 엔드포인트: ${ApiConfig.naverAuthUrl}');
      print('🌐 전체 URL: ${ApiConfig.baseUrl}${ApiConfig.naverAuthUrl}');
      
      final response = await _dio.get(ApiConfig.naverAuthUrl);
      
      print('✅ 네이버 인증 URL 응답 성공: ${response.statusCode}');
      
      if (response.statusCode == 200 && response.data['authUrl'] != null) {
        return response.data['authUrl'];
      }
      throw Exception('네이버 인증 URL을 가져올 수 없습니다.');
    } catch (e) {
      print('❌ 네이버 인증 URL 요청 실패: $e');
      throw Exception('네이버 인증 URL 요청 실패: $e');
    }
  }

  // 카카오 로그인 처리
  Future<Map<String, dynamic>> processKakaoLogin(String code) async {
    try {
      final response = await _dio.post(ApiConfig.kakaoLogin, data: {
        'code': code,
      });
      
      if (response.statusCode == 200 && response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }
      throw Exception('카카오 로그인 처리 실패');
    } catch (e) {
      throw Exception('카카오 로그인 처리 오류: $e');
    }
  }

  // 네이버 로그인 처리
  Future<Map<String, dynamic>> processNaverLogin(String code) async {
    try {
      final response = await _dio.post(ApiConfig.naverLogin, data: {
        'code': code,
      });
      
      if (response.statusCode == 200 && response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }
      throw Exception('네이버 로그인 처리 실패');
    } catch (e) {
      throw Exception('네이버 로그인 처리 오류: $e');
    }
  }

  // 외부 브라우저로 인증 URL 열기
  Future<bool> launchAuthUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      throw Exception('인증 URL 열기 실패: $e');
    }
  }

  // OAuth 콜백 코드 추출 (URL에서)
  String? extractAuthCode(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.queryParameters['code'];
    } catch (e) {
      return null;
    }
  }
}

// OAuth 콜백 처리를 위한 WebView 다이얼로그
class OAuthWebViewDialog extends StatefulWidget {
  final String authUrl;
  final String provider;
  final Function(String code) onSuccess;
  final VoidCallback onCancel;

  const OAuthWebViewDialog({
    super.key,
    required this.authUrl,
    required this.provider,
    required this.onSuccess,
    required this.onCancel,
  });

  @override
  State<OAuthWebViewDialog> createState() => _OAuthWebViewDialogState();
}

class _OAuthWebViewDialogState extends State<OAuthWebViewDialog> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    print('🔧 OAuth WebView 초기화: ${widget.provider}');
    print('🌐 인증 URL: ${widget.authUrl}');
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          print('📱 페이지 로딩 시작: $url');
          setState(() => _isLoading = true);
        },
        onPageFinished: (String url) {
          print('✅ 페이지 로딩 완료: $url');
          setState(() => _isLoading = false);
          
          // OAuth 콜백 URL 감지
          _checkForCallback(url);
        },
        onNavigationRequest: (NavigationRequest request) {
          print('🧭 네비게이션 요청: ${request.url}');
          
          // OAuth 콜백 URL 감지
          if (_checkForCallback(request.url)) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onWebResourceError: (WebResourceError error) {
          print('❌ WebView 오류: ${error.description}');
        },
      ))
      ..loadRequest(Uri.parse(widget.authUrl));
  }

  // OAuth 콜백 URL 확인 및 코드 추출
  bool _checkForCallback(String url) {
    print('🔍 콜백 URL 확인: $url');
    
    // 성공적인 OAuth 콜백인지 확인
    if (url.contains('code=') && !url.contains('error=')) {
      final code = Uri.parse(url).queryParameters['code'];
      if (code != null && code.isNotEmpty) {
        print('🎯 OAuth 코드 추출 성공: $code');
        
        if (!_isCompleted) {
          _isCompleted = true;
          widget.onSuccess(code);
          Navigator.of(context).pop();
        }
        return true;
      }
    }
    
    // 에러가 있는 경우
    if (url.contains('error=')) {
      final error = Uri.parse(url).queryParameters['error'];
      final errorDescription = Uri.parse(url).queryParameters['error_description'];
      print('❌ OAuth 에러: $error - $errorDescription');
      
      if (!_isCompleted) {
        _isCompleted = true;
        Navigator.of(context).pop();
        // 에러 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.provider} 로그인 실패: $errorDescription'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return true;
    }
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '${widget.provider} 로그인',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      if (!_isCompleted) {
                        _isCompleted = true;
                        widget.onCancel();
                      }
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // WebView
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
