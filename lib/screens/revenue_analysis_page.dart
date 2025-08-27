import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_page.dart';
import 'ad_creation_page.dart';
import 'mypage.dart';
import 'review_analysis_page.dart';
import 'ai_chat_page.dart';
import 'scraping_page.dart';
import 'package:mybiz_app/widgets/main_bottom_nav.dart';
import 'package:mybiz_app/widgets/main_header.dart';
import 'package:mybiz_app/widgets/main_page_layout.dart';
import 'package:mybiz_app/widgets/common_styles.dart';

class RevenueAnalysisPage extends StatefulWidget {
  const RevenueAnalysisPage({super.key});

  @override
  State<RevenueAnalysisPage> createState() => _RevenueAnalysisPageState();
}

class _RevenueAnalysisPageState extends State<RevenueAnalysisPage> {
  String _selectedYear = '2025';
  String _selectedMonth = '9';
  
  static const LinearGradient _brandGrad = CommonStyles.brandGradient;

  final List<String> _years = ['2024', '2025'];
  final List<String> _months = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
  
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year.toString();
    _selectedMonth = now.month.toString();
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
        borderRadius: BorderRadius.circular(15),
        
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
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    '매출 분석',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8,
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
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    '리뷰분석',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8,
                      color: const Color(0xFF999999),
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
    final weekly = <double>[12000, 39000, 30000, 40000, 12000, 70000];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: const Color(0xFFFCFCFD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_selectedYear}년 ${_selectedMonth}월 매출',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.8,
              color: const Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                '3,250,000원',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.8,
                  color: const Color(0xFF333333),
                ),
              ),
              const Spacer(),
              Text(
                '지난달 대비 +28%',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.8,
                  color: const Color(0xFF9AA0A6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 220,
            width: double.infinity,
            child: _RevenueLineChart(
              data: weekly,
              lineColor: const Color(0xFF63B8F6),
              fillColor: const Color(0xFF98E0F8).withOpacity(0.25),
              gridColor: const Color(0xFFE9EEF3),
              dotColor: const Color(0xFF63B8F6),
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
        ],
      ),
    );
  }

  TextStyle get _weekLabel => TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.8,
    color: const Color(0xFFB8BDC3),
  );

  Widget _buildYearPill() {
    return _PillPicker(
      label: '${_selectedYear}년',
      onTap: () async {
        final picked = await _showBottomPicker(context, _years.map((e)=>'$e년').toList(), '${_selectedYear}년');
        if (picked != null) setState(() => _selectedYear = picked.replaceAll('년', ''));
      },
    );
  }

  Widget _buildMonthPill() {
    return _PillPicker(
      label: '${_selectedMonth}월',
      onTap: () async {
        final picked = await _showBottomPicker(context, _months.map((e)=>'$e월').toList(), '${_selectedMonth}월');
        if (picked != null) setState(() => _selectedMonth = picked.replaceAll('월', ''));
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

class _PillPicker extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PillPicker({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE1E6EC)),

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.8,
                color: const Color(0xFF6E7480),
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

  const _RevenueLineChart({
    required this.data,
    required this.lineColor,
    required this.fillColor,
    required this.gridColor,
    required this.dotColor,
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
        ),
      ),
    );
  }
}

class _RevenuePainter extends CustomPainter {
  final List<double> data;
  final Color lineColor, fillColor, gridColor, dotColor;

  _RevenuePainter({
    required this.data,
    required this.lineColor,
    required this.fillColor,
    required this.gridColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final padding = const EdgeInsets.fromLTRB(8, 8, 8, 24);
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

    // scale
    final maxVal = (data.reduce((a, b) => a > b ? a : b) * 1.15);
    final dx = chart.width / (data.length - 1);

    Offset pt(int i) {
      final x = chart.left + i * dx;
      final y = chart.bottom - (data[i] / maxVal) * chart.height;
      return Offset(x, y);
    }

    // line + fill
    final linePath = Path();
    final fillPath = Path();
    for (int i = 0; i < data.length; i++) {
      final p = pt(i);
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

    canvas.drawPath(fillPath, Paint()..color = fillColor);

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    // dots
    final dotPaint = Paint()..color = dotColor;
    for (int i = 0; i < data.length; i++) {
      final p = pt(i);
      canvas.drawCircle(p, 4, dotPaint);
      canvas.drawCircle(p, 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _RevenuePainter old) =>
      old.data != data ||
      old.lineColor != lineColor ||
      old.fillColor != fillColor ||
      old.gridColor != gridColor ||
      old.dotColor != dotColor;
}
