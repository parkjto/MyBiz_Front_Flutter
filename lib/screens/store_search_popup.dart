import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybiz_app/widgets/common_styles.dart';
import '../services/naver_api_service.dart';
import '../services/auth_storage_service.dart';

class StoreSearchPopup extends StatefulWidget {
  final Function(String, String, String, String) onStoreSelected;
  final bool isSignupMode; // 회원가입 모드 여부
  
  const StoreSearchPopup({
    super.key, 
    required this.onStoreSelected,
    this.isSignupMode = false, // 기본값은 false (일반 모드)
  });
  
  @override
  State<StoreSearchPopup> createState() => _StoreSearchPopupState();
}

class _StoreSearchPopupState extends State<StoreSearchPopup> {
  final TextEditingController _searchController = TextEditingController();
  final NaverApiService _naverApiService = NaverApiService();
  final AuthStorageService _authStorage = AuthStorageService();
  
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _initializePopup();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 팝업 초기화
  Future<void> _initializePopup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 회원가입 모드가 아닌 경우에만 로그인 상태 확인
      if (!widget.isSignupMode) {
        final isLoggedIn = await _authStorage.isLoggedIn();
        setState(() {
          _isLoggedIn = isLoggedIn;
        });

        // API 상태 확인
        if (isLoggedIn) {
          await _naverApiService.checkApiStatus();
        }
      } else {
        // 회원가입 모드: 로그인 체크 건너뛰기
        setState(() {
          _isLoggedIn = true; // 회원가입 모드에서는 검색 가능하도록
        });
        
        // API 상태만 확인 (인증 없이)
        await _naverApiService.checkApiStatus();
      }
    } catch (e) {
      print('❌ 팝업 초기화 실패: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // API 상태 확인
  Future<void> _checkApiStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final isAvailable = await _naverApiService.checkApiStatus();
      if (!isAvailable) {
        setState(() {
          _errorMessage = '네이버 API 서비스를 사용할 수 없습니다.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'API 연결을 확인할 수 없습니다.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 검색어 변경 시 호출
  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
        _errorMessage = '';
      });
      return;
    }

    // 디바운싱: 500ms 후에 검색 실행
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text.trim() == query) {
        _performSearch(query);
      }
    });
  }

  // 실제 검색 수행
  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      print('🔍 검색 시작: $query');
      
      List<Map<String, dynamic>> results;
      
      // 회원가입 모드인지에 따라 다른 검색 메서드 사용
      if (widget.isSignupMode) {
        print('📝 회원가입 모드: 인증 없이 검색');
        results = await _naverApiService.searchStoresForSignup(query);
      } else {
        print('🔐 일반 모드: 인증 토큰으로 검색');
        results = await _naverApiService.searchStores(query);
      }
      
      setState(() {
        _searchResults = results;
        _isSearching = true;
        _isLoading = false;
        
        if (results.isEmpty) {
          _errorMessage = '검색 결과가 없습니다. 다른 키워드로 검색해보세요.';
        }
      });
      
      print('✅ 검색 완료: ${results.length}개 결과');
    } catch (e) {
      print('❌ 검색 실패: $e');
      
      String userMessage = '검색 중 오류가 발생했습니다. 다시 시도해주세요.';
      
      // 인증 관련 오류 메시지 개선
      if (e.toString().contains('로그인이 필요합니다')) {
        userMessage = '로그인이 필요합니다. 먼저 소셜 로그인을 진행해주세요.';
      } else if (e.toString().contains('401')) {
        userMessage = '인증이 만료되었습니다. 다시 로그인해주세요.';
      } else if (e.toString().contains('토큰')) {
        userMessage = '로그인 세션이 만료되었습니다. 다시 로그인해주세요.';
      }
      
      setState(() {
        _errorMessage = userMessage;
        _isLoading = false;
      });
    }
  }

  // 매장 선택
  void _selectStore(Map<String, dynamic> store) {
    print('🏪 매장 선택: ${store['name']}');
    
    // 콜백으로 선택된 매장 정보 전달
    widget.onStoreSelected(
      store['name'] ?? '',           // 상호명
      store['address'] ?? '',        // 주소
      store['businessType'] ?? '',   // 업종
      store['place_id'] ?? '',       // Place ID (사업자등록번호 대신)
    );
    
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
                          if (_isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
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
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('검색 중...', style: TextStyle(color: Color(0xFF666666))),
          ],
        ),
      );
    }

    // 로그인되지 않은 경우
    if (!_isLoggedIn) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 48, color: Color(0xFF999999)),
              const SizedBox(height: 16),
              Text(
                '상호명 검색을 이용하려면\n로그인이 필요합니다.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.55,
                  color: const Color(0xFF666666),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // 로그인 페이지로 이동하거나 로그인 안내
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AEFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('로그인하기'),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Color(0xFF999999)),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
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

    if (_searchResults.isEmpty && !_isSearching) {
      return _buildInitialContent();
    }

    if (_searchResults.isNotEmpty) {
      return _buildSearchResults();
    }

    return _buildInitialContent();
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

  Widget _buildStoreItem(Map<String, dynamic> store) {
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
                store['name'] ?? '',
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
                        if (store['address']?.isNotEmpty == true)
                          Text(
                            store['address'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.55,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        if (store['roadAddress']?.isNotEmpty == true) ...[
                          if (store['address']?.isNotEmpty == true)
                            const SizedBox(height: 2),
                          Text(
                            store['roadAddress'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.55,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (store['businessType']?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.category, size: 16, color: Color(0xFF999999)),
                    const SizedBox(width: 8),
                    Text(
                      store['businessType'] ?? '',
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
            ],
          ),
        ),
      ),
    );
  }
}
