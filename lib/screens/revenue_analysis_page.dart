import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_page.dart';
import 'ad_creation_page.dart';
import 'mypage.dart';
import 'review_analysis_page.dart';
import 'ai_chat_page.dart';

class RevenueAnalysisPage extends StatefulWidget {
  const RevenueAnalysisPage({super.key});

  @override
  State<RevenueAnalysisPage> createState() => _RevenueAnalysisPageState();
}

class _RevenueAnalysisPageState extends State<RevenueAnalysisPage> {
  String _selectedYear = '2025';
  String _selectedMonth = '9';
  
  static const LinearGradient _brandGrad = LinearGradient(
    colors: [Color(0xFF00AEFF), Color(0xFF0084FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  final List<String> _years = ['2024', '2025'];
  final List<String> _months = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
  
  @override
  void initState() {
    super.initState();
    // 현재 년월로 기본값 설정
    final now = DateTime.now();
    _selectedYear = now.year.toString();
    _selectedMonth = now.month.toString();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      body: SafeArea(
        child: Column(
          children: [
            
            // 앱바
            _buildAppBar(),
            
            // 메인 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 분석 타입 선택 버튼
                    _buildAnalysisTypeButtons(),
                    
                    const SizedBox(height: 24),
                    
                    // 매출 차트 섹션
                    _buildRevenueChartSection(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // 하단 네비게이션
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  

  Widget _buildAppBar() {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Center(
            child: const Text(
              '분석',
              style: TextStyle(

                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.8,
                color: Color(0xFF333333),
              ),
            ),
          ),
                                                             Align(
                       alignment: Alignment.centerLeft,
                       child: GestureDetector(
              onTap: () => Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        ),
              child: Container(
                width: 8,
                height: 16,
                decoration: BoxDecoration(
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

  Widget _buildAnalysisTypeButtons() {
  return Container(
    height: 56,
padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        // 매출 분석(선택됨)
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
        // 리뷰 분석(비활성)
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const ReviewAnalysisPage(),
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
                  '리뷰 분석',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.8,
                    color: const Color(0xFF6B6A6F),
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

  TextStyle _getWeekLabelStyle(double opacity) {
    return TextStyle(
      fontSize: 12.9,
      fontWeight: FontWeight.w400,
      color: const Color(0xFFC5C5C5).withOpacity(opacity),
    );
  }

  Widget _buildYearDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedYear,
      decoration: InputDecoration(
        hintText: '연도 선택',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.5),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.5),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.5),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
        ),
        filled: true,
        fillColor: const Color(0xFFFEFEFE),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: _years.map((String year) {
        return DropdownMenuItem<String>(
          value: year,
          child: Text('${year}년'),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedYear = newValue!;
        });
      },
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFB6B6BB),
      ),
    );
  }

  Widget _buildMonthDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedMonth,
      decoration: InputDecoration(
        hintText: '월 선택',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.5),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.5),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.5),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
        ),
        filled: true,
        fillColor: const Color(0xFFFEFEFE),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: _months.map((String month) {
        return DropdownMenuItem<String>(
          value: month,
          child: Text('${month}월'),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedMonth = newValue!;
        });
      },
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFB6B6BB),
      ),
    );
  }


Widget _buildBottomNavigation() {
  return SizedBox(
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem('assets/images/menuHome.png', '홈', false),
              _buildNavItem('assets/images/menuAD.png', '광고 생성', false),
              const SizedBox(width: 64), // 마이크 자리 확보
              _buildNavItem('assets/images/menuAnalysis.png', '분석', true),
              _buildNavItem('assets/images/menuMypage.png', '마이페이지', false),
            ],
          ),
        ),
        Positioned(
          top: -25,
          left: 0,
          right: 0,
          child: Center(child: _buildMicButton()),
        ),
      ],
    ),
  );
}


Widget _buildNavItem(String imagePath, String label, bool isSelected) {
  return GestureDetector(
    onTap: () {
      if (label == '광고 생성') {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => AdCreationPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      } else if (label == '분석') {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => RevenueAnalysisPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      } else if (label == '마이페이지') {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => MyPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: isSelected ? 1.0 : 0.55,
          child: Image.asset(
            imagePath,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? const Color(0xFF333333) : Colors.grey[600],
              letterSpacing: -0.8
          ),
        ),
      ],
    ),
  );
}

Widget _buildMicButton() {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AiChatPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.95),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 10, offset: const Offset(0, 6)),
            ],
          ),
        ),
        Container(
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
          foregroundDecoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Colors.black.withOpacity(0.01), Colors.transparent],
              stops: const [0.9, 1.0],
            ),
          ),
        ),
        Image.asset('assets/images/navMic.png', width: 30, height: 30, fit: BoxFit.contain),
      ],
    ),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
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
