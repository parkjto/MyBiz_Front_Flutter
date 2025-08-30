import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybiz_app/widgets/common_styles.dart';
import 'package:mybiz_app/widgets/main_header.dart';
import 'main_page.dart';
import 'store_search_popup.dart';
import '../services/user_data_service.dart';

// UserData 클래스 정의
class UserData {
  static String name = '';
  static String phone = '';
  static String birthDate = '';
  static String email = '';
  static String businessPhone = '';
  static String businessName = '';
  static String businessNumber = '';
  static String businessType = '';
  static String address = '';

  static void initializeFromSocialLogin() {
    // 소셜 로그인에서 받은 기본 정보로 초기화
    // 실제로는 SharedPreferences나 다른 저장소에서 가져와야 함
  }

  static void initialize() {
    // 기존 사용자 정보로 초기화
  }

  static void initializeDefault() {
    name = '';
    phone = '';
    birthDate = '';
    email = '';
    businessPhone = '';
    businessName = '';
    businessNumber = '';
    businessType = '';
    address = '';
  }

  static void clear() {
    initializeDefault();
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _businessPhoneController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessNumberController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 저장된 사용자 데이터 불러오기
  Future<void> _loadUserData() async {
    try {
      final userData = await UserDataService.getUserData();
      if (userData != null) {
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _birthDateController.text = userData['birthDate'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _businessNameController.text = userData['businessName'] ?? '';
          _businessNumberController.text = userData['businessNumber'] ?? '';
          _businessTypeController.text = userData['businessType'] ?? '';
          _addressController.text = userData['address'] ?? '';
          _businessPhoneController.text = userData['businessPhone'] ?? '';
          
          // UserData 클래스에도 동기화
          UserData.name = userData['name'] ?? '';
          UserData.phone = userData['phone'] ?? '';
          UserData.birthDate = userData['birthDate'] ?? '';
          UserData.email = userData['email'] ?? '';
          UserData.businessName = userData['businessName'] ?? '';
          UserData.businessNumber = userData['businessNumber'] ?? '';
          UserData.businessType = userData['businessType'] ?? '';
          UserData.address = userData['address'] ?? '';
          UserData.businessPhone = userData['businessPhone'] ?? '';
        });
        print('✅ 사용자 데이터 로드 완료: ${userData['name']}');
      } else {
        print('⚠️ 저장된 사용자 데이터가 없습니다');
      }
    } catch (e) {
      print('❌ 사용자 데이터 로드 실패: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
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
      backgroundColor: const Color(0xFFF4F5FA),
      body: SafeArea(
        child: Column(
          children: [
            const MainHeader(title: '정보 수정하기'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildInputField(
                        label: '이름',
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이름을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: '전화번호',
                        controller: _phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '전화번호를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: '생년월일',
                        controller: _birthDateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '생년월일을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: '이메일',
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: '가게명',
                        controller: _businessNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '가게명을 입력해주세요';
                          }
                          return null;
                        },
                        onTap: _showStoreSearchPopup, // 상호명 검색 팝업 호출
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: '업종',
                        controller: _businessTypeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '업종을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: '사업자번호',
                        controller: _businessNumberController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '사업자번호를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: '주소',
                        controller: _addressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '주소를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: '가게 전화번호',
                        controller: _businessPhoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '가게 전화번호를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      _buildButtons(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF999999),
            letterSpacing: -0.55,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(CommonStyles.inputRadius),
            border: Border.all(
              color: const Color(0xFFE5E5E5),
              width: 1,
            ),
          ),
          child: onTap != null
            ? GestureDetector(
                onTap: onTap,
                child: TextFormField(
                  controller: controller,
                  validator: validator,
                  enabled: false, // 터치만 가능하도록
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                    letterSpacing: -0.55,
                  ),
                ),
              )
            : TextFormField(
                controller: controller,
                validator: validator,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF333333),
                  letterSpacing: -0.55,
                ),
              ),
        ),
      ],
    );
  }

  void _showStoreSearchPopup() {
    showDialog(
      context: context,
      builder: (context) => StoreSearchPopup(
        isSignupMode: false, // 일반 모드 (기본값)
        onStoreSelected: (name, address, businessType, placeId) {
          setState(() {
            _businessNameController.text = name;
            _addressController.text = address;
            _businessTypeController.text = businessType;
          });
        },
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _showCancelDialog(),
                    child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFE5E5E5),
              width: 1,
            ),
          ),
              child: const Center(
                child: Text(
                  '취소',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00C2FD),
                    letterSpacing: -0.55,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => _saveProfile(),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: CommonStyles.brandGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  '저장',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.55,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        // UserDataService를 사용하여 데이터 업데이트
        await UserDataService.saveUserData(
          name: _nameController.text,
          phone: _phoneController.text,
          birthDate: _birthDateController.text,
          email: _emailController.text,
          businessName: _businessNameController.text,
          businessNumber: _businessNumberController.text,
          businessType: _businessTypeController.text,
          address: _addressController.text,
          businessPhone: _businessPhoneController.text,
        );
        
        // UserData 클래스도 업데이트
        UserData.name = _nameController.text;
        UserData.phone = _phoneController.text;
        UserData.birthDate = _birthDateController.text;
        UserData.email = _emailController.text;
        UserData.businessName = _businessNameController.text;
        UserData.businessNumber = _businessNumberController.text;
        UserData.businessType = _businessTypeController.text;
        UserData.address = _addressController.text;
        UserData.businessPhone = _businessPhoneController.text;
        
        // 성공 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('프로필이 저장되었습니다. MyBiz를 시작합니다!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        
        // 메인 페이지로 이동
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            Navigator.pop(context, true); // true 반환하여 저장 완료 알림
          }
        });
      } catch (e) {
        print('❌ 프로필 저장 실패: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('프로필 저장에 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('수정 취소'),
        content: const Text('수정한 내용이 저장되지 않습니다. 정말 취소하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('계속 수정'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }
}
