import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybiz_app/widgets/common_styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                      () => _handleKakaoLogin(context),
                    ),
                    const SizedBox(height: 10),
                    _buildSocialLoginButton(
                      context,
                      '네이버로 로그인',
                      'assets/images/naver.png',
                      const Color(0xff03c75a),
                      Colors.white,
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
          onTap: onPressed,
          borderRadius: BorderRadius.circular(CommonStyles.buttonRadius),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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

  void _handleKakaoLogin(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('카카오 로그인 처리 중...')),
    );
    Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.pushReplacementNamed(context, '/signup');
    });
  }

  void _handleNaverLogin(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('네이버 로그인 처리 중...')),
    );
    Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.pushReplacementNamed(context, '/signup');
    });
  }
}
