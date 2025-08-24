import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF00AEFF), Color(0xFF0084FF)],
                        ).createShader(bounds),
                        child: Text(
                          'MyBiz',
                          style: GoogleFonts.roboto(
                            fontSize: 52,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'MyBiz 서비스 이용을 위한 정보를 입력해주세요',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.8,
                          color: const Color(0xFFB1B0B5),
                        ),
                      ),
                    ],
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
                _buildBusinessNumberField(),
                const SizedBox(height: 20),
                _buildBusinessNameField(),
                const SizedBox(height: 20),
                _buildInputField(
                  label: '가게 전화번호',
                  controller: _businessPhoneController,
                  hint: ' ',
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
              borderRadius: BorderRadius.circular(5),
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
            borderRadius: BorderRadius.circular(5),
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
            borderRadius: BorderRadius.circular(5),
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
            borderRadius: BorderRadius.circular(5),
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
            borderRadius: BorderRadius.circular(5),
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

  Widget _buildTermsAgreement() {
    return Row(
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
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: const Color(0xFF00AEFF),
          side: _showErrors && _termsError
              ? const BorderSide(color: Colors.red, width: 0)
              : const BorderSide(color: Color(0xFF00AEFF), width: 0),
        ),
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
          gradient: const LinearGradient(
            colors: [Color(0xFF00AEFF), Color(0xFF0084FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            'MyBiz 시작하기',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.8,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
