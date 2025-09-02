import 'package:flutter/material.dart';
import 'package:mybiz_app/widgets/main_header.dart';
import 'package:mybiz_app/widgets/main_page_layout.dart';
import 'package:mybiz_app/widgets/common_styles.dart';
import 'package:mybiz_app/screens/naver_link_page.dart';
import 'package:mybiz_app/services/naver_link_service.dart';
import 'package:mybiz_app/services/review_scraper_service.dart';
import 'package:mybiz_app/services/review_analysis_service.dart';
import 'package:mybiz_app/services/user_data_service.dart';
import 'package:mybiz_app/data/sample_reviews.dart';
import 'package:mybiz_app/config/app_config.dart';
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
  bool _hasData = false; // 리뷰 데이터 존재 여부 (기본: 없음)
  Map<String, dynamic>? _analysisData; // 분석 결과 데이터
  List<Map<String, dynamic>>? _reviews; // 리뷰 데이터
  
  // 비동기 스크래핑 관련 상태
  int _progress = 0; // 진행률 (0-100)
  String _statusMessage = ''; // 상태 메시지

  final ReviewScraperService _scraper = ReviewScraperService();
  final ReviewAnalysisService _analysisService = ReviewAnalysisService();
  final NaverLinkService _naverService = NaverLinkService();
  bool _isLinked = false; // 네이버 연동 여부

  @override
  void initState() {
    super.initState();
    _fetchIntegrationStatus();
    _loadExistingData(); // 기존 데이터 로드
  }

  Future<void> _fetchIntegrationStatus() async {
    try {
      final userStoreId = await UserDataService.getUserStoreId();
      if (userStoreId == null || userStoreId.isEmpty) {
        setState(() {
          _isLinked = false;
        });
        return;
      }
      final res = await _naverService.status(userStoreId: userStoreId);
      final data = (res['data'] as Map?) ?? {};
      final integration = (data['integration'] as Map?) ?? {};
      final hasCred = integration['has_credentials'] == true;
      final status = (integration['integration_status'] as String?) ?? 'not_configured';
      final linked = hasCred && (status == 'configured' || status == 'active');
      setState(() {
        _isLinked = linked;
      });
    } catch (_) {
      setState(() {
        _isLinked = false;
      });
    }
  }

  // 기존 데이터 로드
  Future<void> _loadExistingData() async {
    try {
      // 하드코딩 모드에서는 최초 진입 시 자동 로드하지 않고 버튼 누를 때 로딩 후 표시
      if (SampleReviewData.useHardcodedData) {
        if (AppConfig.debugMode) {
          print('🔍 [DEBUG] 하드코딩 모드: 초기 자동 로드는 건너뜁니다. 버튼 클릭 시 로딩 후 표시');
        }
        return;
      }

      // 실제 API 데이터 사용
      final userStoreId = await UserDataService.getUserStoreId();
      if (userStoreId == null || userStoreId.isEmpty) return;

      // 리뷰 분석 수행 (기존 리뷰가 있으면 분석, 없으면 빈 결과)
      final analysisRes = await _analysisService.analyzeReview(userStoreId: userStoreId);
      if (analysisRes['success'] == true) {
        final data = analysisRes['data'] as Map<String, dynamic>?;
        if (data != null) {
          final reviews = data['reviews'] as List<dynamic>?;
          final analysis = data['analysis'] as Map<String, dynamic>?;
          
          setState(() {
            _reviews = reviews?.cast<Map<String, dynamic>>() ?? [];
            _analysisData = analysis;
            _hasData = reviews != null && reviews.isNotEmpty;
          });
        }
      }
    } catch (e) {
      print('기존 데이터 로드 실패: $e');
    }
  }

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
                  
                  // 로딩 상태 카드는 사용하지 않음 (버튼 자리에서 로딩 처리)
                  
                  // 오류 상태 표시
                  if (_hasError) ...[
                    _buildErrorSection(),
                    const SizedBox(height: 24),
                  ],
                  
                  // 진행 상황 표시 (스크래핑 중일 때)
                  if (_isAnalyzing && !_hasError) ...[
                    _buildProgressSection(),
                    const SizedBox(height: 24),
                  ],
                  
                  // 분석 결과 표시
                  if (_showAnalysisResults && !_hasError) ...[
                    if (!_hasData) ...[
                      _buildNoDataSection(),
                      const SizedBox(height: 24),
                    ] else ...[
                      _buildCustomerSatisfactionSection(),
                      const SizedBox(height: 24),
                      _buildRecentReviewsSection(),
                      const SizedBox(height: 24),
                      _buildGoodPointsSection(),
                      const SizedBox(height: 24),
                      _buildImprovementAreasSection(),
                      const SizedBox(height: 24),
                      // 액션 버튼들 (스크래핑 완료 후에만 표시)
                      _buildActionButtons(),
                      const SizedBox(height: 24),
                    ],
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

  // ========== 무데이터 상태 ==========
  Widget _buildNoDataSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(
            _isLinked ? '리뷰 데이터가 없어요 😭' : '네이버 스마트플레이스\n연동해주세요 😭',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isAnalyzing
                ? '열심히 분석 중입니다!🧐\n최신 리뷰를 모으고 있어요... 잠시만요!'
                : (_isLinked
                    ? '버튼을 눌러 최신 리뷰 분석을 해보세요!'
                    : '네이버 플레이스 연동 후 리뷰 분석을 이용할 수 있어요'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 16),
          if (!_isLinked) ...[
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Container(
                decoration: BoxDecoration(
                  gradient: CommonStyles.brandGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const NaverLinkPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '네이버 플레이스 연동하러 가기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.8,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (_isLinked) ...[
            SizedBox(
              width: double.infinity,
              height: 48,
              child: _isAnalyzing
                  ? Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00AEFF)),
                        ),
                      ),
                    )
                  : OutlinedButton(
                      onPressed: _requestScraping,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '리뷰 분석하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
            ),
          ],
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
                child: const Center(
                  child: Text(
                    '매출 분석',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.55,
                      color: Color(0xFF999999),
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
                child: const Center(
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
    // 실제 분석 데이터에서 만족도 정보 추출
    final satisfaction = _analysisData?['satisfaction'] as Map<String, dynamic>?;
    final positive = (satisfaction?['positive'] as int? ?? 0) / 100.0;
    final neutral = (satisfaction?['neutral'] as int? ?? 0) / 100.0;
    final negative = (satisfaction?['negative'] as int? ?? 0) / 100.0;
    
    // 디버그: 분석 데이터 로그 (디버그 모드일 때만)
    if (AppConfig.debugMode) {
      print('🔍 [DEBUG] _analysisData: $_analysisData');
      print('🔍 [DEBUG] satisfaction: $satisfaction');
      print('🔍 [DEBUG] positive: $positive, neutral: $neutral, negative: $negative');
    }
    
    final positivePercent = (positive * 100).round();
    final neutralPercent = (neutral * 100).round();
    final negativePercent = (negative * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '고객 만족도 분석',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.8,
            color: Color(0xFF333333),
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
                child: SizedBox(
                  width: double.infinity,
                  height: 15,
                  child: Row(
                    children: [
                      Expanded(
                        flex: positivePercent,
                        child: Container(
                          height: double.infinity,
                          color: const Color(0xFF9BDFFF),
                        ),
                      ),
                      Expanded(
                        flex: neutralPercent,
                        child: Container(
                          height: double.infinity,
                          color: const Color(0xFFFFCB9B),
                        ),
                      ),
                      Expanded(
                        flex: negativePercent,
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
                        '긍정 ($positivePercent%)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.8,
                          color: Color(0xFF333333),
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
                        '보통 ($neutralPercent%)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.8,
                          color: Color(0xFF333333),
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
                        '부정 ($negativePercent%)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.8,
                          color: Color(0xFF333333),
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
    // 실제 리뷰 데이터 사용 (최대 3개)
    final recentReviews = _reviews?.take(3).toList() ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '최근 등록된 리뷰',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        if (recentReviews.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
            ),
            child: const Center(
              child: Text(
                '등록된 리뷰가 없습니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF999999),
                ),
              ),
            ),
          )
        else
          Column(
            children: recentReviews.asMap().entries.map((entry) {
              final index = entry.key;
              final review = entry.value;
              
              final author = review['author_nickname'] as String? ?? '익명';
              final content = review['review_content'] as String? ?? '';
              final date = review['review_date'] as String? ?? '';
              final tags = review['extra_metadata'] as Map<String, dynamic>?;
              final tag = tags?['tags'] as String? ?? '';
              
              return Column(
                children: [
                  _buildReviewItem(author, content, tag, date),
                  if (index < recentReviews.length - 1) const SizedBox(height: 12),
                ],
              );
            }).toList(),
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
    // 실제 분석 데이터에서 긍정적 키워드 추출
    List<dynamic> positiveKeywords = _analysisData?['positive_keywords'] as List<dynamic>? ?? [];
    // 폴백: 분석 데이터에 키워드가 없으면 _reviews에서 수집
    if ((positiveKeywords).isEmpty && ((_reviews ?? const <Map<String, dynamic>>[])).isNotEmpty) {
      final Map<String, int> freq = {};
      final reviewsList = _reviews ?? const <Map<String, dynamic>>[];
      for (final r in reviewsList) {
        final meta = r['extra_metadata'] as Map<String, dynamic>?;
        final List<String> list = (meta?['positive_keywords'] as List?)?.cast<String>() ?? const <String>[];
        for (final k in list) {
          freq[k] = (freq[k] ?? 0) + 1;
        }
      }
      positiveKeywords = freq.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      // 렌더링 단계에서 문자열/객체 모두 처리하도록 유지
      final int reviewLen = reviewsList.isNotEmpty ? reviewsList.length : 1;
      positiveKeywords = positiveKeywords
          .take(5)
          .map((e) => {'keyword': e.key, 'score': e.value / (reviewLen.clamp(1, 9999))})
          .toList();
      if (AppConfig.debugMode) {
        print('🔍 [DEBUG] fallback positiveKeywords from reviews: $positiveKeywords');
      }
    }
    
    // 디버그: 긍정 키워드 로그 (디버그 모드일 때만)
    if (AppConfig.debugMode) {
      print('🔍 [DEBUG] positiveKeywords: $positiveKeywords');
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '이런 점이 좋아요!',
          style: TextStyle(
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
          child: positiveKeywords.isEmpty
              ? const Center(
                  child: Text(
                    '긍정적 피드백이 없습니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: positiveKeywords.take(3).map((keyword) {
                    // keyword가 문자열 리스트(예: ['맛있음', ...]) 또는
                    // 객체 리스트(예: [{'keyword': '맛있음', 'score': 0.8}, ...]) 모두를 처리
                    final bool isMapKeyword = keyword is Map<String, dynamic>;
                    final String text = isMapKeyword
                        ? (keyword['keyword'] as String? ?? '')
                        : (keyword as String? ?? '');
                    final double score = isMapKeyword
                        ? ((keyword['score'] as num?)?.toDouble() ?? 0.0)
                        : 0.0;
                    final int percentage = (score * 100).round();
                    
                    return Column(
                      children: [
                        _buildProgressItem(text, percentage, true),
                        if (keyword != positiveKeywords.last) const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildImprovementAreasSection() {
    // 실제 분석 데이터에서 부정적 키워드 추출
    List<dynamic> negativeKeywords = _analysisData?['negative_keywords'] as List<dynamic>? ?? [];
    // 폴백: 분석 데이터에 키워드가 없으면 _reviews에서 수집
    if ((negativeKeywords).isEmpty && ((_reviews ?? const <Map<String, dynamic>>[])).isNotEmpty) {
      final Map<String, int> freq = {};
      final reviewsList = _reviews ?? const <Map<String, dynamic>>[];
      for (final r in reviewsList) {
        final meta = r['extra_metadata'] as Map<String, dynamic>?;
        final List<String> list = (meta?['negative_keywords'] as List?)?.cast<String>() ?? const <String>[];
        for (final k in list) {
          freq[k] = (freq[k] ?? 0) + 1;
        }
      }
      negativeKeywords = freq.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final int reviewLen = reviewsList.isNotEmpty ? reviewsList.length : 1;
      negativeKeywords = negativeKeywords
          .take(5)
          .map((e) => {'keyword': e.key, 'score': e.value / (reviewLen.clamp(1, 9999))})
          .toList();
      if (AppConfig.debugMode) {
        print('🔍 [DEBUG] fallback negativeKeywords from reviews: $negativeKeywords');
      }
    }
    
    // 디버그: 부정 키워드 로그 (디버그 모드일 때만)
    if (AppConfig.debugMode) {
      print('🔍 [DEBUG] negativeKeywords: $negativeKeywords');
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '이런 점이 아쉬워요!',
          style: TextStyle(
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
          child: negativeKeywords.isEmpty
              ? const Center(
                  child: Text(
                    '개선이 필요한 부분이 없습니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: negativeKeywords.take(3).map((keyword) {
                    // 문자열/객체 형태 모두 지원
                    final bool isMapKeyword = keyword is Map<String, dynamic>;
                    final String text = isMapKeyword
                        ? (keyword['keyword'] as String? ?? '')
                        : (keyword as String? ?? '');
                    final double score = isMapKeyword
                        ? ((keyword['score'] as num?)?.toDouble() ?? 0.0)
                        : 0.0;
                    final int percentage = (score * 100).round();
                    
                    return Column(
                      children: [
                        _buildProgressItem(text, percentage, false),
                        if (keyword != negativeKeywords.last) const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
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

  // (미사용) 재분석 요청 UI 제거

  // (삭제) 상단 로딩 카드 사용 안 함

  // ========== 진행 상황 표시 ==========
  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.analytics_outlined,
            size: 48,
            color: Color(0xFF00AEFF),
          ),
          const SizedBox(height: 16),
          const Text(
            '리뷰 분석 진행 중',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _statusMessage.isNotEmpty ? _statusMessage : '스크래핑을 진행하고 있습니다...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          // 진행률 바
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _progress / 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: CommonStyles.brandGradient,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$_progress%',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00AEFF),
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
        const Text(
          '분석 결과 활용',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
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

  // (삭제) 하단 스크래핑 요청 버튼

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
    
    // 필요 시 스낵바 사용으로 교체 가능
  }

  // ========== 비동기 스크래핑 요청 로직 ==========
  Future<void> _requestScraping() async {
    final userStoreId = await UserDataService.getUserStoreId();
    if (!mounted) return;
    if (userStoreId == null || userStoreId.isEmpty) {
      _showSnackBar('스토어 정보가 없습니다. 마이페이지에서 가게 등록/선택 후 이용해 주세요.');
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _hasError = false;
      _errorMessage = '';
      _progress = 0;
      _statusMessage = '스크래핑 작업 시작 중...';
    });

    try {
      // 1. 하드코딩 모드: 가짜 로딩 → 결과 세팅
      if (SampleReviewData.useHardcodedData) {
        // 단계적 진행률 표시 (가벼운 시뮬레이션)
        for (final step in [15, 35, 60, 85]) {
          await Future.delayed(const Duration(milliseconds: 400));
          if (!mounted) return;
          setState(() {
            _progress = step;
            _statusMessage = '분석 중... ($step%)';
          });
        }
        await Future.delayed(const Duration(milliseconds: 500));
        final sampleReviews = SampleReviewData.getFormattedReviews();
        final analysisResult = SampleReviewData.getAnalysisResult();
        if (!mounted) return;
        setState(() {
          _reviews = sampleReviews;
          _analysisData = analysisResult;
          _hasData = true;
          _isAnalyzing = false;
          _progress = 100;
          _statusMessage = '분석 완료';
        });
        _showSnackBar('리뷰 ${sampleReviews.length}개로 분석을 완료했습니다!');
        return;
      }

      // 1. 스크래핑 요청 (동기/비동기 모두 처리)
      final startRes = await _scraper.scrapeReviews(userStoreId: userStoreId);
      
      // 디버그: API 응답 로그 (디버그 모드일 때만)
      if (AppConfig.debugMode) {
        print('🔍 [DEBUG] API 응답: $startRes');
      }
      
      if (!mounted) return;
      
      if (startRes['success'] == true) {
        final data = startRes['data'] as Map<String, dynamic>?;
        final jobId = data?['jobId'] as String?;
        final isFromDB = data?['isFromDB'] as bool? ?? false;
        
        // 디버그: 데이터 구조 로그 (디버그 모드일 때만)
        if (AppConfig.debugMode) {
          print('🔍 [DEBUG] data: $data');
          print('🔍 [DEBUG] jobId: $jobId');
          print('🔍 [DEBUG] isFromDB: $isFromDB');
        }
        
        if (jobId != null) {
          // 비동기 스크래핑 응답
          setState(() {
            _statusMessage = '스크래핑 작업이 시작되었습니다.';
          });
          
          // 2. 진행 상황 폴링 시작
          _pollJobStatus(jobId);
        } else if (isFromDB) {
          // 기존 리뷰 분석 완료 응답
          if (SampleReviewData.useHardcodedData) {
            // 하드코딩된 데이터 사용
            final sampleReviews = SampleReviewData.getFormattedReviews();
            final analysisResult = SampleReviewData.getAnalysisResult();
            
            setState(() {
              _reviews = sampleReviews;
              _analysisData = analysisResult;
              _hasData = true;
              _isAnalyzing = false;
            });
            
            _showSnackBar('하드코딩된 샘플 리뷰 ${sampleReviews.length}개로 분석을 완료했습니다!');
          } else {
            // 실제 API 데이터 사용
            final reviews = data?['reviews'] as List<dynamic>?;
            final analysis = data?['analysis'] as Map<String, dynamic>?;
            
            setState(() {
              _reviews = reviews?.cast<Map<String, dynamic>>() ?? [];
              _analysisData = analysis;
              _hasData = reviews != null && reviews.isNotEmpty;
              _isAnalyzing = false;
            });
            
            _showSnackBar('기존 리뷰 ${reviews?.length ?? 0}개로 분석을 완료했습니다!');
          }
        } else {
          // 새로운 스크래핑 완료 응답
          if (SampleReviewData.useHardcodedData) {
            // 하드코딩된 데이터 사용
            final sampleReviews = SampleReviewData.getFormattedReviews();
            final analysisResult = SampleReviewData.getAnalysisResult();
            
            setState(() {
              _reviews = sampleReviews;
              _analysisData = analysisResult;
              _hasData = true;
              _isAnalyzing = false;
            });
            
            _showSnackBar('하드코딩된 샘플 리뷰 ${sampleReviews.length}개로 분석을 완료했습니다!');
          } else {
            // 실제 API 데이터 사용
            final reviews = data?['reviews'] as List<dynamic>?;
            final analysis = data?['analysis'] as Map<String, dynamic>?;
            
            setState(() {
              _reviews = reviews?.cast<Map<String, dynamic>>() ?? [];
              _analysisData = analysis;
              _hasData = reviews != null && reviews.isNotEmpty;
              _isAnalyzing = false;
            });
            
            _showSnackBar('새로운 리뷰 스크래핑 및 분석을 완료했습니다!');
          }
        }
      } else {
        throw Exception(startRes['message'] ?? '스크래핑 시작에 실패했습니다.');
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isAnalyzing = false;
      });
      
      _showSnackBar('스크래핑 시작 실패: ${e.toString()}');
    }
  }

  // 작업 상태 폴링
  Future<void> _pollJobStatus(String jobId) async {
    while (mounted && _isAnalyzing) {
      try {
        final statusRes = await _scraper.getScrapingJobStatus(jobId: jobId);
        
        if (!mounted) return;
        
        if (statusRes['success'] == true) {
          final data = statusRes['data'] as Map<String, dynamic>?;
          if (data != null) {
            final status = data['status'] as String? ?? 'pending';
            final progress = data['progress'] as int? ?? 0;
            final message = data['message'] as String? ?? '';
            
            setState(() {
              _progress = progress;
              _statusMessage = message;
            });

            if (status == 'completed') {
              // 완료 시 데이터 새로고침
              await _loadExistingData();
              setState(() {
                _isAnalyzing = false;
                _hasData = true;
              });
              _showSnackBar('스크래핑이 완료되었습니다!');
              break;
            } else if (status == 'failed') {
              setState(() {
                _hasError = true;
                _errorMessage = message;
                _isAnalyzing = false;
              });
              _showSnackBar('스크래핑 실패: $message');
              break;
            }
          }
        }
        
        // 설정된 간격 후 다시 확인
        await Future.delayed(Duration(seconds: AppConfig.pollingIntervalSeconds));
      } catch (e) {
        if (!mounted) return;
        
        setState(() {
          _hasError = true;
          _errorMessage = '상태 확인 중 오류: ${e.toString()}';
          _isAnalyzing = false;
        });
        break;
      }
    }
  }



  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
} 