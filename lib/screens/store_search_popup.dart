import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybiz_app/widgets/common_styles.dart';

class StoreSearchPopup extends StatefulWidget {
  final Function(String, String, String, String) onStoreSelected;
  const StoreSearchPopup({super.key, required this.onStoreSelected});
  @override
  State<StoreSearchPopup> createState() => _StoreSearchPopupState();
}

class _StoreSearchPopupState extends State<StoreSearchPopup> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _searchResults = [];
  bool _isSearching = false;

  final List<Map<String, String>> _allStores = [
    {
      'name': '성화해장국 인하점',
      'address': '인천광역시 미추홀구 용현동 96-30 1층',
      'roadAddress': '인천광역시 미추홀구 인하로105번길 42 1층',
      'businessType': '한식 > 해장국',
      'postalCode': '22208',
    },
    {
      'name': '성화해장국 본점',
      'address': '인천광역시 미추홀구 용현동 627-432 1층',
      'roadAddress': '인천광역시 미추홀구 낙섬서로 7-3 1층',
      'businessType': '한식 > 해장국',
      'postalCode': '22190',
    },
    {
      'name': '성화해장국 청주점',
      'address': '충청북도 청주시 서원구 성화동 746 1층',
      'roadAddress': '충청북도 청주시 서원구 장전로6번가길 24 1층',
      'businessType': '한식 > 해장국',
      'postalCode': '28614',
    },
    {
      'name': '성화감자탕',
      'address': '충북 청주시 서원구 산남동 419',
      'roadAddress': '충북 청주시 서원구 원흥로80번길 31-9',
      'businessType': '한식 > 해장국',
      'postalCode': '28626',
    },
    {
      'name': '성화해장국',
      'address': '인천광역시 미추홀구 용현동 96-30 1층',
      'roadAddress': '인천광역시 미추홀구 인하로105번길 42 1층',
      'businessType': '한식 > 해장국',
      'postalCode': '22208',
    },
    {
      'name': '성화해장국 강남점',
      'address': '서울특별시 강남구 역삼동 123-45',
      'roadAddress': '서울특별시 강남구 테헤란로 123',
      'businessType': '한식 > 해장국',
      'postalCode': '12345',
    },
    {
      'name': '성화해장국 홍대점',
      'address': '서울특별시 마포구 동교동 456-78',
      'roadAddress': '서울특별시 마포구 홍대로 456',
      'businessType': '한식 > 해장국',
      'postalCode': '67890',
    },
    {
      'name': '성화해장국 부산점',
      'address': '부산광역시 해운대구 우동 789-12',
      'roadAddress': '부산광역시 해운대구 해운대로 789',
      'businessType': '한식 > 해장국',
      'postalCode': '11111',
    },
    {
      'name': '성화해장국 대구점',
      'address': '대구광역시 수성구 범어동 321-54',
      'roadAddress': '대구광역시 수성구 동대구로 321',
      'businessType': '한식 > 해장국',
      'postalCode': '22222',
    },
    {
      'name': '성화해장국 광주점',
      'address': '광주광역시 서구 치평동 654-87',
      'roadAddress': '광주광역시 서구 상무대로 654',
      'businessType': '한식 > 해장국',
      'postalCode': '33333',
    },
    {
      'name': '성화해장국 대전점',
      'address': '대전광역시 유성구 도안동 987-65',
      'roadAddress': '대전광역시 유성구 대학로 987',
      'businessType': '한식 > 해장국',
      'postalCode': '44444',
    },
    {
      'name': '성화해장국 울산점',
      'address': '울산광역시 남구 삼산동 147-25',
      'roadAddress': '울산광역시 남구 삼산로 147',
      'businessType': '한식 > 해장국',
      'postalCode': '55555',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }
    setState(() {
      _isSearching = true;
      _searchResults = _allStores.where((store) => store['name']!.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _selectStore(Map<String, String> store) {
    widget.onStoreSelected(store['name']!, store['address']!, store['businessType']!, '');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width * 0.95;
    return Dialog(
      backgroundColor: Colors.transparent,
              child: ClipRRect(
          borderRadius: BorderRadius.circular(CommonStyles.dialogRadius),
        child: Container(
          width: w,
          height: 500,
                      decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(CommonStyles.dialogRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), 
                blurRadius: 10, 
                offset: const Offset(0, 4)
              )
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(CommonStyles.dialogRadius), topRight: Radius.circular(CommonStyles.dialogRadius)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '상호명 검색',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.55,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.close, size: 24, color: Color(0xFF666666)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
                        border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3)
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: '상호명 검색',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.55,
                                  color: const Color(0xFF999999),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.55,
                                color: const Color(0xFF333333),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.search_rounded, size: 20, color: Color(0xFF999999)),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: _isSearching && _searchResults.isNotEmpty ? _buildSearchResults() : _buildInitialContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialContent() {
          return Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 48, color: Color(0xFFCCCCCC)),
            const SizedBox(height: 16),
            Text(
              '상호명을 검색하여 가게를 선택하세요',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.55,
                color: const Color(0xFF666666),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final bool hasInfo = _searchResults.length >= 10;
    return Column(
      children: [
                if (hasInfo)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(CommonStyles.chipRadius),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
            ),
            child: Text(
              '검색 결과가 많습니다. 체인점의 경우 지점명을 입력하시면 더 정확한 결과를 확인하실 수 있습니다.',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.55,
                color: const Color(0xFF666666),
                height: 1.4,
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(20, hasInfo ? 0 : 12, 20, 16),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final store = _searchResults[index];
              return _buildStoreItem(store);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStoreItem(Map<String, String> store) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
              child: InkWell(
          onTap: () => _selectStore(store),
          borderRadius: BorderRadius.circular(CommonStyles.cardRadius),
                              child: Padding(
              padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                store['name']!,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.55,
                  color: const Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, size: 16, color: Color(0xFF999999)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store['address']!,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.55,
                            color: const Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          store['roadAddress']!,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.55,
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.category, size: 16, color: Color(0xFF999999)),
                  const SizedBox(width: 8),
                  Text(
                    store['businessType']!,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.55,
                      color: const Color(0xFF666666),
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
}
