import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'ad_creation_page.dart';
import 'revenue_analysis_page.dart';
import 'review_analysis_page.dart';
import 'government_policy_page.dart';
import 'mypage.dart';
import 'ai_chat_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      body: SafeArea(
        child: Column(
          children: [
            // 고정 영역 (Fix 그룹)
            _buildLogoSection(),

            // 스크롤 가능한 영역
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 배너 섹션
                    _buildBannerSection(),

                    // 메뉴 카드들
                    _buildMenuCards(),

                    // 매출 분석 섹션
                    _buildRevenueSection(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 고정된 하단 네비게이션
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

Widget _buildLogoSection() {
  return Container(
    height: 70, // 높이 키움
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Row(
      children: [
        SvgPicture.asset(
          'assets/images/MyBiz.svg',
          height: 22,
          fit: BoxFit.contain,
        ),
        const Spacer(),
        Image.asset(
          'assets/images/menu.png',
          width: 26,
          height: 14,
          fit: BoxFit.contain,
        ),
      ],
    ),
  );
}

  Widget _buildBannerSection() {
    final List<String> bannerImages = [
      'assets/images/banner.jpg',
      'assets/images/banner2.jpg',
      'assets/images/banner3.png',
    ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          enlargeCenterPage: false,
          viewportFraction: 1,
        ),
        items: bannerImages.map((path) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              path,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
        }).toList(),
      ),
    );
  }
Widget _buildMenuCards() {
  final w = MediaQuery.of(context).size.width;
  const marginH = 20.0;
  const gap = 10.0;
  const cols = 2;
  final cardWidth = (w - marginH * 2 - gap * (cols - 1)) / cols;
  final scale = w < 360 ? 0.9 : w < 420 ? 0.95 : 1.0;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: marginH, vertical: 20),
    child: Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        _buildMenuCard('광고 생성', 'AI를 통한 광고 생성', Icons.create, const Color(0xFF333333),
            imagePath: 'assets/images/ad.png', width: cardWidth, scale: scale),
        _buildMenuCard('매출 분석', 'AI를 통한 매출분석', Icons.trending_up, const Color(0xFF333333),
            imagePath: 'assets/images/revenue.png', width: cardWidth, scale: scale),
        _buildMenuCard('리뷰 분석', 'AI를 통한 리뷰 분석', Icons.rate_review, const Color(0xFF333333),
            imagePath: 'assets/images/review.png', width: cardWidth, scale: scale),
        _buildMenuCard('정부정책', '정부정책 확인', Icons.policy, const Color(0xFF333333),
            imagePath: 'assets/images/government.png', width: cardWidth, scale: scale),
      ],
    ),
  );
}

Widget _buildMenuCard(
  String title,
  String subtitle,
  IconData icon,
  Color color, {
  String? imagePath,
  double? width,
  double scale = 1.0,
}) {
  final sub = subtitle.replaceAll('\n', ' ');
  final iconSize = 46.0 * scale;

  return GestureDetector(
    onTap: () {
      if (title == '광고 생성') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdCreationPage()));
      } else if (title == '매출 분석') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const RevenueAnalysisPage()));
      } else if (title == '리뷰 분석') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewAnalysisPage()));
      } else if (title == '정부정책') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const GovernmentPolicyPage()));
      }
    },
    child: SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFCFCFD)),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20 * scale, fontWeight: FontWeight.w700, color: color, letterSpacing: -0.8)),
            const SizedBox(height: 2),
            Text(sub,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16 * scale, fontWeight: FontWeight.w400, color: const Color(0xFF999999), letterSpacing: -0.8)),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: imagePath != null
                  ? Image.asset(imagePath, width: iconSize, height: iconSize, fit: BoxFit.contain)
                  : Icon(icon, size: iconSize, color: color.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildRevenueSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // 매출분석 헤더 (Figma 디자인과 동일)
          Container(
            height: 37,
            child: Row(
              children: [
                Text(
                  '매출분석',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6B6A6F),
                    letterSpacing: -0.8
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  RevenueAnalysisPage(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ));
                  },
                  child: Row(
                    children: [
                      Text(
                        '더보기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF999999),
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Transform.rotate(
                        angle: 3.14159, // 180도 회전 (π radians)
            child: Opacity(
              opacity: 0.5, // ← 원하는 투명도 (0.0~1.0)
              child: Image.asset(
                'assets/images/arrow.png',
                width: 8,
                height: 8,
                fit: BoxFit.contain,
              ),
            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 큰 매출 카드 (이번달 총 매출)
          _buildMainRevenueCard(),

          const SizedBox(height: 5),

          // 작은 매출 카드들
          _buildRevenueCards(),
        ],
      ),
    );
  }

  Widget _buildMainRevenueCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF12131F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이번달 총 매출 텍스트
            Text(
              '이번달 총 매출',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.6),
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 2),

            // 금액과 퍼센트
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '52,003,000원',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.8,
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/mainRevenueUP.png',
                      width: 26,
                      height: 14,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '+40.2%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFB1FFCE),
                        letterSpacing: -0.8,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),

            // 차트 이미지 (플레이스홀더)
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.5),
              ),
            ),

            const SizedBox(height: 15),

            // 통계 정보들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('총주문', '423'),
                _buildStatItem('방문인원', '232'),
                _buildStatItem('리뷰', '4.95'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.8,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildRevenueCards() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Expanded(
          child: _buildRevenueCard(
            '오늘 매출',
            '+ 8.2%',
            'assets/images/todayup.png',
            dotColor: Colors.green, // 초록 점
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildRevenueCard(
            '이번주 매출',
            '+ 4.2%',
            'assets/images/monthup.png',
            dotColor: Colors.blue, // 파랑 점
          ),
        ),
      ],
    ),
  );
}


  Widget _buildRevenueCard(String title, String percentage, String imagePath,
    {Color dotColor = Colors.green}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 왼쪽: 제목 + (점 + %)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  percentage,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: dotColor, // 점 색상과 통일
                    letterSpacing: -0.8,
                  ),
                ),
              ],
            ),
          ],
        ),
        // 오른쪽: 아이콘 (세로 가운데)
        Image.asset(
          imagePath,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
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
              _buildNavItem('assets/images/menuHome.png', '홈', true),
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
