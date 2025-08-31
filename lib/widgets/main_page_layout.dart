import 'package:flutter/material.dart';
import 'package:mybiz_app/widgets/main_bottom_nav.dart';

class MainPageLayout extends StatelessWidget {
    final Widget child;
    final int selectedIndex;
    final VoidCallback? onLogout;
    
    const MainPageLayout({
        super.key,
        required this.child,
        required this.selectedIndex,
        this.onLogout,
    });
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: const Color(0xFFF4F5FA),
            body: SafeArea(
                child: Stack(
                    children: [
                        // 겹침 방지 없이 콘텐츠 표시
                        child,
                        // 고정된 네비게이션 바
                        Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: MainBottomNavBar(selectedIndex: selectedIndex, onLogout: onLogout),
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