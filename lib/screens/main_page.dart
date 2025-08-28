import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'ad_creation_page.dart';
import 'revenue_analysis_page.dart';
import 'review_analysis_page.dart';
import 'government_policy_page.dart';
import 'mypage.dart';
import 'ai_chat_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mybiz_app/widgets/main_bottom_nav.dart';
import 'package:mybiz_app/widgets/main_page_layout.dart';
import 'package:mybiz_app/widgets/common_styles.dart';

import 'scraping_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _menuOpen = false;
  int _menuFocusIndex = -1;

  @override
  Widget build(BuildContext context) {
    return MainPageLayout(
      selectedIndex: _selectedIndex,
      child: Stack(
        children: [
          Column(
            children: [
              _buildLogoSection(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildBannerSection(),
                      _buildMenuCards(),
                      _buildRevenueSection(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildSideMenu(),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          SvgPicture.asset('assets/images/MyBiz.svg', height: 22, fit: BoxFit.contain),
          const Spacer(),
          GestureDetector(
            onTap: () => setState(() {
              _menuOpen = true;
              _menuFocusIndex = -1; // 메뉴 열 때 포커스 초기화
            }),
            child: Image.asset('assets/images/menu.png', width: 26, height: 14, fit: BoxFit.contain),
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
            borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
            child: Image.asset(path, fit: BoxFit.cover, width: double.infinity),
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
          _buildMenuCard('광고 생성', 'AI를 통한 광고 생성', Icons.create, const Color(0xFF333333), imagePath: 'assets/images/ad.png', width: cardWidth, scale: scale),
          _buildMenuCard('매출 분석', 'AI를 통한 매출분석', Icons.trending_up, const Color(0xFF333333), imagePath: 'assets/images/revenue.png', width: cardWidth, scale: scale),
          _buildMenuCard('리뷰 분석', 'AI를 통한 리뷰 분석', Icons.rate_review, const Color(0xFF333333), imagePath: 'assets/images/review.png', width: cardWidth, scale: scale),
          _buildMenuCard('정부정책', '정부정책 확인', Icons.policy, const Color(0xFF333333), imagePath: 'assets/images/government.png', width: cardWidth, scale: scale),
        ],
      ),
    );
  }

  Widget _buildMenuCard(String title, String subtitle, IconData icon, Color color, {String? imagePath, double? width, double scale = 1.0}) {
    final sub = subtitle.replaceAll('\n', ' ');
    final iconSize = 46.0 * scale;
    return GestureDetector(
      onTap: () {
        if (title == '광고 생성') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AdCreationPage()));
        } else if (title == '매출 분석') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const RevenueAnalysisPage()));
        } else if (title == '리뷰 분석') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ScrapingPage()));
        } else if (title == '정부정책') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const GovernmentPolicyPage()));
        }
      },
      child: SizedBox(
        width: width,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(CommonStyles.cardRadius), border: Border.all(color: const Color(0xFFFCFCFD))),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20 * scale, fontWeight: FontWeight.w700, color: color, letterSpacing: -0.8)),
              const SizedBox(height: 2),
              Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16 * scale, fontWeight: FontWeight.w400, color: const Color(0xFF999999), letterSpacing: -0.8)),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.bottomRight,
                child: imagePath != null ? Image.asset(imagePath, width: iconSize, height: iconSize, fit: BoxFit.contain) : Icon(icon, size: iconSize, color: color.withOpacity(0.6)),
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
          SizedBox(
            height: 37,
            child: Row(
              children: [
                Text('매출분석', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF6B6A6F), letterSpacing: -0.8)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, PageRouteBuilder(pageBuilder: (context, a, b) => const RevenueAnalysisPage(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero));
                  },
                  child: Row(
                    children: [
                      Text('더보기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: const Color(0xFF999999), letterSpacing: -0.8)),
                      const SizedBox(width: 6),
                      Transform.rotate(angle: 3.14159, child: Opacity(opacity: 0.5, child: Image.asset('assets/images/arrow.png', width: 8, height: 8, fit: BoxFit.contain))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildMainRevenueCard(),
          const SizedBox(height: 5),
          _buildRevenueCards(),
        ],
      ),
    );
  }

  Widget _buildMainRevenueCard() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF12131F), borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이번달 총 매출', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.6), letterSpacing: -0.8)),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('52,003,000원', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.8)),
                Row(
                  children: [
                    Image.asset('assets/images/mainRevenueUP.png', width: 26, height: 14, fit: BoxFit.contain),
                    const SizedBox(width: 10),
                    Text('+40.2%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFFB1FFCE), letterSpacing: -0.8)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(width: double.infinity, height: 2, decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(4.5))),
            const SizedBox(height: 15),
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
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.8), letterSpacing: -0.8)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.8)),
        ],
      ),
    );
  }

  Widget _buildRevenueCards() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: _buildRevenueCard('오늘 매출', '+ 8.2%', 'assets/images/todayup.png', dotColor: Colors.green)),
          const SizedBox(width: 15),
          Expanded(child: _buildRevenueCard('이번주 매출', '+ 4.2%', 'assets/images/monthup.png', dotColor: Colors.blue)),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(String title, String percentage, String imagePath, {Color dotColor = Colors.green}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333), letterSpacing: -0.8)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(percentage, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: dotColor, letterSpacing: -0.8)),
                ],
              ),
            ],
          ),
          Image.asset(imagePath, width: 24, height: 24, fit: BoxFit.contain),
        ],
      ),
    );
  }

    Widget _buildSideMenu() {
    final w = MediaQuery.of(context).size.width;
    final panelW = w * 0.7;
    
    final menuItems = [
      {'title': '광고 생성', 'icon': Icons.create_rounded},
      {'title': '매출 분석', 'icon': Icons.trending_up_rounded},
      {'title': '리뷰 분석', 'icon': Icons.rate_review_rounded},
      {'title': '정부정책', 'icon': Icons.policy_rounded},
      {'title': '마이페이지', 'icon': Icons.person_rounded},
    ];

    return IgnorePointer(
      ignoring: !_menuOpen,
      child: Stack(
        children: [
          // 배경 오버레이
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _menuOpen ? 1 : 0,
            child: GestureDetector(
              onTap: () => setState(() => _menuOpen = false), 
              child: Container(color: Colors.black.withOpacity(0.25))
            ),
          ),
          // 사이드 메뉴 패널
          AnimatedPositioned(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOutCubic,
            top: 0,
            bottom: 0,
            right: _menuOpen ? 0 : -panelW - 40,
            child: Container(
              width: panelW,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), 
                  bottomLeft: Radius.circular(20)
                ), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08), 
                    blurRadius: 20, 
                    offset: const Offset(-4, 0)
                  )
                ]
              ),
              child: Column(
                children: [
                  // 헤더 섹션
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20)
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xFFF0F0F0), 
                          width: 1
                        )
                      )
                    ),
                    child: Row(
                      children: [
                        const Text(
                          '전체 메뉴', 
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.w700, 
                            color: Color(0xFF333333), 
                            letterSpacing: -0.8
                          )
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => setState(() => _menuOpen = false), 
                          child: const Icon(
                            Icons.close_rounded, 
                            size: 20, 
                            color: Color(0xFF666666)
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 메뉴 아이템들
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      itemCount: menuItems.length,
                      separatorBuilder: (_, __) => Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        color: const Color(0xFFF0F0F0),
                      ),
                      itemBuilder: (context, i) {
                        final selected = i == _menuFocusIndex;
                        final item = menuItems[i];
                        return GestureDetector(
                          onTap: () {
                            setState(() => _menuFocusIndex = i);
                            Future.delayed(const Duration(milliseconds: 90), () {
                              if (item['title'] == '광고 생성') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const AdCreationPage()));
                              } else if (item['title'] == '매출 분석') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const RevenueAnalysisPage()));
                              } else if (item['title'] == '리뷰 분석') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const ScrapingPage()));
                              } else if (item['title'] == '정부정책') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const GovernmentPolicyPage()));
                              } else if (item['title'] == '마이페이지') {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => MyPage()));
                              }
                              setState(() => _menuOpen = false);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                            decoration: BoxDecoration(
                              gradient: selected ? LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  CommonStyles.primaryColor.withOpacity(0.04),
                                  CommonStyles.primaryLightColor.withOpacity(0.02),
                                ],
                              ) : null,
                              color: selected ? null : Colors.transparent, 
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                // 메뉴 제목
                                Expanded(
                                  child: Text(
                                    item['title'] as String,
                                    style: TextStyle(
                                      fontSize: 16, 
                                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500, 
                                      color: selected ? const Color(0xFF00C2FD) : const Color(0xFF333333), 
                                      letterSpacing: -0.8
                                    ),
                                  ),
                                ),
                                // 화살표 아이콘
                                if (selected)
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Color(0xFF00C2FD)
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
