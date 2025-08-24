import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mypage.dart';
import 'signup_page.dart';
import 'store_search_popup.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  // 각 필드의 컨트롤러
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
    // 기존 사용자 데이터로 컨트롤러 초기화
    _nameController.text = UserData.name;
    _phoneController.text = UserData.phone;
    _birthDateController.text = UserData.birthDate;
    _emailController.text = UserData.email;
    _businessNameController.text = UserData.businessName;
    _businessNumberController.text = UserData.businessNumber;
    _businessTypeController.text = UserData.businessType;
    _addressController.text = UserData.address;
    _businessPhoneController.text = UserData.businessPhone;
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
      backgroundColor: const Color(0xFFF5F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 상태바 제거
                const SizedBox(height: 20),
                
                                 // 헤더 영역
                 Row(
                   children: [
                     GestureDetector(
                       onTap: () {
                         _showCancelDialog();
                       },
                       child: const Icon(
                         Icons.arrow_back_ios,
                         color: Color(0xFF333333),
                         size: 24,
                       ),
                     ),
                    const SizedBox(width: 16),
                    Text(
                      '정보 수정하기',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
                // 입력 필드들
                _buildInputField(
                  label: '이름',
                  controller: _nameController,
                  hint: '이름을 입력해주세요',
                ),
                const SizedBox(height: 20),
                
                _buildInputField(
                  label: '개인 전화번호',
                  controller: _phoneController,
                  hint: '01012345678',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                
                _buildInputField(
                  label: '생년월일',
                  controller: _birthDateController,
                  hint: '19990101',
                ),
                const SizedBox(height: 20),
                
                _buildInputField(
                  label: '이메일',
                  controller: _emailController,
                  hint: 'example@email.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                
                _buildBusinessNameField(),
                const SizedBox(height: 20),
                
                _buildInputField(
                  label: '사업자등록번호',
                  controller: _businessNumberController,
                  hint: '사업자등록번호를 입력하세요',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                
                _buildInputField(
                  label: '가게 전화번호',
                  controller: _businessPhoneController,
                  hint: '가게 전화번호를 입력해주세요',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                
                _buildBusinessTypeField(),
                const SizedBox(height: 20),
                
                _buildAddressField(),
                const SizedBox(height: 30),
                
                // 수정완료 버튼
                _buildSaveButton(),
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
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF999999),
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
            border: Border.all(
              color: const Color(0xFFE5E5E5),
              width: 1,
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
                color: const Color(0xFFB1B0B5),
              ),
            ),
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '상호명',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF999999),
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 8),
                 GestureDetector(
           onTap: _showStoreSearchPopup,
           child: Container(
             height: 58,
             width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0),
              border: Border.all(
                color: const Color(0xFFE5E5E5),
                width: 1,
              ),
            ),
                         child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _businessNameController.text.isEmpty 
                          ? '상호명을 입력해주세요'
                          : _businessNameController.text,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: _businessNameController.text.isEmpty 
                            ? const Color(0xFFB1B0B5)
                            : const Color(0xFF333333),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.search,
                    color: Color(0xFF999999),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '업종',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF999999),
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 58,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
            border: Border.all(
              color: const Color(0xFFE5E5E5),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              _businessTypeController.text.isEmpty 
                  ? '업종을 입력해주세요'
                  : _businessTypeController.text,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: _businessTypeController.text.isEmpty 
                    ? const Color(0xFFB1B0B5)
                    : const Color(0xFF333333),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '주소',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF999999),
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 58,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
            border: Border.all(
              color: const Color(0xFFE5E5E5),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              _addressController.text.isEmpty 
                  ? '주소를 입력해주세요'
                  : _addressController.text,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: _addressController.text.isEmpty 
                    ? const Color(0xFFB1B0B5)
                    : const Color(0xFF333333),
              ),
            ),
          ),
        ),
      ],
    );
  }

     Widget _buildSaveButton() {
     return GestureDetector(
              onTap: () {
          // 사용자 데이터 업데이트
          UserData.name = _nameController.text;
          UserData.phone = _phoneController.text;
          UserData.birthDate = _birthDateController.text;
          UserData.email = _emailController.text;
          UserData.businessName = _businessNameController.text;
          UserData.businessNumber = _businessNumberController.text;
          UserData.businessType = _businessTypeController.text;
          UserData.address = _addressController.text;
          UserData.businessPhone = _businessPhoneController.text;
          
                   // 수정 완료 메시지 표시
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '정보가 수정되었습니다.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xFF00AEFF),
              duration: Duration(seconds: 2),
            ),
          );
          
          // 마이페이지로 돌아가면서 새로고침
          Navigator.pop(context, true);
       },
       child: Container(
         width: double.infinity,
         height: 56,
         decoration: BoxDecoration(
           gradient: const LinearGradient(
             colors: [Color(0xFF00AEFF), Color(0xFF0088CC)],
             begin: Alignment.topLeft,
             end: Alignment.bottomRight,
           ),
           borderRadius: BorderRadius.circular(5),
         ),
         child: const Center(
           child: Text(
             '수정완료',
             style: TextStyle(
               color: Colors.white,
               fontSize: 18,
               fontWeight: FontWeight.w600,
             ),
           ),
         ),
       ),
     );
   }

  // 상호명 검색 팝업 표시
  void _showStoreSearchPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StoreSearchPopup(
          onStoreSelected: (String name, String address, String businessType, String businessNumber) {
            setState(() {
              _businessNameController.text = name;
              _addressController.text = address;
              _businessTypeController.text = businessType;
              // 사업자등록번호는 빈 문자열로 전달되므로 자동으로 입력되지 않음
            });
          },
        );
      },
    );
  }

   // 취소 확인 다이얼로그 표시
   void _showCancelDialog() {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return Dialog(
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(15),
           ),
           child: Container(
             width: 300,
             height: 160,
             padding: const EdgeInsets.all(20),
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 const SizedBox(height: 10),
                 Text(
                   '정보 수정을 취소하시겠습니까?',
                   style: GoogleFonts.inter(
                     fontSize: 18,
                     fontWeight: FontWeight.w700,
                     color: const Color(0xFF666666),
                   ),
                 ),
                 const SizedBox(height: 20),
                 Row(
                   children: [
                     Expanded(
                       child: GestureDetector(
                         onTap: () {
                           Navigator.of(context).pop(); // 다이얼로그 닫기
                         },
                         child: Container(
                           height: 43,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             border: Border.all(
                               color: const Color(0xFFE5E5E5),
                               width: 1,
                             ),
                             borderRadius: BorderRadius.circular(5),
                           ),
                           child: Center(
                             child: Text(
                               '취소',
                               style: GoogleFonts.inter(
                                 fontSize: 15,
                                 fontWeight: FontWeight.w700,
                                 color: const Color(0xFF00C2FD),
                               ),
                             ),
                           ),
                         ),
                       ),
                     ),
                     const SizedBox(width: 10),
                     Expanded(
                       child: GestureDetector(
                         onTap: () {
                           Navigator.of(context).pop(); // 다이얼로그 닫기
                           Navigator.pop(context); // 정보수정 페이지 닫기
                         },
                         child: Container(
                           height: 43,
                           decoration: BoxDecoration(
                             gradient: const LinearGradient(
                               colors: [Color(0xFF98E0F8), Color(0xFF9CCEFF)],
                               begin: Alignment.centerLeft,
                               end: Alignment.centerRight,
                             ),
                             borderRadius: BorderRadius.circular(5),
                           ),
                           child: Center(
                             child: Text(
                               '확인',
                               style: GoogleFonts.inter(
                                 fontSize: 15,
                                 fontWeight: FontWeight.w700,
                                 color: Colors.white,
                               ),
                             ),
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
                 const SizedBox(height: 20),
               ],
             ),
           ),
         );
       },
     );
   }
}
