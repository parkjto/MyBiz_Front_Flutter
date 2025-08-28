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
import 'naver_link_page.dart';
import 'package:mybiz_app/widgets/main_bottom_nav.dart';
import 'package:mybiz_app/widgets/main_header.dart';
import 'package:mybiz_app/widgets/main_page_layout.dart';
import 'package:mybiz_app/widgets/common_styles.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return MainPageLayout(
      selectedIndex: 3,
      child: Column(
        children: [
          const MainHeader(title: '마이페이지'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileSection(),
                  const SizedBox(height: CommonStyles.sectionGap),
                  _buildMyInfoSection(),
                  const SizedBox(height: CommonStyles.sectionGap),
                  _buildStoreInfoSection(),
                  const SizedBox(height: CommonStyles.sectionGap),
                  _buildOtherSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: CommonStyles.sectionPadding,
      decoration: CommonStyles.sectionBox(),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _launchSmartPlace(),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: CommonStyles.borderColor,
                  width: 3,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Image.asset(
                  'assets/images/profile.png',
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
                  style: CommonStyles.titleStyle,
                ),
                const SizedBox(height: 2),
                Text(
                  'Tel. ${UserData.phone}',
                  style: CommonStyles.labelStyle,
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
      padding: CommonStyles.sectionPadding,
      decoration: CommonStyles.sectionBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '내 정보',
            style: CommonStyles.titleStyle,
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
      padding: CommonStyles.sectionPadding,
      decoration: CommonStyles.sectionBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '가게 정보',
            style: CommonStyles.titleStyle,
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
      padding: CommonStyles.sectionPadding,
      decoration: CommonStyles.sectionBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '기타',
            style: CommonStyles.titleStyle,
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
          _buildMenuRow('네이버 연동', () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, a, b) => const NaverLinkPage(),
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

  Widget _buildInfoRow(String label, String value, {bool showDivider = false}) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: CommonStyles.labelStyle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: CommonStyles.contentStyle,
            ),
          ),
        ],
      ),
    );
    if (!showDivider) return row;
    return Column(children: [row, CommonStyles.divider()]);
  }

  Widget _buildMenuRow(String title, VoidCallback onTap, {bool showDivider = false}) {
    final row = Container(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [
              Text(
                title,
                style: CommonStyles.contentStyle.copyWith(
                  color: const Color(0xFF999999),
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF999999)),
            ],
          ),
        ),
      ),
    );
    if (!showDivider) return row;
    return Column(children: [row, CommonStyles.divider()]);
  }

  // ===== 하단 네비 =====

Widget _buildBottomNavigation_REMOVED() {
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
          child: Center(child: SizedBox()),
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
              letterSpacing: -0.55
          ),
        ),
      ],
    ),
  );
}

Widget _buildMicButton_REMOVED() {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8), // 20에서 8로 줄임
              const Text(
                '로그아웃',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.55,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '정말 로그아웃 하시겠습니까?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.55,
                  color: const Color(0xFF666666),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5E5E5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFFF8F9FA),
                      ),
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00AEFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWithdrawDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8), // 20에서 8로 줄임
              const Text(
                '회원탈퇴',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '정말 탈퇴하시겠습니까?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.8,
                  color: const Color(0xFF666666),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5E5E5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFFF8F9FA),
                      ),
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, a, b) => const WithdrawPage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B6B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: Text(
                        '탈퇴하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
