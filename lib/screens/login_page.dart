import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybiz_app/widgets/common_styles.dart';
import '../services/social_auth_service.dart';
import '../services/auth_storage_service.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  
  const LoginPage({super.key, this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SocialAuthService _authService = SocialAuthService();
  final AuthStorageService _storageService = AuthStorageService();
  bool _isKakaoLoading = false;
  bool _isNaverLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 200),
                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) => CommonStyles.brandGradient.createShader(bounds),
                      child: Text(
                        'MyBiz',
                        style: GoogleFonts.inter(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.55,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '소상공인의 비즈니스 성장을 위한 AI 비서',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      letterSpacing: -0.55,
                      color: const Color(0xFF9AA0A6),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(CommonStyles.dialogRadius),
                    topRight: Radius.circular(CommonStyles.dialogRadius),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '소셜 로그인',
                      textAlign: TextAlign.center,
                      style: CommonStyles.titleStyle.copyWith(
                        color: const Color(0xFF6B6A6F),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '로그인을 통해 다양한 서비스를 이용하세요!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        letterSpacing: -0.55,
                        color: const Color(0xFF9AA0A6),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildSocialLoginButton(
                      context,
                      '카카오로 로그인',
                      'assets/images/kakao.png',
                      const Color(0xfffddc3f),
                      Colors.black,
                      _isKakaoLoading,
                      () => _handleKakaoLogin(context),
                    ),
                    const SizedBox(height: 10),
                    _buildSocialLoginButton(
                      context,
                      '네이버로 로그인',
                      'assets/images/naver.png',
                      const Color(0xff03c75a),
                      Colors.white,
                      _isNaverLoading,
                      () => _handleNaverLogin(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton(
    BuildContext context,
    String text,
    String iconPath,
    Color backgroundColor,
    Color textColor,
    bool isLoading,
    VoidCallback onPressed,
  ) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(CommonStyles.buttonRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(CommonStyles.buttonRadius),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                  ),
                )
              else
                Image.asset(iconPath, width: 22, height: 22, fit: BoxFit.contain),
              const SizedBox(width: 10),
              Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 카카오 로그인 처리
  Future<void> _handleKakaoLogin(BuildContext context) async {
    if (_isKakaoLoading) return;

    setState(() {
      _isKakaoLoading = true;
    });

    try {
      // 1. 카카오 인증 URL 가져오기
      final authUrl = await _authService.getKakaoAuthUrl();
      if (authUrl == null) {
        throw Exception('카카오 인증 URL을 가져올 수 없습니다.');
      }

      // 2. WebView로 OAuth 인증 진행
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => OAuthWebViewDialog(
            authUrl: authUrl,
            provider: '카카오',
            onSuccess: (String code) async {
              // 3. 인증 코드로 로그인 처리
              await _processKakaoLogin(code);
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('카카오 로그인 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isKakaoLoading = false;
        });
      }
    }
  }

  // 네이버 로그인 처리
  Future<void> _handleNaverLogin(BuildContext context) async {
    if (_isNaverLoading) return;

    setState(() {
      _isNaverLoading = true;
    });

    try {
      // 1. 네이버 인증 URL 가져오기
      final authUrl = await _authService.getNaverAuthUrl();
      if (authUrl == null) {
        throw Exception('네이버 인증 URL을 가져올 수 없습니다.');
      }

      // 2. WebView로 OAuth 인증 진행
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => OAuthWebViewDialog(
            authUrl: authUrl,
            provider: '네이버',
            onSuccess: (String code) async {
              // 3. 인증 코드로 로그인 처리
              await _processNaverLogin(code);
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('네이버 로그인 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isNaverLoading = false;
        });
      }
    }
  }

  // 카카오 로그인 처리 및 결과 처리
  Future<void> _processKakaoLogin(String code) async {
    try {
      final result = await _authService.processKakaoLogin(code);
      final normalized = _normalizeAuthResult(result);
      
      if (mounted) {
        // 로그인 성공 처리
        await _handleLoginSuccess(
          normalized['access_token'] ?? '',
          normalized['refresh_token'],
          normalized['expires_at'],
          normalized['user'],
          '카카오',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('카카오 로그인 처리 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 네이버 로그인 처리 및 결과 처리
  Future<void> _processNaverLogin(String code) async {
    try {
      final result = await _authService.processNaverLogin(code);
      final normalized = _normalizeAuthResult(result);
      
      if (mounted) {
        // 로그인 성공 처리
        await _handleLoginSuccess(
          normalized['access_token'] ?? '',
          normalized['refresh_token'],
          normalized['expires_at'],
          normalized['user'],
          '네이버',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('네이버 로그인 처리 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 로그인 성공 처리
  Future<void> _handleLoginSuccess(String accessToken, String? refreshToken, String? expiresAt, Map<String, dynamic>? user, String loginProvider) async {
    try {
      print('🎉 로그인 성공 처리 시작: $loginProvider');
      print('📊 받은 데이터: $user');
      
      // 토큰 저장
      print('🔑 액세스 토큰 저장 중...');
      await _storageService.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: (expiresAt != null && expiresAt.isNotEmpty)
            ? DateTime.tryParse(expiresAt)
            : null,
      );
      print('✅ 토큰 저장 완료');

      // 사용자 정보 저장
      if (user != null) {
        print('👤 사용자 정보 저장 중...');
        await _storageService.saveUserInfo(user);
        print('✅ 사용자 정보 저장 완료');
      }

      // 로그인 제공자 저장
      print('🏷️ 로그인 제공자 저장 중...');
      await _storageService.saveLoginProvider(loginProvider);
      print('✅ 로그인 제공자 저장 완료');

      // 성공 메시지 표시
      if (mounted) {
        print('📱 성공 메시지 표시 중...');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$loginProvider 로그인 성공! 추가 정보를 입력해주세요.'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );

        // 회원가입 페이지로 이동 (추가 정보 입력)
        print('🔄 회원가입 페이지로 이동 준비 중...');
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            print('🚀 회원가입 페이지로 이동: /signup');
            Navigator.pushReplacementNamed(context, '/signup');
          } else {
            print('❌ 위젯이 마운트되지 않음');
          }
        });
      }
    } catch (e) {
      print('❌ 로그인 성공 처리 중 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 정보 저장 실패: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  // 백엔드 응답을 안전하게 정규화 (키 이름/타입 다양성 대응)
  Map<String, dynamic> _normalizeAuthResult(Map<String, dynamic> data) {
    final map = Map<String, dynamic>.from(data);

    String? accessToken = map['access_token'] ?? map['accessToken'] ?? map['token'];
    String? refreshToken = map['refresh_token'] ?? map['refreshToken'];

    // 만료값: ISO 문자열 또는 expires_in(초)
    String? expiresAt;
    final rawExpiresAt = map['expires_at'] ?? map['expiresAt'];
    final expiresIn = map['expires_in'] ?? map['expiresIn'];
    if (rawExpiresAt is String && rawExpiresAt.isNotEmpty) {
      expiresAt = rawExpiresAt;
    } else if (expiresIn is num) {
      final dt = DateTime.now().add(Duration(seconds: expiresIn.toInt()));
      expiresAt = dt.toIso8601String();
    }

    Map<String, dynamic>? user;
    final rawUser = map['user'] ?? map['profile'] ?? map['data'];
    if (rawUser is Map) {
      user = Map<String, dynamic>.from(rawUser as Map);
    }

    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt,
      'user': user,
    };
  }
}
