import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybiz_app/widgets/common_styles.dart';
import 'main_page.dart';
import 'store_search_popup.dart';

class UserData {
  static String name = '';
  static String phone = '';
  static String birthDate = '';
  static String email = '';
  static String businessName = '';
  static String businessNumber = '';
  static String businessType = '';
  static String address = '';
  static String businessPhone = '';
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _nameError = false;
  bool _phoneError = false;
  bool _businessPhoneError = false;
  bool _businessNameError = false;
  bool _businessNumberError = false;
  bool _businessTypeError = false;
  bool _addressError = false;
  bool _showErrors = false;
  bool _termsError = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _businessPhoneController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessNumberController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      if (_showErrors && _nameController.text.isNotEmpty && _nameError) {
        setState(() => _nameError = false);
      }
    });
    _phoneController.addListener(() {
      if (_showErrors && _phoneController.text.isNotEmpty && _phoneError) {
        setState(() => _phoneError = false);
      }
    });
    _businessNameController.addListener(() {
      if (_showErrors && _businessNameController.text.isNotEmpty && _businessNameError) {
        setState(() => _businessNameError = false);
      }
    });
    _businessNumberController.addListener(() {
      if (_showErrors && _businessNumberController.text.isNotEmpty && _businessNumberError) {
        setState(() => _businessNumberError = false);
      }
    });
    _businessPhoneController.addListener(() {
      if (_showErrors && _businessPhoneController.text.isNotEmpty && _businessPhoneError) {
        setState(() => _businessPhoneError = false);
      }
    });
    _businessTypeController.addListener(() {
      if (_showErrors && _businessTypeController.text.isNotEmpty && _businessTypeError) {
        setState(() => _businessTypeError = false);
      }
    });
    _addressController.addListener(() {
      if (_showErrors && _addressController.text.isNotEmpty && _addressError) {
        setState(() => _addressError = false);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _businessPhoneController.dispose();
    _businessNameController.dispose();
    _businessNumberController.dispose();
    _businessTypeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => CommonStyles.brandGradient.createShader(bounds),
                    child: Text(
                      'MyBiz',
                      style: GoogleFonts.roboto(
                        fontSize: 52,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.55,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    'MyBiz 서비스 이용을 위한\n정보를 입력해주세요',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.8,
                      color: const Color(0xFFB1B0B5),
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                _buildInputField(
                  label: '이름',
                  controller: _nameController,
                  hint: '이름을 입력해주세요',
                  validator: (v) => null,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  label: '개인 전화번호',
                  controller: _phoneController,
                  hint: '01012345678',
                  keyboardType: TextInputType.phone,
                  validator: (v) => null,
                ),
                const SizedBox(height: 20),
                _buildBusinessNameField(),
                const SizedBox(height: 20),
                _buildBusinessNumberField(),
                const SizedBox(height: 20),
                _buildInputField(
                  label: '가게 전화번호',
                  controller: _businessPhoneController,
                  hint: '가게 전화번호를 입력해주세요',
                  keyboardType: TextInputType.phone,
                  validator: (v) => null,
                ),
                const SizedBox(height: 20),
                _buildBusinessTypeField(),
                const SizedBox(height: 20),
                _buildAddressField(),
                const SizedBox(height: 12),
                _buildTermsAgreement(),
                const SizedBox(height: 16),
                _buildStartButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    bool hasError = false;
    if (label == '이름') hasError = _showErrors && _nameError;
    else if (label == '개인 전화번호') hasError = _showErrors && _phoneError;
    else if (label == '상호명') hasError = _showErrors && _businessNameError;
    else if (label == '사업자등록번호') hasError = _showErrors && _businessNumberError;
    else if (label == '가게 전화번호') hasError = _showErrors && _businessPhoneError;
    else if (label == '업종') hasError = _showErrors && _businessTypeError;
    else if (label == '주소') hasError = _showErrors && _addressError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.8,
            color: hasError ? Colors.red : const Color(0xFF999999),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
            border: Border.all(
              color: hasError ? Colors.red : const Color(0xFFE5E5E5),
              width: hasError ? 2 : 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.8,
                color: const Color(0xFFB1B0B5),
              ),
            ),
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.8,
              color: const Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessNameField() {
    final hasError = _showErrors && _businessNameError;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '상호명',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.8,
            color: hasError ? Colors.red : const Color(0xFF999999),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showStoreSearchPopup,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
              border: Border.all(
                color: hasError ? Colors.red : const Color(0xFFE5E5E5),
                width: hasError ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _businessNameController.text.isEmpty
                        ? '상호명을 검색하여 가게 정보를 확인하세요'
                        : _businessNameController.text,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.8,
                      color: _businessNameController.text.isEmpty
                          ? const Color(0xFFB1B0B5)
                          : const Color(0xFF333333),
                    ),
                  ),
                ),
                Icon(Icons.search, color: Colors.grey[600], size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessNumberField() {
    final hasError = _showErrors && _businessNumberError;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '사업자등록번호',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.8,
            color: hasError ? Colors.red : const Color(0xFF999999),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
            border: Border.all(
              color: hasError ? Colors.red : const Color(0xFFE5E5E5),
              width: hasError ? 2 : 1,
            ),
          ),
          child: TextFormField(
            controller: _businessNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              hintText: '사업자등록번호를 입력하세요',
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.8,
                color: const Color(0xFFB1B0B5),
              ),
            ),
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.8,
              color: const Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessTypeField() {
    final hasError = _showErrors && _businessTypeError;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '업종',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.8,
            color: hasError ? Colors.red : const Color(0xFF999999),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
            border: Border.all(
              color: hasError ? Colors.red : const Color(0xFFE5E5E5),
              width: hasError ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            _businessTypeController.text.isEmpty
                ? '상호명 검색 후 자동 입력됩니다'
                : _businessTypeController.text,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.8,
              color: _businessTypeController.text.isEmpty
                  ? const Color(0xFFB1B0B5)
                  : const Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    final hasError = _showErrors && _addressError;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '주소',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.8,
            color: hasError ? Colors.red : const Color(0xFF999999),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
            border: Border.all(
              color: hasError ? Colors.red : const Color(0xFFE5E5E5),
              width: hasError ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            _addressController.text.isEmpty
                ? '상호명 검색 후 자동 입력됩니다'
                : _addressController.text,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.8,
              color: _addressController.text.isEmpty
                  ? const Color(0xFFB1B0B5)
                  : const Color(0xFF333333),
            ),
          ),
        ),
      ],
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
              value: _agreedToTerms,
              onChanged: (value) {
                setState(() {
                  _agreedToTerms = value ?? false;
                  if (_agreedToTerms) _termsError = false;
                });
              },
              visualDensity: const VisualDensity(horizontal: -2, vertical: -4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: const Color(0xFF00AEFF),
              side: _showErrors && _termsError
                  ? const BorderSide(color: Colors.red, width: 0)
                  : const BorderSide(color: Color(0xFF00AEFF), width: 0),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '이용약관 및 개인정보처리방침에 동의합니다.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.8,
                  color: _showErrors && _termsError ? Colors.red : const Color(0xFF333333).withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4), // 8 -> 4로 줄임
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
                      color: const Color(0xFF00AEFF),
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
                      color: const Color(0xFF00AEFF),
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



  Widget _buildStartButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showErrors = true;
          _nameError = _nameController.text.isEmpty;
          _phoneError = _phoneController.text.isEmpty;
          _businessNameError = _businessNameController.text.isEmpty;
          _businessNumberError = _businessNumberController.text.isEmpty;
          _businessPhoneError = _businessPhoneController.text.isEmpty;
          _businessTypeError = _businessTypeController.text.isEmpty;
          _addressError = _addressController.text.isEmpty;
          _termsError = !_agreedToTerms;
        });
        if (_nameError || _phoneError || _businessNameError || _businessNumberError || _businessPhoneError || _businessTypeError || _addressError || _termsError) {
          String errorMessage = '';
          if (_nameError || _phoneError || _businessNameError || _businessPhoneError || _businessTypeError || _addressError) {
            errorMessage = '입력되지 않은 정보가 있습니다.';
          } else if (!_agreedToTerms) {
            errorMessage = '이용약관에 동의해주세요.';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage, style: const TextStyle(color: Colors.white),),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
        UserData.name = _nameController.text;
        UserData.phone = _phoneController.text;
        UserData.businessName = _businessNameController.text;
        UserData.businessNumber = _businessNumberController.text;
        UserData.businessType = _businessTypeController.text;
        UserData.address = _addressController.text;
        UserData.businessPhone = _businessPhoneController.text;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage()));
      },
      child: Container(
        width: double.infinity,
        height: 56,
                        decoration: BoxDecoration(
                  gradient: CommonStyles.brandGradient,
                  borderRadius: BorderRadius.circular(CommonStyles.buttonRadius),
                ),
        child: Center(
          child: Text(
            'MyBiz 시작하기',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.55,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showStoreSearchPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StoreSearchPopup(
          onStoreSelected: (name, address, businessType, businessNumber) {
            setState(() {
              _businessNameController.text = name;
              _addressController.text = address;
              _businessTypeController.text = businessType;
              _businessNameError = false;
              _addressError = false;
              _businessTypeError = false;
            });
          },
        );
      },
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
                  color: const Color(0xFF00AEFF),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


}
