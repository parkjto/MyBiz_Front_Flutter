import 'package:flutter/material.dart';
import 'scraping_page.dart';
import 'package:mybiz_app/widgets/main_header.dart';
import 'package:mybiz_app/widgets/main_page_layout.dart';
import 'package:mybiz_app/widgets/common_styles.dart';
import '../services/sales_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

class RevenueAnalysisPage extends StatefulWidget {
  const RevenueAnalysisPage({super.key});

  @override
  State<RevenueAnalysisPage> createState() => _RevenueAnalysisPageState();
}

class _RevenueAnalysisPageState extends State<RevenueAnalysisPage>
    with TickerProviderStateMixin {
  String _selectedYear = '2025';
  String _selectedMonth = '9';
  
  static const LinearGradient _brandGrad = CommonStyles.brandGradient;

  final List<String> _years = ['2024', '2025'];
  final List<String> _months = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
  
  // 애니메이션 컨트롤러들
  AnimationController? _chartAnimationController;
  AnimationController? _counterAnimationController;
  
  // 애니메이션 값들
  Animation<double>? _chartAnimation;
  Animation<double>? _counterAnimation;
  
  // 카운터 애니메이션용
  int _displayAmount = 0;
  int _targetAmount = 3250000;
  
  // 요약/주차 데이터
  List<double>? _weeklyTotals;
  int? _monthTotal;
  double? _momChangePct;
  List<Map<String, dynamic>> _monthlySeries = const [];
  
  // 인사이트용 상태
  final SalesService _salesService = SalesService();
  bool _insightLoading = false;
  String? _insightError;
  List<Map<String, dynamic>> _categoryTop3 = const [];
  List<Map<String, dynamic>> _bestsellerTop3 = const [];
  Map<String, dynamic>? _profitability;
  Map<String, dynamic>? _highlights;
  int? _peakHour;
  String? _topWeekday;
  bool _uploading = false;
  String? _uploadMessage;
  
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year.toString();
    _selectedMonth = now.month.toString();
    
    // 애니메이션 컨트롤러 초기화를 WidgetsBinding.instance.addPostFrameCallback으로 지연
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initializeAnimations();
      // 현재 월을 우선 선택하고, 데이터가 없으면 최신 데이터가 있는 달로 스냅
      await _snapToLatestMonthWithData();
      _fetchInsights();
      _fetchSummaryAndWeekly();
      _fetchMonthlySeries();
    });
  }

  // 현재 월을 우선적으로 선택하고, 데이터가 없을 때만 다른 달로 변경
  Future<void> _snapToLatestMonthWithData() async {
    try {
      final now = DateTime.now().toUtc();
      
      // 현재 월에 데이터가 있는지 먼저 확인
      final currentMonthStart = DateTime.utc(now.year, now.month, 1, 0, 0, 0);
      final currentMonthEnd = DateTime.utc(now.year, now.month + 1, 0, 23, 59, 59);
      
      try {
        final currentMonthData = await _salesService.getMonthly(
          start: currentMonthStart.toIso8601String(), 
          end: currentMonthEnd.toIso8601String()
        );
        
        // 현재 월에 데이터가 있으면 현재 월 유지 (아무것도 하지 않음)
        if (currentMonthData.isNotEmpty) {
          return;
        }
      } catch (_) {
        // 현재 월 조회 실패 시 무시하고 계속 진행
      }
      
      // 현재 월에 데이터가 없을 때만 최근 12개월에서 데이터가 있는 달 찾기
      final start = DateTime.utc(now.year, now.month - 11, 1, 0, 0, 0);
      final end = DateTime.utc(now.year, now.month + 1, 0, 23, 59, 59);
      final list = await _salesService.getMonthly(start: start.toIso8601String(), end: end.toIso8601String());
      
      final withData = list.where((e) {
        final t = e['total'];
        if (t is num) return t > 0;
        return false;
      }).toList();
      
      if (withData.isNotEmpty) {
        final last = withData.last; // asc 정렬 가정
        final monthStr = (last['month'] ?? '') as String; // YYYY-MM
        final parts = monthStr.split('-');
        if (parts.length == 2) {
          final y = parts[0];
          final m = parts[1].startsWith('0') ? parts[1].substring(1) : parts[1];
          if (mounted) {
            setState(() {
              _selectedYear = y;
              _selectedMonth = m;
            });
          }
        }
      }
    } catch (_) {
      // 조용히 무시하고 현재 월 유지
    }
  }
  
  void _initializeAnimations() {
    if (!mounted) return;
    
    // 애니메이션 컨트롤러 초기화
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _counterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // 애니메이션 설정
    _chartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _chartAnimationController!, curve: Curves.easeOutCubic)
    );
    
    _counterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _counterAnimationController!, curve: Curves.easeOutCubic)
    );
    
    // 애니메이션 시작
    _startAnimations();
    
    // 카운터 애니메이션 리스너
    _counterAnimationController!.addListener(() {
      if (mounted) {
        setState(() {
          _displayAmount = (_targetAmount * _counterAnimation!.value).round();
        });
      }
    });
    
    // setState 호출하여 위젯 재빌드
    setState(() {});
  }
  
  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && _chartAnimationController != null) {
        _chartAnimationController!.forward();
      }
    });
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && _counterAnimationController != null) {
        _counterAnimationController!.forward();
      }
    });
  }
  
  // 월 범위(UTC ISO)
  Map<String, String> _monthRangeUtc(int year, int month) {
    final start = DateTime.utc(year, month, 1, 0, 0, 0);
    final end = DateTime.utc(year, month + 1, 0, 23, 59, 59);
    return {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };
  }

  Future<void> _fetchInsights() async {
    if (!mounted) return;
    setState(() {
      _insightLoading = true;
      _insightError = null;
    });

    try {
      final y = int.tryParse(_selectedYear) ?? DateTime.now().year;
      final m = int.tryParse(_selectedMonth) ?? DateTime.now().month;
      final range = _monthRangeUtc(y, m);

      final results = await Future.wait([
        _salesService.getCategorySummary(start: range['start']!, end: range['end']!),
        _salesService.getBestsellers(start: range['start']!, end: range['end']!, limit: 3),
        _salesService.getProfitability(start: range['start']!, end: range['end']!, rate: 0.7),
        _salesService.getTimeOfDay(start: range['start']!, end: range['end']!),
        _salesService.getWeekday(start: range['start']!, end: range['end']!),
        _salesService.getHighlights(start: range['start']!, end: range['end']!),
      ]);

      final categories = List<Map<String, dynamic>>.from(results[0] as List);
      final bests = List<Map<String, dynamic>>.from(results[1] as List);
      final prof = Map<String, dynamic>.from(results[2] as Map);
      final byHour = List<Map<String, dynamic>>.from(results[3] as List);
      final byWeekday = List<Map<String, dynamic>>.from(results[4] as List);
      final hi = Map<String, dynamic>.from(results[5] as Map);

      // peak 계산
      int? peakHour;
      int maxHourVal = -1;
      for (final e in byHour) {
        final total = (e['total'] ?? 0) as int;
        final hour = (e['hour'] ?? 0) as int;
        if (total > maxHourVal) { maxHourVal = total; peakHour = hour; }
      }

      String? topWeekday;
      int maxDayVal = -1;
      for (final e in byWeekday) {
        final total = (e['total'] ?? 0) as int;
        final wd = (e['weekday'] ?? '') as String;
        if (total > maxDayVal) { maxDayVal = total; topWeekday = wd; }
      }

      // ROI Top3 (estimatedProfit 기준)
      final items = List<Map<String, dynamic>>.from(prof['items'] ?? const []);
      items.sort((a, b) => ((b['estimatedProfit'] ?? 0) as int).compareTo((a['estimatedProfit'] ?? 0) as int));
      final roiTop3 = items.take(3).map((e) => Map<String, dynamic>.from(e)).toList();

      setState(() {
        _categoryTop3 = categories.take(3).toList();
        _bestsellerTop3 = bests.take(3).toList();
        _profitability = { 'items': roiTop3, 'profitRate': prof['profitRate'], 'totalRevenue': prof['totalRevenue'] };
        _highlights = hi;
        _peakHour = peakHour;
        _topWeekday = topWeekday;
        _insightLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _insightError = '인사이트 로딩 실패';
        _insightLoading = false;
      });
    }
  }

  String _formatCurrency(num? v) {
    if (v == null) return '-';
    final s = v.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return s;
  }

  Future<void> _fetchSummaryAndWeekly() async {
    try {
      final y = int.tryParse(_selectedYear) ?? DateTime.now().year;
      final m = int.tryParse(_selectedMonth) ?? DateTime.now().month;
      final results = await Future.wait([
        _salesService.getMonthSummary(year: y, month: m),
        _salesService.getWeeklyByMonth(year: y, month: m),
      ]);

      final summary = Map<String, dynamic>.from(results[0] as Map);
      final weekly = List<double>.from(results[1] as List<double>);

      final monthTotal = (summary['monthTotal'] ?? 0) as int;
      final mom = (summary['momChangePct'] as num?)?.toDouble();

      setState(() {
        _monthTotal = monthTotal;
        _momChangePct = mom;
        _weeklyTotals = weekly;
        _targetAmount = monthTotal;
      });

      // 카운터 애니메이션 재시작
      _counterAnimationController?.reset();
      _counterAnimationController?.forward();
    } catch (_) {
      // 조용히 무시 (인사이트 섹션과 분리된 안전 로딩)
    }
  }

  Future<void> _fetchMonthlySeries() async {
    try {
      final y = int.tryParse(_selectedYear) ?? DateTime.now().year;
      final m = int.tryParse(_selectedMonth) ?? DateTime.now().month;
      // 최근 6개월 범위 계산
      final startMonth = DateTime.utc(y, m - 5, 1);
      final endMonthLastDay = DateTime.utc(y, m + 1, 0, 23, 59, 59);
      final startIso = startMonth.toIso8601String();
      final endIso = endMonthLastDay.toIso8601String();
      final list = await _salesService.getMonthly(start: startIso, end: endIso);
      setState(() {
        _monthlySeries = list;
      });
    } catch (_) {
      // 조용히 무시
    }
  }

  // CSV 업로드 섹션: 매출 박스와 동일한 카드 느낌, 가로폭 동일, 살짝 띄움
  Widget _buildCsvUploadSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CommonStyles.dialogRadius),
        border: Border.all(color: const Color(0xFFFCFCFD)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CSV 업로드',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _uploading ? null : _onPickAndUploadCsv,
                  borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: _uploading ? null : _brandGrad,
                      color: _uploading ? const Color(0xFFE1E6EC) : null,
                      borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
                    ),
                    child: Center(
                      child: _uploading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6E7480)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '업로드 중...',
                                  style: TextStyle(
                                    color: Color(0xFF6E7480),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              'CSV 선택 및 업로드',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_uploadMessage != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _uploadMessage!.contains('실패') || _uploadMessage!.contains('권한') || _uploadMessage!.contains('크기')
                    ? const Color(0xFFFFF5F5)
                    : const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _uploadMessage!.contains('실패') || _uploadMessage!.contains('권한') || _uploadMessage!.contains('크기')
                      ? const Color(0xFFFECACA)
                      : const Color(0xFFBFDBFE),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _uploadMessage!.contains('실패') || _uploadMessage!.contains('권한') || _uploadMessage!.contains('크기')
                        ? Icons.error_outline
                        : Icons.check_circle_outline,
                    size: 16,
                    color: _uploadMessage!.contains('실패') || _uploadMessage!.contains('권한') || _uploadMessage!.contains('크기')
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF059669),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _uploadMessage!,
                      style: TextStyle(
                        fontSize: 13,
                        color: _uploadMessage!.contains('실패') || _uploadMessage!.contains('권한') || _uploadMessage!.contains('크기')
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF059669),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _onPickAndUploadCsv() async {
    setState(() {
      _uploading = true;
      _uploadMessage = null;
    });
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv'],
        withData: true, // bytes 포함 (웹/모바일 공통)
        allowMultiple: false, // 안드로이드에서 단일 파일만 선택
        lockParentWindow: true, // 안드로이드에서 더 안정적
        dialogTitle: 'CSV 파일을 선택하세요', // 안드로이드에서 더 명확한 안내
      );
      
      if (res == null || res.files.isEmpty) {
        setState(() {
          _uploading = false;
          _uploadMessage = null; // 메시지도 초기화
        });
        return;
      }

      final file = res.files.single;
      Map<String, dynamic> result;
      
      if (file.bytes != null) {
        // 파일 크기 검증 (20MB)
        if (file.bytes!.length > 20 * 1024 * 1024) {
          setState(() {
            _uploadMessage = '파일 크기는 20MB 이하여야 합니다';
            _uploading = false;
          });
          return;
        }
        result = await _salesService.uploadCsvBytes(file.bytes!, file.name);
      } else if (file.path != null) {
        result = await _salesService.uploadCsv(file.path!);
      } else {
        throw Exception('파일을 읽을 수 없습니다');
      }

      setState(() {
        _uploadMessage = (result['data'] != null &&
                            result['data'] is Map &&
                            (result['data']['insertedCount'] ?? 0) > 0)
              ? (result['message']?.toString() ?? '업로드 완료')
              : (result['message']?.toString() ?? '업로드 실패');
        _uploading = false;
      });

        // 성공 메시지 3초 후 자동 제거
        if (_uploadMessage!.contains('완료') || _uploadMessage!.contains('성공')) {
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _uploadMessage = null;
              });
            }
          });
        }

        // 업로드가 성공적으로 처리된 경우(삽입 건수 > 0) 최신 데이터 달로 스냅 후 재로딩
        final inserted = (result['data'] is Map) ? (result['data']['insertedCount'] ?? 0) : 0;
        if (inserted is num && inserted > 0) {
          await _snapToLatestMonthWithData();
        }
        // 업로드 후 데이터 리프레시 (동일 가로 폭, 동일 카드 하단에 붙음)
        await Future.wait([
          _fetchSummaryAndWeekly(),
          _fetchMonthlySeries(),
          _fetchInsights(),
        ]);
    } catch (e) {
      // 에러 메시지 개선: 서버 메시지 우선 노출
      String errorMessage = '업로드 실패';
      if (e is DioError) {
        try {
          final data = e.response?.data;
          if (data is Map && data['message'] != null) {
            errorMessage = data['message'].toString();
          } else if (e.message != null) {
            errorMessage = e.message!;
          }
        } catch (_) {}
      } else {
        final s = e.toString();
        if (s.isNotEmpty) errorMessage = s;
      }
      
      setState(() {
        _uploadMessage = errorMessage;
        _uploading = false;
      });
    }
  }
  
  @override
  void dispose() {
    _chartAnimationController?.dispose();
    _counterAnimationController?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return MainPageLayout(
      selectedIndex: 2,
      child: Column(
        children: [
          const MainHeader(title: '분석'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnalysisTypeButtons(),
                  const SizedBox(height: 24),
                  _buildRevenueChartSection(),
                  const SizedBox(height: 12),
                  _buildCsvUploadSection(),
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
              onTap: () {},
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: _brandGrad,
                  borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
                ),
                child: const Center(
                  child: Text(
                    '매출 분석',
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
          const SizedBox(width: 6),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const ScrapingPage(),
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
                    '리뷰분석',
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
        ],
      ),
    );
  }

  Widget _buildRevenueChartSection() {
    final weekly = _weeklyTotals ?? <double>[12000, 39000, 30000, 40000, 12000, 70000];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CommonStyles.dialogRadius),
        border: Border.all(color: const Color(0xFFFCFCFD)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$_selectedYear년 $_selectedMonth월 매출',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.8,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              // 숫자 카운팅 애니메이션
              _counterAnimation != null
                ? AnimatedBuilder(
                    animation: _counterAnimation!,
                    builder: (context, child) {
                      return Text(
                        '${_displayAmount.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},'
                        )}원',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.8,
                          color: Color(0xFF333333),
                        ),
                      );
                    },
                  )
                : Text(
                    '${_formatCurrency(_monthTotal)}원',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.8,
                      color: Color(0xFF333333),
                    ),
                  ),
              const Spacer(),
              Text(
                _momChangePct == null
                  ? '지난달 대비 -'
                  : '지난달 대비 ${_momChangePct! >= 0 ? '+' : ''}${_momChangePct!.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.8,
                  color: Color(0xFF9AA0A6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 220,
            width: double.infinity,
            child: _chartAnimation != null
              ? AnimatedBuilder(
                  animation: _chartAnimation!,
                  builder: (context, child) {
                    return _RevenueLineChart(
                      data: weekly,
                      lineColor: const Color(0xFF63B8F6),
                      fillColor: const Color(0xFF98E0F8).withOpacity(0.25),
                      gridColor: const Color(0xFFE9EEF3),
                      dotColor: const Color(0xFF63B8F6),
                      animationValue: _chartAnimation!.value,
                    );
                  },
                )
              : _RevenueLineChart(
                  data: weekly,
                  lineColor: const Color(0xFF63B8F6),
                  fillColor: const Color(0xFF98E0F8).withOpacity(0.25),
                  gridColor: const Color(0xFFE9EEF3),
                  dotColor: const Color(0xFF63B8F6),
                  animationValue: 1.0,
                ),
          ),
          const SizedBox(height: 8),

          // X축 라벨
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1주차', style: _weekLabel),
              Text('2주차', style: _weekLabel),
              Text('3주차', style: _weekLabel),
              Text('4주차', style: _weekLabel),
              Text('5주차', style: _weekLabel),
              Text('6주차', style: _weekLabel),
            ],
          ),
          const SizedBox(height: 16),

          // 연/월 선택 – 알약 버튼 UI
          Row(
            children: [
              Expanded(child: _buildYearPill()),
              const SizedBox(width: 12),
              Expanded(child: _buildMonthPill()),
            ],
          ),
          const SizedBox(height: 14),
          // _buildMonthlySeriesSection(), // 요청에 따라 월별 시계열 섹션 임시 비표시
          const SizedBox(height: 14),
          _buildInsightsSection(),
        ],
      ),
    );
  }

  TextStyle get _weekLabel => const TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.8,
    color: Color(0xFFB8BDC3),
  );

  Widget _buildYearPill() {
    return _PillPicker(
      label: '$_selectedYear년',
      onTap: () async {
        final picked = await _showBottomPicker(context, _years.map((e)=>'$e년').toList(), '$_selectedYear년');
        if (picked != null) {
          setState(() => _selectedYear = picked.replaceAll('년', ''));
          await Future.wait([
            _fetchInsights(),
            _fetchSummaryAndWeekly(),
          ]);
        }
      },
    );
  }

  Widget _buildMonthPill() {
    return _PillPicker(
      label: '$_selectedMonth월',
      onTap: () async {
        final picked = await _showBottomPicker(context, _months.map((e)=>'$e월').toList(), '$_selectedMonth월');
        if (picked != null) {
          setState(() => _selectedMonth = picked.replaceAll('월', ''));
          await Future.wait([
            _fetchInsights(),
            _fetchSummaryAndWeekly(),
            _fetchMonthlySeries(),
          ]);
        }
      },
    );
  }

  Future<String?> _showBottomPicker(BuildContext ctx, List<String> items, String current) {
    return showModalBottomSheet<String>(
      context: ctx,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final v = items[i];
              final sel = v == current;
              return ListTile(
                title: Text(
                  v,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                    letterSpacing: -0.8,
                    color: sel ? const Color(0xFF1F6BFF) : const Color(0xFF333333),
                  ),
                ),
                onTap: () => Navigator.pop(ctx, v),
              );
            },
          ),
        );
      },
    );
  }
}

// ===== Helpers (place these OUTSIDE of _RevenueAnalysisPageState) =====

extension on _RevenueAnalysisPageState {
  Widget _buildMonthlySeriesSection() {
    if (_monthlySeries.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '월별 시계열',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6B6A6F), letterSpacing: -0.5),
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _monthlySeries.map((e) {
              final month = (e['month'] ?? '') as String; // YYYY-MM
              final total = e['total'];
              final label = '$month ${_formatCurrency(total)}';
              return Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(CommonStyles.chipRadius),
                  border: Border.all(color: const Color(0xFFE9EEF3)),
                ),
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: Color(0xFF6E7480), letterSpacing: -0.3),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  Widget _buildInsightsSection() {
    if (_insightLoading) {
      return const SizedBox.shrink();
    }
    if (_insightError != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          _insightError!,
          style: const TextStyle(fontSize: 13, color: Color(0xFFB00020)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMiniRow(
          title: '카테고리 TOP3',
          chips: _categoryTop3.map((e) => '${e['category'] ?? '기타'} ${_formatCurrency(e['total'])}').toList(),
        ),
        const SizedBox(height: 8),
        _buildMiniRow(
          title: '베스트셀러 TOP3',
          chips: _bestsellerTop3.map((e) => '${e['productName'] ?? '-'} ${_formatCurrency(e['total'])}').toList(),
        ),
        const SizedBox(height: 8),
        _buildMiniRow(
          title: 'ROI TOP3',
          chips: List<Map<String, dynamic>>.from((_profitability?['items'] ?? const [])).map((e) => '${e['productName'] ?? '-'} ${_formatCurrency(e['estimatedProfit'])}').toList(),
        ),
        const SizedBox(height: 8),
        _buildMiniRow(
          title: '피크',
          chips: [
            if (_peakHour != null) '시간대 ${_peakHour}시',
            if (_topWeekday != null) '요일 ${_weekdayKo(_topWeekday!)}',
          ],
        ),
        if (_highlights?['maxGrowth'] != null) ...[
          const SizedBox(height: 8),
          _buildMiniRow(
            title: '성장구간',
            chips: [
              '${_highlights!['maxGrowth']['fromMonth']}→${_highlights!['maxGrowth']['toMonth']} +${_highlights!['maxGrowth']['growthRatePct']}%'
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildMiniRow({required String title, required List<String> chips}) {
    if (chips.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B6A6F),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: chips.take(3).map((t) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(CommonStyles.chipRadius),
              border: Border.all(color: const Color(0xFFE9EEF3)),
            ),
            child: Text(
              t,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6E7480),
                letterSpacing: -0.3,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  String _weekdayKo(String code) {
    switch (code) {
      case 'Sun':
        return '일요일';
      case 'Mon':
        return '월요일';
      case 'Tue':
        return '화요일';
      case 'Wed':
        return '수요일';
      case 'Thu':
        return '목요일';
      case 'Fri':
        return '금요일';
      case 'Sat':
        return '토요일';
      default:
        return code;
    }
  }
}

class _PillPicker extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PillPicker({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
                  borderRadius: BorderRadius.circular(CommonStyles.chipRadius),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(CommonStyles.chipRadius),
          border: Border.all(color: const Color(0xFFE1E6EC)),

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.8,
                color: Color(0xFF6E7480),
              ),
            ),
            const Icon(Icons.expand_more, size: 18, color: Color(0xFF9AA0A6)),
          ],
        ),
      ),
    );
  }
}

class _RevenueLineChart extends StatelessWidget {
  final List<double> data;
  final Color lineColor;
  final Color fillColor;
  final Color gridColor;
  final Color dotColor;
  final double animationValue;

  const _RevenueLineChart({
    required this.data,
    required this.lineColor,
    required this.fillColor,
    required this.gridColor,
    required this.dotColor,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: _RevenuePainter(
          data: data,
          lineColor: lineColor,
          fillColor: fillColor,
          gridColor: gridColor,
          dotColor: dotColor,
          animationValue: animationValue,
        ),
      ),
    );
  }
}

class _RevenuePainter extends CustomPainter {
  final List<double> data;
  final Color lineColor, fillColor, gridColor, dotColor;
  final double animationValue;

  _RevenuePainter({
    required this.data,
    required this.lineColor,
    required this.fillColor,
    required this.gridColor,
    required this.dotColor,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const padding = EdgeInsets.fromLTRB(8, 8, 8, 24);
    final chart = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.horizontal,
      size.height - padding.vertical,
    );

    // grid
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    const gridCount = 4;
    for (int i = 0; i <= gridCount; i++) {
      final y = chart.top + chart.height * (i / gridCount);
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }

    // 데이터 없거나 길이 1 방어
    if (data.isEmpty) {
      return;
    }
    // scale (모든 값이 0일 때 분모 0 방지)
    final baseMax = data.reduce((a, b) => a > b ? a : b);
    final maxVal = (baseMax <= 0 ? 1.0 : baseMax * 1.15);
    final dx = data.length > 1 ? chart.width / (data.length - 1) : 0.0;

    // helper pt 제거 (미사용)

    // 애니메이션된 데이터 포인트 계산
    final animatedData = data.map((value) => value * animationValue).toList();

    // line + fill
    final linePath = Path();
    final fillPath = Path();
    for (int i = 0; i < animatedData.length; i++) {
      final animatedValue = animatedData[i];
      final x = chart.left + (dx.isFinite ? i * dx : 0.0);
      final ratio = (animatedValue / maxVal);
      final safeRatio = ratio.isFinite && !ratio.isNaN ? ratio : 0.0;
      final y = chart.bottom - safeRatio * chart.height;
      final p = Offset(x, y);
      
      if (i == 0) {
        linePath.moveTo(p.dx, p.dy);
        fillPath.moveTo(p.dx, chart.bottom);
        fillPath.lineTo(p.dx, p.dy);
      } else {
        linePath.lineTo(p.dx, p.dy);
        fillPath.lineTo(p.dx, p.dy);
      }
    }
    fillPath.lineTo(chart.right, chart.bottom);
    fillPath.close();

    // 애니메이션된 채우기
    final animatedFillColor = fillColor.withOpacity(fillColor.opacity * animationValue);
    canvas.drawPath(fillPath, Paint()..color = animatedFillColor);

    // 애니메이션된 라인
    final linePaint = Paint()
      ..color = lineColor.withOpacity(animationValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    // 애니메이션된 점들
    final dotPaint = Paint()..color = dotColor.withOpacity(animationValue);
    for (int i = 0; i < animatedData.length; i++) {
      final animatedValue = animatedData[i];
      final x = chart.left + (dx.isFinite ? i * dx : 0.0);
      final ratio = (animatedValue / maxVal);
      final safeRatio = ratio.isFinite && !ratio.isNaN ? ratio : 0.0;
      final y = chart.bottom - safeRatio * chart.height;
      final p = Offset(x, y);
      
      canvas.drawCircle(p, 4, dotPaint);
      canvas.drawCircle(p, 2, Paint()..color = Colors.white.withOpacity(animationValue));
    }
  }

  @override
  bool shouldRepaint(covariant _RevenuePainter old) =>
      old.data != data ||
      old.lineColor != lineColor ||
      old.fillColor != fillColor ||
      old.gridColor != gridColor ||
      old.dotColor != dotColor ||
      old.animationValue != animationValue;
}
