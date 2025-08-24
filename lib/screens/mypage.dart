import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'main_page.dart';
import 'login_page.dart';
import 'ad_creation_page.dart';
import 'revenue_analysis_page.dart';
import 'ai_chat_page.dart';
import 'inquiry_page.dart';
import 'withdraw_page.dart';
import 'signup_page.dart';
import 'edit_profile_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // ===== 스타일 상수 =====
  static const _sectionPadding = EdgeInsets.all(16);
  static const _sectionGap = 12.0; // 섹션 간 간격 ↓ (16→12)
  static const _lightLine = Color(0xFFE9EBF3); // 연한 내부 라인

  Divider _divider([double h = 22]) =>
      Divider(height: h, thickness: 1, 
  color: _lightLine.withOpacity(0.4)); // 내부 라인 간격 ↑

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileSection(),
                    const SizedBox(height: _sectionGap),
                    _buildMyInfoSection(),
                    const SizedBox(height: _sectionGap),
                    _buildStoreInfoSection(),
                    const SizedBox(height: _sectionGap),
                    _buildOtherSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          const Center(
            child: Text(
              '마이페이지',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.8,
                color: Color(0xFF333333),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, a, b) => const MainPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
              child: const SizedBox(
                width: 24,
                height: 24,
                child: Icon(Icons.arrow_back_ios, size: 16, color: Color(0xFF333333)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== 섹션들 (큰 박스 테두리 제거) =====
  BoxDecoration _sectionBox() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // border 제거 (요청)
        // 옵션: 살짝 그림자 원하면 아래 주석 해제
        // boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: Offset(0,4))],
      );

  Widget _buildProfileSection() {
    return Container(
      padding: _sectionPadding,
      decoration: _sectionBox(),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _launchSmartPlace(),
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(42)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(42),
                child: Image.asset(
                  'assets/images/user.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${UserData.name}님',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tel. ${UserData.phone}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF999999),
                    letterSpacing: -0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyInfoSection() {
    return Container(
      padding: _sectionPadding,
      decoration: _sectionBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '내 정보',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('이름', UserData.name, showDivider: true),
          _buildInfoRow('생년월일', UserData.birthDate, showDivider: true),
          _buildInfoRow('전화번호', UserData.phone, showDivider: true),
          _buildInfoRow('이메일', UserData.email, showDivider: false),
        ],
      ),
    );
  }

  Widget _buildStoreInfoSection() {
    return Container(
      padding: _sectionPadding,
      decoration: _sectionBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '가게 정보',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('가게명', UserData.businessName, showDivider: true),
          _buildInfoRow('업종', UserData.businessType, showDivider: true),
          _buildInfoRow('사업자번호', UserData.businessNumber, showDivider: true),
          _buildInfoRow('주소', UserData.address, showDivider: true),
          _buildInfoRow('번호', UserData.businessPhone, showDivider: false),
        ],
      ),
    );
  }

  Widget _buildOtherSection() {
    return Container(
      padding: _sectionPadding,
      decoration: _sectionBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '기타',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuRow('정보 수정하기', () async {
            final result = await Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, a, b) => const EditProfilePage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            if (result == true) setState(() {});
          }, showDivider: true),
          _buildMenuRow('문의사항', () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, a, b) => const InquiryPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }, showDivider: true),
          _buildMenuRow('로그아웃', () {
            _showLogoutDialog();
          }, showDivider: true),
          _buildMenuRow('탈퇴하기', () {
            _showWithdrawDialog();
          }, showDivider: false),
        ],
      ),
    );
  }

  // ===== 내부 행 (라인 간격 넓힘) =====
  Widget _buildInfoRow(String label, String value, {bool showDivider = false}) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 6), // ↑ (10→14)
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.8,
                color: Color(0xFF999999),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Color(0xFF666666),
                letterSpacing: -0.8,
              ),
            ),
          ),
        ],
      ),
    );
    if (!showDivider) return row;
    return Column(children: [row, _divider()]);
  }

  Widget _buildMenuRow(String title, VoidCallback onTap, {bool showDivider = false}) {
    final row = GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6), // ↑ (10/12→14)
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.8,
                color: title == '탈퇴하기' ? const Color(0xFFEE4335) : const Color(0xFF999999),
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF999999)),
          ],
        ),
      ),
    );
    if (!showDivider) return row;
    return Column(children: [row, _divider()]);
  }

  // ===== 하단 네비 =====

Widget _buildBottomNavigation() {
  return SizedBox(
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem('assets/images/menuHome.png', '홈', false),
              _buildNavItem('assets/images/menuAD.png', '광고 생성', false),
              const SizedBox(width: 64), // 마이크 자리 확보
              _buildNavItem('assets/images/menuAnalysis.png', '분석', true),
              _buildNavItem('assets/images/menuMypage.png', '마이페이지', false),
            ],
          ),
        ),
        Positioned(
          top: -25,
          left: 0,
          right: 0,
          child: Center(child: _buildMicButton()),
        ),
      ],
    ),
  );
}


Widget _buildNavItem(String imagePath, String label, bool isSelected) {
  return GestureDetector(
    onTap: () {
      if (label == '광고 생성') {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => AdCreationPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      } else if (label == '분석') {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => RevenueAnalysisPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      } else if (label == '마이페이지') {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => MyPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: isSelected ? 1.0 : 0.55,
          child: Image.asset(
            imagePath,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? const Color(0xFF333333) : Colors.grey[600],
              letterSpacing: -0.8
          ),
        ),
      ],
    ),
  );
}

Widget _buildMicButton() {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AiChatPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.95),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 10, offset: const Offset(0, 6)),
            ],
          ),
        ),
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF98E0F8), Color(0xFF9CCEFF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          foregroundDecoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Colors.black.withOpacity(0.01), Colors.transparent],
              stops: const [0.9, 1.0],
            ),
          ),
        ),
        Image.asset('assets/images/navMic.png', width: 30, height: 30, fit: BoxFit.contain),
      ],
    ),
  );
}


  // ===== 다이얼로그/출처 함수들 =====
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              const Text(
                '로그아웃 하시겠습니까?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF666666), letterSpacing: -0.8),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 43,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text('취소', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.8, color: Color(0xFF00C2FD))),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(pageBuilder: (c, a, b) => const LoginPage(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero),
                        );
                      },
                      child: Container(
                        height: 43,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF98E0F8), Color(0xFF9CCEFF)], begin: Alignment.centerLeft, end: Alignment.centerRight),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text('확인', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -0.8, color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showWithdrawDialog() {
    Navigator.push(
      context,
      PageRouteBuilder(pageBuilder: (c, a, b) => const WithdrawPage(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero),
    );
  }

  Future<void> _launchSmartPlace() async {
    try {
      const String appUrlScheme = 'naversearchapp://';
      const String webUrl = 'https://smartplace.naver.com/';

      if (kIsWeb) {
        final Uri webUri = Uri.parse(webUrl);
        if (await canLaunchUrl(webUri)) {
          await launchUrl(webUri, webOnlyWindowName: '_blank');
        } else {
          _showErrorSnackBar('스마트플레이스를 열 수 없습니다.');
        }
        return;
      }

      if (Platform.isAndroid || Platform.isIOS) {
        try {
          final Uri appUri = Uri.parse(appUrlScheme);
          if (await canLaunchUrl(appUri)) {
            await launchUrl(appUri, mode: LaunchMode.externalApplication);
          } else {
            final Uri webUri = Uri.parse(webUrl);
            if (await canLaunchUrl(webUri)) {
              await launchUrl(webUri, mode: LaunchMode.externalApplication);
            } else {
              _showErrorSnackBar('스마트플레이스를 열 수 없습니다.');
            }
          }
        } catch (e) {
          try {
            final Uri webUri = Uri.parse(webUrl);
            if (await canLaunchUrl(webUri)) {
              await launchUrl(webUri, mode: LaunchMode.externalApplication);
            } else {
              _showErrorSnackBar('스마트플레이스를 열 수 없습니다.');
            }
          } catch (e2) {
            _showErrorSnackBar('오류가 발생했습니다: $e2');
          }
        }
      } else {
        final Uri webUri = Uri.parse(webUrl);
        if (await canLaunchUrl(webUri)) {
          await launchUrl(webUri, mode: LaunchMode.externalApplication);
        } else {
          _showErrorSnackBar('스마트플레이스를 열 수 없습니다.');
        }
      }
    } catch (e) {
      _showErrorSnackBar('오류가 발생했습니다: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
    }
  }
}
