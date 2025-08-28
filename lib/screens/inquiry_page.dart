import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_page.dart';
import 'ad_creation_page.dart';
import 'revenue_analysis_page.dart';
import 'review_analysis_page.dart';
import 'government_policy_page.dart';
import 'mypage.dart';
import 'ai_chat_page.dart';
import 'inquiry_detail_page.dart';
import 'package:mybiz_app/widgets/main_bottom_nav.dart';
import 'package:mybiz_app/widgets/main_header.dart';
import 'package:mybiz_app/widgets/main_page_layout.dart';
import 'package:mybiz_app/widgets/common_styles.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  bool _isInquiryHistory = true;
  String _selectedInquiryType = '선택';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  
  final List<String> _inquiryTypes = ['선택', '개인정보 문의', '이용 문의', '불만/불평사항 문의', '기타'];

  // 문의 내역 데이터
  final List<Map<String, dynamic>> _inquiries = [
    {
      'title': '업종 변경 문의',
      'status': '답변 대기',
      'isCompleted': false,
      'content': '현재 등록된 업종을 변경하고 싶습니다. 어떻게 해야 하나요?',
      'answer': '',
      'date': '2025.01.15',
    },
    {
      'title': '계정 삭제 문의',
      'status': '답변 완료',
      'isCompleted': true,
      'content': '계정을 완전히 삭제하고 싶습니다. 개인정보는 어떻게 처리되나요?',
      'answer': '계정 삭제 시 모든 개인정보는 즉시 삭제되며, 복구가 불가능합니다. 삭제 전 중요한 데이터를 백업해주세요.',
      'date': '2025.01.10',
    },
    {
      'title': '리뷰 분석 기능 문의',
      'status': '답변 완료',
      'isCompleted': true,
      'content': '리뷰 분석 기능이 제대로 작동하지 않습니다. 이미지를 업로드했는데 분석이 안 돼요.',
      'answer': '이미지 형식과 크기를 확인해주세요. JPG, PNG, WEBP 형식이며 최대 10MB까지 지원합니다. 문제가 지속되면 고객센터로 연락해주세요.',
      'date': '2025.01.08',
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MyPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        return false;
      },
      child: MainPageLayout(
        selectedIndex: 3,
        child: Column(
          children: [
            const MainHeader(title: '문의사항'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTabButtons(),
                    const SizedBox(height: CommonStyles.sectionGap),
                    _isInquiryHistory ? _buildInquiryHistory() : _buildInquiryForm(),
                    const SizedBox(height: 100), // 네비게이션 바 높이만큼 여백 추가
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButtons() {
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
              onTap: () => setState(() => _isInquiryHistory = true),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: _isInquiryHistory ? null : Colors.white,
                  gradient: _isInquiryHistory ? CommonStyles.brandGradient : null,
                  borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
                ),
                child: Center(
                  child: Text(
                    '문의내역',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.8,
                      color: _isInquiryHistory ? Colors.white : const Color(0xFF999999),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isInquiryHistory = false),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: !_isInquiryHistory ? null : Colors.white,
                  gradient: !_isInquiryHistory ? CommonStyles.brandGradient : null,
                  borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
                ),
                child: Center(
                  child: Text(
                    '문의하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.8,
                      color: !_isInquiryHistory ? Colors.white : const Color(0xFF999999),
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

  Widget _buildInquiryHistory() {
    return Container(
      padding: CommonStyles.sectionPadding,
      decoration: CommonStyles.sectionBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '문의내역',
            style: CommonStyles.titleStyle,
          ),
          const SizedBox(height: 12),
          ..._inquiries.asMap().entries.map((entry) {
            final index = entry.key;
            final inquiry = entry.value;
            final isLast = index == _inquiries.length - 1;
            return _buildInquiryItem(
              inquiry['title'],
              inquiry['status'],
              inquiry['isCompleted'],
              inquiry['content'],
              inquiry['answer'],
              inquiry['date'],
              showDivider: !isLast,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInquiryItem(String title, String status, bool isCompleted, String content, String answer, String date, {bool showDivider = false}) {
    final row = GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => InquiryDetailPage(
              title: title,
              status: status,
              isCompleted: isCompleted,
              content: content,
              answer: answer,
              date: date,
            ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF333333),
                  letterSpacing: -0.8,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCompleted ? const Color(0xFF2D6EFF).withOpacity(0.1) : const Color(0xFF848484).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isCompleted ? const Color(0xFF2D6EFF).withOpacity(0.3) : const Color(0xFF848484).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? const Color(0xFF2D6EFF) : const Color(0xFF848484),
                      letterSpacing: -0.8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (!showDivider) return row;
    return Column(children: [row, CommonStyles.divider()]);
  }

  Widget _buildInquiryForm() {
    return Container(
      padding: CommonStyles.sectionPadding,
      decoration: CommonStyles.sectionBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '문의하기',
            style: CommonStyles.titleStyle,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedInquiryType,
            decoration: InputDecoration(
              labelText: '문의 종류',
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF666666),
                letterSpacing: -0.8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF00C2FD)),
              ),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: _inquiryTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(
                  type,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: type == '선택' ? const Color(0xFF999999) : const Color(0xFF333333),
                    letterSpacing: -0.8,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedInquiryType = newValue!;
              });
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: '제목',
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF666666),
                letterSpacing: -0.8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
                borderSide: const BorderSide(color: Color(0xFF00C2FD)),
              ),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _contentController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: '내용',
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF666666),
                letterSpacing: -0.8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
                borderSide: const BorderSide(color: Color(0xFF00C2FD)),
              ),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Container(
              decoration: BoxDecoration(
                gradient: CommonStyles.brandGradient,
                borderRadius: BorderRadius.circular(CommonStyles.buttonRadius),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // 문의 제출 로직
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('문의가 제출되었습니다')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(CommonStyles.buttonRadius),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  '문의 제출',
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
        ],
      ),
    );
  }
}
