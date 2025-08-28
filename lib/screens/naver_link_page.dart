import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybiz_app/services/naver_link_service.dart';
import 'package:mybiz_app/widgets/main_header.dart';
import 'package:mybiz_app/widgets/main_page_layout.dart';
import 'package:mybiz_app/widgets/common_styles.dart';

class NaverLinkPage extends StatefulWidget {
    const NaverLinkPage({super.key});
    @override
    State<NaverLinkPage> createState() => _NaverLinkPageState();
}

class _NaverLinkPageState extends State<NaverLinkPage> {
    final _formKey = GlobalKey<FormState>();
    final _idController = TextEditingController();
    final _pwController = TextEditingController();
    bool _agree = false;
    bool _isLoading = false;
    bool _linked = false;
    String? _lastScrapeAt;
    final _service = NaverLinkService();

    // 상수 스타일 정의
    static const _titleStyle = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.55,
        color: Color(0xFF333333),
    );
    
    static const _subtitleStyle = TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.55,
        color: Color(0xFF777777),
    );

    @override
    void initState() {
        super.initState();
        _fetchStatus();
    }

    Future<void> _fetchStatus() async {
        setState(() { _isLoading = true; });
        try {
            final res = await _service.status();
            final linked = (res['linked'] == true);
            final last = res['lastScrapeAt'] as String?;
            setState(() {
                _linked = linked;
                _lastScrapeAt = last;
            });
        } catch (e) {
            _showSnackBar('상태 확인 실패');
        } finally {
            setState(() { _isLoading = false; });
        }
    }

    Future<void> _login() async {
        if (!_formKey.currentState!.validate()) return;
        setState(() { _isLoading = true; });
        try {
            final res = await _service.login(
                userId: _idController.text.trim(), 
                password: _pwController.text, 
                agreed: _agree
            );
            final ok = (res['success'] == true);
            if (ok) {
                _showSnackBar('로그인/연동 성공');
                await _fetchStatus();
            } else {
                _showSnackBar('로그인 실패');
            }
        } catch (e) {
            _showSnackBar('로그인 오류');
        } finally {
            setState(() { _isLoading = false; });
        }
    }

    Future<void> _unlink() async {
        setState(() { _isLoading = true; });
        try {
            await _service.unlink();
            _showSnackBar('연동 해제됨');
            await _fetchStatus();
        } catch (e) {
            _showSnackBar('연동 해제 실패');
        } finally {
            setState(() { _isLoading = false; });
        }
    }

    Future<void> _relink() async {
        setState(() { _isLoading = true; });
        try {
            await _service.relink();
            _showSnackBar('재연동 요청됨');
            await _fetchStatus();
        } catch (e) {
            _showSnackBar('재연동 실패');
        } finally {
            setState(() { _isLoading = false; });
        }
    }

    Future<void> _scrape() async {
        setState(() { _isLoading = true; });
        try {
            await _service.scrape();
            _showSnackBar('스크래핑 요청됨');
            await _fetchStatus();
        } catch (e) {
            _showSnackBar('스크래핑 실패');
        } finally {
            setState(() { _isLoading = false; });
        }
    }

    void _showSnackBar(String message) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message))
        );
    }

    // 개인정보처리방침 표시
    void _showPrivacyPolicy() {
        showDialog(
            context: context,
            builder: (context) => Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                    constraints: const BoxConstraints(
                        maxHeight: 500,
                        maxWidth: 400,
                        minWidth: 400,
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(
                                children: [
                                    const Text(
                                        '개인정보처리방침',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.8,
                                            color: Color(0xFF333333),
                                        ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: const Icon(Icons.close, color: Color(0xFF999999)),
                                    ),
                                ],
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                                child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            _buildPrivacyPolicyContent(),
                                        ],
                                    ),
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }

    // 이용약관 표시
    void _showTermsOfService() {
        showDialog(
            context: context,
            builder: (context) => Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                    constraints: const BoxConstraints(
                        maxHeight: 500,
                        maxWidth: 400,
                        minWidth: 400,
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(
                                children: [
                                    const Text(
                                        '이용약관',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.8,
                                            color: Color(0xFF333333),
                                        ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: const Icon(Icons.close, color: Color(0xFF999999)),
                                    ),
                                ],
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                                child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            _buildTermsOfServiceContent(),
                                        ],
                                    ),
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }

    // 개인정보처리방침 내용
    Widget _buildPrivacyPolicyContent() {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                _buildPolicySection(
                    '1. 개인정보의 수집 및 이용 목적',
                    '네이버 연동 서비스를 제공하기 위해 필요한 최소한의 개인정보를 수집합니다.',
                ),
                _buildPolicySection(
                    '2. 수집하는 개인정보 항목',
                    '• 네이버 아이디\n• 네이버 비밀번호\n• 가게 정보 (리뷰 분석용)',
                ),
                _buildPolicySection(
                    '3. 개인정보의 보유 및 이용기간',
                    '서비스 이용 종료 시까지 보관하며, 탈퇴 시 즉시 삭제됩니다.',
                ),
                _buildPolicySection(
                    '4. 개인정보의 제3자 제공',
                    '고객의 동의 없이 제3자에게 개인정보를 제공하지 않습니다.',
                ),
            ],
        );
    }

    // 이용약관 내용
    Widget _buildTermsOfServiceContent() {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                _buildPolicySection(
                    '1. 서비스 이용',
                    '네이버 연동 서비스는 MyBiz 앱 내에서만 이용 가능합니다.',
                ),
                _buildPolicySection(
                    '2. 이용자의 의무',
                    '• 정확한 정보 입력\n• 개인정보 보호\n• 서비스 이용 규정 준수',
                ),
                _buildPolicySection(
                    '3. 서비스 제한',
                    '부정한 목적으로 서비스를 이용할 경우 서비스 이용이 제한될 수 있습니다.',
                ),
                _buildPolicySection(
                    '4. 책임 제한',
                    '서비스 이용으로 인한 손해에 대해 MyBiz는 책임을 지지 않습니다.',
                ),
            ],
        );
    }

    // 약관 섹션 위젯
    Widget _buildPolicySection(String title, String content) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                            letterSpacing: -0.8,
                        ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        content,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            height: 1.4,
                            letterSpacing: -0.8,
                        ),
                    ),
                ],
            ),
        );
    }

    void _showTermsDetail(String type) {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
                return AlertDialog(
                    constraints: const BoxConstraints(
                        maxWidth: 400,
                        minWidth: 400,
                    ),
                    title: Text(
                        type,
                        style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.8,
                            color: const Color(0xFF333333),
                        ),
                    ),
                    content: SingleChildScrollView(
                        child: Text(
                            type == '이용약관' 
                                ? 'MyBiz 서비스 이용약관\n\n1. 서비스 이용\n- 본 서비스는 소상공인을 위한 AI 비즈니스 어시스턴트 서비스입니다.\n- 서비스 이용 시 본 약관에 동의한 것으로 간주됩니다.\n\n2. 서비스 내용\n- AI 광고 생성 및 분석\n- 매출 분석 및 리뷰 분석\n- 정부정책 정보 제공\n- 네이버 연동 서비스 (리뷰 분석용)\n\n3. 이용자의 의무\n- 정확한 정보 제공\n- 서비스 이용 규정 준수\n- 타인 정보 보호\n- 개인정보 수집 및 이용에 동의\n\n4. 서비스 변경 및 중단\n- 서비스 개선을 위한 변경 가능\n- 부득이한 경우 서비스 중단 가능\n\n5. 개인정보 수집 및 이용\n- 서비스 제공을 위해 필요한 최소한의 개인정보를 수집합니다\n- 수집된 정보는 서비스 제공 및 개선 목적으로만 사용됩니다\n- 고객의 동의 없이 제3자에게 제공하지 않습니다\n- 서비스 이용 종료 시까지 보관하며, 탈퇴 시 즉시 삭제됩니다'
                                : '개인정보처리방침\n\n1. 수집하는 개인정보\n- 이름, 전화번호, 이메일\n- 사업자등록번호, 상호명, 주소\n- 업종 및 가게 정보\n- 네이버 아이디 및 비밀번호 (연동 시)\n- 가게 정보 (리뷰 분석용)\n\n2. 개인정보 수집 목적\n- 서비스 제공 및 개선\n- 고객 지원 및 문의 응답\n- 법적 의무 이행\n- 네이버 연동 서비스 제공\n- 리뷰 분석 및 비즈니스 인사이트 제공\n\n3. 개인정보 보유 기간\n- 서비스 이용 기간 동안 보유\n- 탈퇴 시 즉시 삭제\n- 네이버 연동 해제 시 관련 정보 즉시 삭제\n\n4. 개인정보의 제3자 제공\n- 원칙적으로 제3자에게 제공하지 않음\n- 법적 의무가 있는 경우에만 제공\n- 네이버 연동 시에도 고객 동의 없이 제3자 제공 금지',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.8,
                                color: const Color(0xFF666666),
                                height: 1.5,
                            ),
                        ),
                    ),
                    actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                                '확인',
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.8,
                                    color: CommonStyles.primaryLightColor,
                                ),
                            ),
                        ),
                    ],
                );
            },
        );
    }

        @override
    Widget build(BuildContext context) {
        return MainPageLayout(
            selectedIndex: 3, // 마이페이지 탭
            child: Stack(
                children: [
                    Column(
                        children: [
                            MainHeader(
                                title: '네이버 연동',
                                onBack: () => Navigator.pop(context),
                            ),
                            Expanded(
                                child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            _buildStatus(),
                                            const SizedBox(height: 16),
                                            _buildForm(),
                                            const SizedBox(height: 16),
                                            _buildActions(),
                                            const SizedBox(height: 100), // 네비게이션 바 높이만큼 여백 추가
                                        ],
                                    ),
                                ),
                            ),
                        ],
                    ),
                    if (_isLoading) 
                        Positioned.fill(
                            child: Container(
                                color: Colors.black.withOpacity(0.05),
                                child: const Center(
                                    child: SizedBox(
                                        width: 36,
                                        height: 36,
                                        child: CircularProgressIndicator(strokeWidth: 3)
                                    )
                                )
                            )
                        ),
                ],
            ),
        );
    }



    Widget _buildStatus() {
        final statusText = '연동됨'; // 현재 상태를 연동된 것으로 고정
        final statusColor = CommonStyles.primaryLightColor; // 연동된 상태 색상
        final time = _lastScrapeAt == null ? '' : '마지막 스크래핑: $_lastScrapeAt';
        
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text('현재 상태', style: _titleStyle),
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: statusColor.withOpacity(0.3)),
                                ),
                                child: Text(
                                    statusText,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.8,
                                        color: statusColor,
                                    ),
                                ),
                            ),
                        ],
                    ),
                    if (time.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE8E8E8), width: 0.5),
                            ),
                            child: Row(
                                children: [
                                    Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                                    const SizedBox(width: 10),
                                    Text(time, style: _subtitleStyle),
                                ],
                            ),
                        ),
                    ],
                ]
            ),
        );
    }

    Widget _buildForm() {
        return Form(
            key: _formKey,
            child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                            '연동 정보',
                            style: _titleStyle,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                            controller: _idController,
                            decoration: InputDecoration(
                                labelText: '네이버 아이디',
                                labelStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.8,
                                    color: Color(0xFF666666),
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
                                    borderSide: BorderSide(color: CommonStyles.primaryLightColor, width: 2),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF8F9FA),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty) ? '아이디를 입력해주세요' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: _pwController,
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: '비밀번호',
                                labelStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.8,
                                    color: Color(0xFF666666),
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
                                    borderSide: BorderSide(color: CommonStyles.primaryLightColor, width: 2),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF8F9FA),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty) ? '비밀번호를 입력해주세요' : null,
                        ),
                        const SizedBox(height: 24),
                        _buildTermsAgreement(),
                        const SizedBox(height: 16),
                    ]
                ),
            ),
        );
    }

    Widget _buildTermsAgreement() {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Checkbox(
                            value: _agree,
                            onChanged: (value) {
                                setState(() {
                                    _agree = value ?? false;
                                });
                            },
                            visualDensity: const VisualDensity(horizontal: -2, vertical: -4),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            activeColor: CommonStyles.primaryLightColor,
                            side: BorderSide(color: CommonStyles.primaryLightColor, width: 0),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(
                                '이용약관 및 개인정보처리방침에 동의합니다.',
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.8,
                                    color: const Color(0xFF333333).withOpacity(0.6),
                                ),
                            ),
                        ),
                    ],
                ),
                const SizedBox(height: 2), // 4 -> 2로 줄임
                Row(
                    children: [
                        const SizedBox(width: 40), // Checkbox와 정렬 맞추기
                        Row(
                            children: [
                                GestureDetector(
                                    onTap: () => _showTermsDetail('개인정보처리방침'),
                                    child: Text(
                                        '개인정보처리방침',
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -0.8,
                                            color: CommonStyles.primaryLightColor,
                                            decoration: TextDecoration.underline,
                                        ),
                                    ),
                                ),
                                Text(
                                    ' 또는 ',
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: -0.8,
                                        color: const Color(0xFF666666),
                                    ),
                                ),
                                GestureDetector(
                                    onTap: () => _showTermsDetail('이용약관'),
                                    child: Text(
                                        '이용약관',
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -0.8,
                                            color: CommonStyles.primaryLightColor,
                                            decoration: TextDecoration.underline,
                                        ),
                                    ),
                                ),
                                Text(
                                    ' 자세히보기',
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: -0.8,
                                        color: const Color(0xFF666666),
                                    ),
                                ),
                            ],
                        ),
                    ],
                ),
            ],
        );
    }

    Widget _buildActions() {
        return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        '연동 관리',
                        style: _titleStyle,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Container(
                            decoration: BoxDecoration(
                                gradient: CommonStyles.brandGradient,
                                borderRadius: BorderRadius.circular(16),
                            ),
                            child: ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                ),
                                child: Text(
                                    '로그인/연동',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: -0.8,
                                    ),
                                ),
                            ),
                        ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                        children: [
                            Expanded(
                                child: SizedBox(
                                    height: 56,
                                    child: OutlinedButton(
                                        onPressed: _isLoading ? null : _unlink,
                                        style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                            ),
                                        ),
                                        child: const Text(
                                            '연동 해제',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF333333),
                                                letterSpacing: -0.8,
                                            ),
                                        ),
                                    ),
                                ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                                child: SizedBox(
                                    height: 56,
                                    child: OutlinedButton(
                                        onPressed: _isLoading ? null : _relink,
                                        style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                            ),
                                        ),
                                        child: const Text(
                                            '재연동',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF333333),
                                                letterSpacing: -0.8,
                                            ),
                                        ),
                                    ),
                                ),
                            ),
                        ]
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                            onPressed: _isLoading ? null : _scrape,
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                ),
                            ),
                            child: const Text(
                                '스크래핑 요청',
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
            ),
        );
    }
} 