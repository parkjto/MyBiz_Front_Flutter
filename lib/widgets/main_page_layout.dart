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
        final bottomInset = MediaQuery.of(context).padding.bottom;
        // 네비게이션 바(약 80) + FAB 여유분을 합산해 초기 렌더에서도 겹침 방지
        final reservedBottom = 120.0 + (bottomInset > 0 ? bottomInset / 2 : 0);
        return Material(
            color: const Color(0xFFF4F5FA),
            child: SafeArea(
                child: Stack(
                    children: [
                        Padding(
                            padding: EdgeInsets.only(bottom: reservedBottom),
                            child: child,
                        ),
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