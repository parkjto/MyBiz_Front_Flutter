import 'package:flutter/material.dart';
import 'package:mybiz_app/widgets/main_bottom_nav.dart';
import 'package:mybiz_app/widgets/main_header.dart';
import 'package:mybiz_app/widgets/main_page_layout.dart';
import 'package:mybiz_app/widgets/common_styles.dart';
import 'revenue_analysis_page.dart';

class ScrapingPage extends StatefulWidget {
  const ScrapingPage({super.key});

  @override
  State<ScrapingPage> createState() => _ScrapingPageState();
}

class _ScrapingPageState extends State<ScrapingPage> {
  // 상태 관리
  bool _isAnalyzing = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _showAnalysisResults = true; // 분석 결과 표시 여부

  @override
  Widget build(BuildContext context) {
    return MainPageLayout(
      selectedIndex: 2,
      child: Column(
        children: [
          const MainHeader(title: '리뷰분석'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnalysisTypeButtons(),
                  const SizedBox(height: 24),
                  

                  
                  // 로딩 상태 표시
                  if (_isAnalyzing) ...[
                    _buildLoadingSection(),
                    const SizedBox(height: 24),
                  ],
                  
                  // 오류 상태 표시
                  if (_hasError) ...[
                    _buildErrorSection(),
                    const SizedBox(height: 24),
                  ],
                  
                  // 분석 결과 표시
                  if (_showAnalysisResults && !_isAnalyzing && !_hasError) ...[
                    _buildCustomerSatisfactionSection(),
                    const SizedBox(height: 24),
                    _buildRecentReviewsSection(),
                    const SizedBox(height: 24),
                    _buildGoodPointsSection(),
                    const SizedBox(height: 24),
                    _buildImprovementAreasSection(),
                    const SizedBox(height: 24),
                    
                    // 액션 버튼들
                    _buildActionButtons(),
                    const SizedBox(height: 24),
                  ],
                  
                  const SizedBox(height: 100), // 네비게이션 바 높이만큼 여백 추가
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTypeButtons() {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const RevenueAnalysisPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
                ),
                child: Center(
                  child: Text(
                    '매출 분석',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.55,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: CommonStyles.brandGradient,
                  borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
                ),
                child: Center(
                  child: Text(
                    '리뷰분석',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.55,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSatisfactionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '고객 만족도 분석',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.8,
            color: const Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(CommonStyles.chipRadius),
                child: Container(
                  width: double.infinity,
                  height: 15,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 75,
                        child: Container(
                          height: double.infinity,
                          color: const Color(0xFF9BDFFF),
                        ),
                      ),
                      Expanded(
                        flex: 15,
                        child: Container(
                          height: double.infinity,
                          color: const Color(0xFFFFCB9B),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(
                          height: double.infinity,
                          color: const Color(0xFFFF9B9B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Color(0xFFBBDDFF),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                                              Text(
                          '긍정 (75%)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.8,
                            color: const Color(0xFF333333),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFCB9B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                                              Text(
                          '보통 (15%)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.8,
                            color: const Color(0xFF333333),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFBBBB),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                                              Text(
                          '부정 (10%)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.8,
                            color: const Color(0xFF333333),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최근 등록된 리뷰',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            _buildReviewItem('에베베게벱', '음식도 맛있고 사장님이 정말 친절해요!', '음식이탈리나와요', '방문일:7.27'),
            const SizedBox(height: 12),
            _buildReviewItem('에베베게벱', '음식도 맛있고 사장님이 정말 친절해요! 음식도 맛있고 사장님이 정말 친절해요! 음식도 맛있고 사장님이 정말 친절해요!', '음식이탈리나와요', '방문일:7.27'),
            const SizedBox(height: 12),
            _buildReviewItem('에베베게벱', '음식도 맛있고 사장님이 정말 친절해요!', '으아아아악', '방문일:7.27'),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewItem(String userId, String reviewText, String tag, String visitDate) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userId,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.8,
                  color: Color(0xFF333333),
                ),
              ),
              Text(
                visitDate,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.8,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            reviewText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.8,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(CommonStyles.chipRadius),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.8,
                  color: Color(0xFF666666),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoodPointsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이런 점이 좋아요!',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressItem('친절한 서비스', 92, true),
              const SizedBox(height: 16),
              _buildProgressItem('신선한 재료', 81, true),
              const SizedBox(height: 16),
              _buildProgressItem('넓고 쾌적한 공간', 87, true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImprovementAreasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이런 점이 아쉬워요!',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressItem('부족한 주차공간', 23, false),
              const SizedBox(height: 16),
              _buildProgressItem('적은 음식양', 19, false),
              const SizedBox(height: 16),
              _buildProgressItem('긴 대기시간', 12, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressItem(String title, int percentage, bool isGood) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.8,
                color: Color(0xFF333333),
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.8,
                color: isGood ? const Color(0xFF00AEFF) : const Color(0xFF666666),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5), // 배경색을 더 연하게
            borderRadius: BorderRadius.circular(CommonStyles.chipRadius),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: isGood ? const Color(0xFFB8E6FF) : const Color(0xFFE0E0E0), // 바 색상을 더 연하게
                borderRadius: BorderRadius.circular(CommonStyles.chipRadius),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ========== 재분석 요청 UI ==========
  Widget _buildReanalysisSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.refresh_rounded,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '새로운 리뷰 분석',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '새로운 이미지를 업로드하여\n리뷰를 분석해보세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showAnalysisResults = true;
                  _hasError = false;
                  _errorMessage = '';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00AEFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CommonStyles.buttonRadius),
                ),
                elevation: 0,
              ),
              child: const Text(
                '새로운 분석 시작',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== 로딩 상태 ==========
  Widget _buildLoadingSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00AEFF)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '리뷰 분석 중...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '잠시만 기다려주세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ========== 오류 상태 ==========
  Widget _buildErrorSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            '분석 중 오류가 발생했습니다',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red[700],
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage.isNotEmpty ? _errorMessage : '잠시 후 다시 시도해주세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _errorMessage = '';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red[600],
                      side: BorderSide(color: Colors.red[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(CommonStyles.buttonRadius),
                      ),
                    ),
                    child: const Text('다시 시도'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _errorMessage = '';
                        _showAnalysisResults = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(CommonStyles.buttonRadius),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('새로 시작'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========== 액션 버튼들 ==========
  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '분석 결과 활용',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF333333),
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.download_rounded,
                label: 'PDF 다운로드',
                onTap: _downloadPDF,
                color: const Color(0xFF666666), // 차분한 회색
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.table_chart,
                label: 'CSV 다운로드',
                onTap: _downloadCSV,
                color: const Color(0xFF666666), // 차분한 회색
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.share_rounded,
                label: '카카오톡 공유',
                onTap: _shareToKakao,
                color: const Color(0xFF666666), // 차분한 회색
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.email_rounded,
                label: '이메일 공유',
                onTap: _shareToEmail,
                color: const Color(0xFF666666), // 차분한 회색
              ),
            ),
          ],
        ),

      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 74,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
                letterSpacing: -0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== 액션 기능들 ==========
  
  // PDF 다운로드
  void _downloadPDF() {
    // TODO: 실제 PDF 생성 및 다운로드 로직 구현
    _showMessage('PDF 다운로드가 시작됩니다.');
  }

  // CSV 다운로드
  void _downloadCSV() {
    // TODO: 실제 CSV 생성 및 다운로드 로직 구현
    _showMessage('CSV 다운로드가 시작됩니다.');
  }

  // 카카오톡 공유
  void _shareToKakao() {
    // TODO: 카카오톡 공유 API 연동
    _showMessage('카카오톡 공유 기능을 준비 중입니다.');
  }

  // 이메일 공유
  void _shareToEmail() {
    // TODO: 이메일 공유 기능 구현
    _showMessage('이메일 공유 기능을 준비 중입니다.');
  }

  // 메시지 표시 (ScaffoldMessenger 대신 사용)
  void _showMessage(String message) {
    // 간단한 토스트 메시지 대신 상태 업데이트로 표시
    setState(() {
      // 메시지를 표시할 상태 변수 추가 필요
    });
    
    // 또는 간단한 print로 대체 (개발 중)
    print('Message: $message');
  }
} 