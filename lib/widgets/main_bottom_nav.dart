import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mybiz_app/widgets/common_styles.dart';
import 'package:mybiz_app/screens/main_page.dart';
import 'package:mybiz_app/screens/ad_creation_page.dart';
import 'package:mybiz_app/screens/revenue_analysis_page.dart';
import 'package:mybiz_app/screens/mypage.dart';
import 'package:mybiz_app/screens/ai_chat_page.dart';

class MainBottomNavBar extends StatelessWidget {
    final int selectedIndex;
    const MainBottomNavBar({super.key, required this.selectedIndex});

    void _onTap(BuildContext context, int index) {
        if (index == 0) {
            Navigator.push(context, PageRouteBuilder(
                pageBuilder: (c, a, b) => const MainPage(), 
                transitionDuration: Duration.zero, 
                reverseTransitionDuration: Duration.zero
            ));
        } else if (index == 1) {
            Navigator.push(context, PageRouteBuilder(
                pageBuilder: (c, a, b) => const AdCreationPage(), 
                transitionDuration: Duration.zero, 
                reverseTransitionDuration: Duration.zero
            ));
        } else if (index == 2) {
            Navigator.push(context, PageRouteBuilder(
                pageBuilder: (c, a, b) => const RevenueAnalysisPage(), 
                transitionDuration: Duration.zero, 
                reverseTransitionDuration: Duration.zero
            ));
        } else if (index == 3) {
            Navigator.push(context, PageRouteBuilder(
                pageBuilder: (c, a, b) => MyPage(), 
                transitionDuration: Duration.zero, 
                reverseTransitionDuration: Duration.zero
            ));
        }
    }

    @override
    Widget build(BuildContext context) {
        final bottom = MediaQuery.of(context).padding.bottom;
        return ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(CommonStyles.dialogRadius), topRight: Radius.circular(CommonStyles.dialogRadius)),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                    height: 80 + (bottom > 0 ? bottom / 2 : 0),
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: bottom > 0 ? bottom / 2 : 8),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                                Color(0xEBFFFFFF), // 왼쪽 아래 - 기본 색상
                                Color(0xF5FFFFFF), // 중간 - 약간 밝게
                                Color(0xFFFFFFFF), // 오른쪽 위 - 가장 밝게
                            ],
                            stops: [0.0, 0.6, 1.0],
                        ),
                    ),
                    child: Row(
                        children: [
                            _NavChip(index: 0, imagePath: 'assets/images/menuHome.png', label: '홈', selectedIndex: selectedIndex, onTap: _onTap),
                            _NavChip(index: 1, imagePath: 'assets/images/menuAD.png', label: '광고 생성', selectedIndex: selectedIndex, onTap: _onTap),
                            const SizedBox(width: 86),
                            _NavChip(index: 2, imagePath: 'assets/images/menuAnalysis.png', label: '분석', selectedIndex: selectedIndex, onTap: _onTap),
                            _NavChip(index: 3, imagePath: 'assets/images/menuMypage.png', label: '마이페이지', selectedIndex: selectedIndex, onTap: _onTap),
                        ],
                    ),
                ),
            ),
        );
    }
}

class _NavChip extends StatelessWidget {
    final int index;
    final String imagePath;
    final String label;
    final int selectedIndex;
    final void Function(BuildContext, int) onTap;
    
    const _NavChip({
        required this.index, 
        required this.imagePath, 
        required this.label, 
        required this.selectedIndex, 
        required this.onTap
    });
    
    @override
    Widget build(BuildContext context) {
        final isSelected = selectedIndex == index;
        return Expanded(
            child: InkWell(
                borderRadius: BorderRadius.circular(CommonStyles.buttonRadius),
                onTap: () => onTap(context, index),
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        gradient: isSelected 
                            ? const LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                    Color(0xFFF6F6F6), // 선택된 탭 - 왼쪽 아래 (더 연하게)
                                    Color(0xFFF5F5F5), // 선택된 탭 - 중간
                                    Color(0xFFFAFAFA), // 선택된 탭 - 오른쪽 위 (밝게)
                                ],
                                stops: [0.0, 0.6, 1.0],
                              )
                            : null,
                        color: isSelected ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(CommonStyles.buttonRadius),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Opacity(
                                opacity: isSelected ? 1.0 : 0.55, 
                                child: Image.asset(
                                    imagePath, 
                                    width: 24, 
                                    height: 24, 
                                    fit: BoxFit.contain
                                )
                            ),
                            const SizedBox(height: 6),
                            Text(
                                label, 
                                maxLines: 2, 
                                textAlign: TextAlign.center, 
                                style: TextStyle(
                                    fontSize: 10, 
                                    height: 1.1, 
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, 
                                    color: isSelected ? const Color(0xFF333333) : Colors.grey[600], 
                                    letterSpacing: -0.55
                                )
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}

class MainMicFab extends StatelessWidget {
    const MainMicFab({super.key});
    
    @override
    Widget build(BuildContext context) {
        return Center(
            child: GestureDetector(
                onTap: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (c, a, b) => const AiChatPage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                        ),
                    );
                },
                child: Container(
                    width: 74,
                    height: 74,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFFFFF), // 완전한 하얀색
                    ),
                    child: Center(
                        child: Container(
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
                            child: Center(
                                child: Image.asset(
                                    'assets/images/navMic.png',
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.contain,
                                ),
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
} 