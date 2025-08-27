import 'package:flutter/material.dart';
import 'package:mybiz_app/widgets/main_bottom_nav.dart';

class MainPageLayout extends StatelessWidget {
    final Widget child;
    final int selectedIndex;
    
    const MainPageLayout({
        super.key,
        required this.child,
        required this.selectedIndex,
    });
    
    @override
    Widget build(BuildContext context) {
        return Material(
            color: const Color(0xFFF4F5FA),
            child: SafeArea(
                child: Stack(
                    children: [
                        child,
                        // 고정된 네비게이션 바
                        Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: MainBottomNavBar(selectedIndex: selectedIndex),
                        ),
                        // 고정된 마이크 버튼
                        const Positioned(
                            bottom: 20, // 더 아래로 내리기 (30에서 20으로)
                            left: 0,
                            right: 0,
                            child: MainMicFab(),
                        ),
                    ],
                ),
            ),
        );
    }
} 