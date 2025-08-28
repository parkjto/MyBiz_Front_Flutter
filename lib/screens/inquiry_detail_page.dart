import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybiz_app/widgets/main_header.dart';
import 'package:mybiz_app/widgets/main_page_layout.dart';

class InquiryDetailPage extends StatefulWidget {
  final String title;
  final String status;
  final bool isCompleted;
  final String content;
  final String answer;
  final String date;

  const InquiryDetailPage({
    super.key,
    required this.title,
    required this.status,
    required this.isCompleted,
    required this.content,
    required this.answer,
    required this.date,
  });

  @override
  State<InquiryDetailPage> createState() => _InquiryDetailPageState();
}

class _InquiryDetailPageState extends State<InquiryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return MainPageLayout(
      selectedIndex: 3,
      child: Column(
        children: [
          const MainHeader(title: '문의 상세'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInquirySection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInquirySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.55,
                    color: const Color(0xFF333333),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.isCompleted 
                    ? const Color(0xFF2D6EFF).withOpacity(0.1) 
                    : const Color(0xFFFF6B35).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.status,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.55,
                    color: widget.isCompleted 
                      ? const Color(0xFF2D6EFF) 
                      : const Color(0xFFFF6B35),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '문의 날짜: ${widget.date}',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.8,
              color: const Color(0xFF999999),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '문의 내용',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.8,
              color: const Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.content,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.8,
                color: const Color(0xFF666666),
              ),
            ),
          ),
          if (widget.isCompleted) ...[
            const SizedBox(height: 16),
            Text(
              '문의 답변',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.8,
                color: const Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.answer,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.8,
                  color: const Color(0xFF666666),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
} 