import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_page.dart';
import 'review_analysis_page.dart';

class CaptureTutorialPage extends StatefulWidget {
  final String? returnTo;
  
  const CaptureTutorialPage({super.key, this.returnTo});

  @override
  State<CaptureTutorialPage> createState() => _CaptureTutorialPageState();
}

class _CaptureTutorialPageState extends State<CaptureTutorialPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

     final List<Map<String, dynamic>> _tutorialSteps = [
     {
       'title': '1단계: 리뷰 섹션으로 이동',
       'description': '네이버 플레이스에서 해당 업체의\n리뷰 섹션으로 이동하세요.',
       'image': 'assets/images/myplace.png',
       'step': '1/2'
     },
     {
       'title': '2단계: 스크롤 캡처 실행',
       'description': '스크롤 캡처 기능을 사용하여 모든 리뷰를\n한 번에 캡처하세요.',
       'image': 'assets/images/naverplaceReview.png',
       'step': '2/2'
     },
   ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      body: SafeArea(
        child: Column(
          children: [
            
            // 헤더
            _buildHeader(),
            
            // 튜토리얼 콘텐츠
            Expanded(
              child: Column(
                children: [
                  // 페이지 인디케이터
                  _buildPageIndicator(),
                  
                  // 튜토리얼 페이지뷰
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentStep = index;
                        });
                      },
                      itemCount: _tutorialSteps.length,
                      itemBuilder: (context, index) {
                        return _buildTutorialStep(_tutorialSteps[index]);
                      },
                    ),
                  ),
                  
                  // 하단 버튼들
                  _buildBottomButtons(),
                ],
              ),
            ),
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
            child: Text(
              '캡처 방법 가이드',
              style: GoogleFonts.inter(

                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.55,
                color: Color(0xFF333333),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
                             onTap: () {
                 Navigator.pushReplacement(
                   context,
                   PageRouteBuilder(
                     pageBuilder: (context, animation, secondaryAnimation) => const ReviewAnalysisPage(),
                     transitionDuration: Duration.zero,
                     reverseTransitionDuration: Duration.zero,
                   ),
                 );
               },
              child: Container(
                width: 8,
                height: 16,
                decoration: const BoxDecoration(
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

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_tutorialSteps.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: index == _currentStep ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: index == _currentStep 
                  ? const Color(0xFF5999FF) 
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

           Widget _buildTutorialStep(Map<String, dynamic> step) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
                                      // 모든 화면에서 동일한 구조 사용
             // 스텝 표시
             Container(
               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
               decoration: BoxDecoration(
                 color: const Color(0xFF5999FF).withOpacity(0.1),
                 borderRadius: BorderRadius.circular(20),
               ),
               child: Text(
                 step['step'],
                 style: GoogleFonts.inter(
                   fontSize: 12,
                   fontWeight: FontWeight.w600,
                   color: const Color(0xFF5999FF),
                 ),
               ),
             ),
             
             const SizedBox(height: 16),
             
             // 제목
             Text(
               step['title'],
               style: GoogleFonts.inter(
                 fontSize: 24,
                 fontWeight: FontWeight.bold,
                 color: const Color(0xFF333333),
               ),
               textAlign: TextAlign.center,
             ),
             
             const SizedBox(height: 12),
             
             // 설명
             Text(
               step['description'],
               style: GoogleFonts.inter(
                 fontSize: 16,
                 color: Colors.grey[600],
                 height: 1.5,
               ),
               textAlign: TextAlign.center,
             ),
             
             const SizedBox(height: 32),
             
             // 이미지
             Expanded(
               child: Container(
                 width: double.infinity,
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(16),
                   border: Border.all(color: Colors.grey[300]!),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black.withOpacity(0.1),
                       blurRadius: 10,
                       offset: const Offset(0, 4),
                     ),
                   ],
                 ),
                 child: ClipRRect(
                   borderRadius: BorderRadius.circular(16),
                   child: Image.asset(
                     step['image'],
                     fit: BoxFit.contain,
                   ),
                 ),
               ),
                          ),
          ],
        ),
      );
    }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // 이전 버튼
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF5999FF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  '이전',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5999FF),
                  ),
                ),
              ),
            ),
          
          if (_currentStep > 0) const SizedBox(width: 12),
          
          // 다음/완료 버튼
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_currentStep < _tutorialSteps.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // 튜토리얼 완료
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5999FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _currentStep < _tutorialSteps.length - 1 ? '다음' : '완료',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
