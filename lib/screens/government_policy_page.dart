import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_page.dart';
import 'ad_creation_page.dart';
import 'revenue_analysis_page.dart';
import 'mypage.dart';
import 'ai_chat_page.dart';

class GovernmentPolicyPage extends StatefulWidget {
  const GovernmentPolicyPage({super.key});

  @override
  State<GovernmentPolicyPage> createState() => _GovernmentPolicyPageState();
}

class _GovernmentPolicyPageState extends State<GovernmentPolicyPage> {
  String _selectedRegion = '전체';

  final List<String> _regions = ['전체', '서울', '경기', '인천', '부산', '광주', '대구', '대전', '이외'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      body: SafeArea(
        child: Column(
          children: [
            
            // 헤더
            _buildHeader(),
            
            // 지역 선택 버튼들
            _buildRegionButtons(),
            
            // 메인 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    
                    // 정부정책 카드들
                    _buildPolicyCard(
                      imagePath: 'assets/images/store.png',
                      title: '타이틀입니다.',
                      subtitle: '서브타이틀 입니다.',
                      date: '2025.08.04',
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildPolicyCard(
                      imagePath: 'assets/images/store.png',
                      title: '타이틀입니다.',
                      subtitle: '서브타이틀 입니다.',
                      date: '2025.08.04',
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildPolicyCard(
                      imagePath: 'assets/images/store.png',
                      title: '타이틀입니다.',
                      subtitle: '서브타이틀 입니다.',
                      date: '2025.08.04',
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // 하단 네비게이션
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
          Center(
            child: const Text(
              '정부정책',
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
            pageBuilder: (context, animation, secondaryAnimation) => const MainPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        ),
              child: Container(
                width: 8,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Color(0xFF333333),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionButtons() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _regions.map((region) {
            bool isSelected = _selectedRegion == region;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRegion = region;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : const Color(0xFFEDEEF3),
                    borderRadius: BorderRadius.circular(7.25),
                    border: isSelected 
                      ? Border.all(color: const Color(0xFFD5D4DA))
                      : null,
                  ),
                  child: Text(
                    region,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPolicyCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required String date,
    bool hasOverlay = false,
    String? overlayText,
    String? overlaySubtext,
    String? overlaySubtext2,
    String? overlaySubtext3,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 영역
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.grey[200],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (hasOverlay) ...[
                  // 오버레이 텍스트들
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Text(
                      overlayText ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 27.5,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFD7D7D6),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 100,
                    child: Text(
                      overlaySubtext ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 35,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFCFB902),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 230,
                    child: Text(
                      overlaySubtext2 ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 37.4,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFE3E3E2),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 70,
                    left: 20,
                    child: Text(
                      overlaySubtext3 ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 22.7,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFD7D7D6),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // 텍스트 영역
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    date,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


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
              _buildNavItem('assets/images/menuAnalysis.png', '분석', false),
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

} 