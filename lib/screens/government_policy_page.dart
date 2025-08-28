import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_page.dart';
import 'ad_creation_page.dart';
import 'revenue_analysis_page.dart';
import 'mypage.dart';
import 'ai_chat_page.dart';
import 'package:mybiz_app/widgets/main_bottom_nav.dart';
import 'package:mybiz_app/widgets/main_header.dart';
import 'package:mybiz_app/widgets/main_page_layout.dart';
import 'package:url_launcher/url_launcher.dart';

class GovernmentPolicyPage extends StatefulWidget {
  const GovernmentPolicyPage({super.key});

  @override
  State<GovernmentPolicyPage> createState() => _GovernmentPolicyPageState();
}

class _GovernmentPolicyPageState extends State<GovernmentPolicyPage> {
  String _selectedRegion = '전체';
  String _searchQuery = '';
  final FocusNode _searchFocusNode = FocusNode();

  final List<String> _regions = ['전체', '서울', '경기', '인천', '부산', '광주', '대구', '대전', '이외'];

  // 정부정책 데이터
  final List<Map<String, dynamic>> _policies = [
    {
      'title': '소상공인 지원금 신청 안내',
      'description': '2025년 소상공인 지원금 신청이 시작되었습니다.',
      'date': '2025.01.15',
      'url': 'https://www.semas.or.kr',
      'category': '지원금',
      'region': '전체'
    },
    {
      'title': '창업 지원 프로그램',
      'description': '신규 창업자를 위한 종합 지원 프로그램을 운영합니다.',
      'date': '2025.01.10',
      'url': 'https://www.startup.go.kr',
      'category': '창업지원',
      'region': '전체'
    },
    {
      'title': '디지털 전환 지원',
      'description': '소상공인의 디지털 전환을 위한 기술 지원을 제공합니다.',
      'date': '2025.01.08',
      'url': 'https://www.digital.go.kr',
      'category': '기술지원',
      'region': '전체'
    },
    {
      'title': '세무 상담 서비스',
      'description': '무료 세무 상담 및 세무 신고 지원 서비스를 제공합니다.',
      'date': '2025.01.05',
      'url': 'https://www.nts.go.kr',
      'category': '세무지원',
      'region': '전체'
    },
    {
      'title': '서울시 소상공인 지원',
      'description': '서울시 소상공인을 위한 특별 지원 프로그램입니다.',
      'date': '2025.01.12',
      'url': 'https://www.seoul.go.kr',
      'category': '지역지원',
      'region': '서울'
    },
    {
      'title': '경기도 창업 멘토링',
      'description': '경기도 신규 창업자를 위한 전문 멘토링 서비스입니다.',
      'date': '2025.01.09',
      'url': 'https://www.gg.go.kr',
      'category': '창업지원',
      'region': '경기'
    },
  ];

  // 검색어와 지역에 따른 필터링된 정책 목록
  List<Map<String, dynamic>> get _filteredPolicies {
    return _policies.where((policy) {
      bool matchesRegion = _selectedRegion == '전체' || policy['region'] == _selectedRegion;
      bool matchesSearch = _searchQuery.isEmpty || 
          policy['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          policy['description'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          policy['category'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesRegion && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MainPageLayout(
      selectedIndex: 0,
      child: GestureDetector(
        onTap: () {
          // 다른 곳을 터치하면 검색 focus 해제
          _searchFocusNode.unfocus();
        },
        child: Column(
          children: [
            const MainHeader(title: '정부정책'),
            _buildRegionButtons(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildPolicyList(),
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

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  Widget _buildRegionButtons() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _regions.map((region) {
            bool isSelected = _selectedRegion == region;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRegion = region;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF00AEFF) : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected 
                      ? null
                      : Border.all(color: const Color(0xFFE5E5E5)),
                  ),
                  child: Text(
                    region,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF666666),
                      letterSpacing: -0.55,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3)
          )
        ],
      ),
      child: TextField(
        focusNode: _searchFocusNode,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: const TextStyle(
          fontSize: 16,
          letterSpacing: -0.55,
          color: Color(0xFF333333),
        ),
        decoration: const InputDecoration(
          hintText: '정책 검색',
          hintStyle: TextStyle(
            fontSize: 16,
            color: Color(0xFF999999),
            fontWeight: FontWeight.w400,
            letterSpacing: -0.8,
          ),
          suffixIcon: Icon(
            Icons.search_rounded,
            color: Color(0xFF999999),
            size: 24,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildPolicyList() {
    if (_filteredPolicies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                '검색 결과가 없습니다',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '다른 검색어나 지역을 선택해보세요',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  letterSpacing: -0.8,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '검색 결과 (${_filteredPolicies.length}건)',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 16),
        ..._filteredPolicies.map((policy) {
          return _buildPolicyCard(
            title: policy['title'] as String,
            description: policy['description'] as String,
            date: policy['date'] as String,
            url: policy['url'] as String,
            category: policy['category'] as String,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPolicyCard({
    required String title,
    required String description,
    required String date,
    required String url,
    required String category,
  }) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F8FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE1F0FF)),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00AEFF),
                        letterSpacing: -0.8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF999999),
                      letterSpacing: -0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF666666),
                  letterSpacing: -0.8,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: Color(0xFF00AEFF),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '자세히 보기',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00AEFF),
                      letterSpacing: -0.8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
      throw Exception('Could not launch $url');
    }
  }

} 