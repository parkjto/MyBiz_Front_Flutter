import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mypage.dart';
import 'signup_page.dart';

import 'package:mybiz_app/screens/ad_creation_page.dart';
import 'package:mybiz_app/screens/revenue_analysis_page.dart';
import 'package:mybiz_app/screens/ai_chat_page.dart';
import 'package:mybiz_app/widgets/main_bottom_nav.dart';
import 'package:mybiz_app/widgets/main_header.dart';
import 'package:mybiz_app/widgets/common_styles.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  String _selectedReason = '선택해주세요';
  final List<String> _withdrawReasons = [
    '선택해주세요',
    '원하는 기능이 없거나 불편함',
    '개인정보 보호/보안 우려',
    '이용 중 불쾌한 경험이 있었음',
    '광고/알림이 너무 많음',
    '다른 서비스를 사용하기 위해서',
    '기타',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const MainMicFab(),
      bottomNavigationBar: const MainBottomNavBar(selectedIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            const MainHeader(title: '회원탈퇴'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    _buildContent(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${UserData.name}님 정말 탈퇴하시겠어요?',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF5F5F5F),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '탈퇴하시려는 이유를 말씀해 주세요',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w100,
            color: const Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF505050)),
            borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedReason,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              items: _withdrawReasons.map((String reason) {
                return DropdownMenuItem<String>(
                  value: reason,
                  child: Text(
                    reason,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: reason == '선택해주세요' 
                          ? const Color(0xFF8C8C8C) 
                          : const Color(0xFF8C8C8C),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedReason = newValue!;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (_selectedReason != '선택해주세요') {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('탈퇴 이유를 선택해주세요.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Container(
                  height: 43,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF98E0F8), Color(0xFF9CCEFF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(CommonStyles.buttonRadius),
                  ),
                  child: Center(
                    child: Text(
                      '탈퇴하기',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 43,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFE5E5E5),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(CommonStyles.buttonRadius),
                  ),
                  child: Center(
                    child: Text(
                      '취소',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00C2FD),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
