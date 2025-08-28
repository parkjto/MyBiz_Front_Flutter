import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_upload_service.dart';
import 'ai_chat_page.dart';
import 'main_page.dart';
import 'mypage.dart';
import 'revenue_analysis_page.dart';
import 'package:mybiz_app/widgets/main_bottom_nav.dart';
import 'package:mybiz_app/widgets/main_header.dart';
import 'package:mybiz_app/widgets/main_page_layout.dart';
import 'package:mybiz_app/widgets/common_styles.dart';

class AdCreationPage extends StatefulWidget {
  const AdCreationPage({super.key});

  @override
  State<AdCreationPage> createState() => _AdCreationPageState();
}

class _AdCreationPageState extends State<AdCreationPage> {
  final _requestController = TextEditingController();
  final ImageUploadService _uploadService = ImageUploadService();

  List<File> _selectedImages = [];
  bool _isGenerating = false;
  String? _uploadError;

  // 브랜드 그라데이션
  static const LinearGradient _brandGrad = CommonStyles.brandGradient;

  @override
  void dispose() {
    _requestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainPageLayout(
      selectedIndex: 1,
      child: Column(
        children: [
          const MainHeader(title: '광고 생성'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    '이미지와 요청사항을 입력하면 AI가 맞춤형 광고를 생성합니다',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -0.55,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildImageUploadSection(),
                  const SizedBox(height: 24),
                  _buildRequestSection(),
                  const SizedBox(height: 32),
                  _buildGenerateButton(),
                  const SizedBox(height: 24),
                  if (_isGenerating) _buildLoadingSection(),
                  const SizedBox(height: 100), // 네비게이션 바 높이만큼 여백 추가
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== Image upload section ==========
  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '광고에 사용할 이미지를 선택하세요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.55,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _showGuideImage,
              child: Image.asset('assets/images/exclamation.png', width: 16, height: 16, fit: BoxFit.contain),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 이미지가 있는 경우
        if (_selectedImages.isNotEmpty) ...[
          LayoutBuilder(
            builder: (context, cons) => SizedBox(
              width: cons.maxWidth, // ✅ 100% 보장
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemCount: _selectedImages.length + (_selectedImages.length < 5 ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _selectedImages.length) {
                          return GestureDetector(
                            onTap: _pickImages,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: const Icon(Icons.add_photo_alternate, color: Colors.grey, size: 24),
                            ),
                          );
                        }
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedImages[index],
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ] else
          // 이미지가 없는 경우: 선택 안내 박스
          LayoutBuilder(
            builder: (context, cons) => SizedBox(
              width: cons.maxWidth, // ✅ 100% 보장
              child: GestureDetector(
                onTap: _pickImages,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Icon(Icons.add_photo_alternate, color: Colors.grey[600], size: 30),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '이미지를 선택하세요',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.8,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '최대 5장까지 선택 가능',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -0.8,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        if (_uploadError != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _uploadError!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -0.8,
                      color: Colors.red[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ========== Request section ==========
  Widget _buildRequestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '광고 요청사항',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.8,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _requestController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText:
                '예: 신메뉴 출시를 알리는 밝고 활기찬 분위기의 광고를 만들어주세요. 젊은 층을 타겟으로 하고, 제품의 맛을 강조해주세요.',
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.8,
              color: const Color(0xFF999999),
              height: 1.4,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFF00AEFF)),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '구체적으로 요청할수록 더 정확한 광고가 생성됩니다!',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            letterSpacing: -0.8,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  // ========== Generate button ==========
Widget _buildGenerateButton() {
  return SizedBox(
    height: 56, // ✅ L 사이즈
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          gradient: _brandGrad,
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: _isGenerating ? null : _generateAd,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isGenerating)
                  const SizedBox(
                    width: 20,
                    height: 20, // ✅ L 사이즈로
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 20), // ✅
                const SizedBox(width: 8),
                const Text(
                  'AI로 광고 생성하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.8,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


  // ========== Loading preview ==========
  Widget _buildLoadingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '광고 생성 중...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.8,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(
            backgroundColor: Color(0xFFE0E0E0),
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00AEFF)),
          ),
          const SizedBox(height: 12),
          Text(
            'AI가 요청사항을 분석하여 최적의 광고를 생성하고 있습니다',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.8,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ========== Pick / remove ==========
  Future<void> _pickImages() async {
    try {
      final hasPermission = await _uploadService.requestGalleryPermission();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('갤러리 접근 권한이 필요합니다.'), backgroundColor: Colors.orange),
        );
        return;
      }

      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        if (_selectedImages.length + images.length > 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('최대 5장까지 선택 가능합니다.'), backgroundColor: Colors.orange),
          );
          return;
        }

        final List<File> validImages = [];
        for (final image in images) {
          final file = File(image.path);
          if (!_uploadService.isValidImageFormat(file.path)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('지원하지 않는 이미지 형식입니다. (JPG, PNG, WEBP만 지원)'),
                backgroundColor: Colors.red,
              ),
            );
            continue;
          }
          if (!_uploadService.isValidImageSize(file)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('이미지 크기가 너무 큽니다. (최대 10MB)'), backgroundColor: Colors.red),
            );
            continue;
          }
          validImages.add(file);
        }

        setState(() {
          _selectedImages.addAll(validImages);
          _uploadError = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  // ========== Guide dialog ==========
  void _showGuideImage() {
    int currentPage = 0;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 헤더
                  Text(
                    'AI 광고 생성 가이드',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.8,
                      color: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 가이드 이미지 영역
                  Container(
                    width: double.infinity,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: PageView(
                        onPageChanged: (i) => setState(() => currentPage = i),
                        children: [
                          _buildGuidePage(
                            icon: Icons.upload_file,
                            title: '이미지 업로드',
                            description: '광고에 사용할 이미지를\n최대 5장까지 선택하세요',
                            color: Colors.grey[600]!,
                          ),
                          _buildGuidePage(
                            icon: Icons.auto_awesome,
                            title: 'AI 생성',
                            description: 'AI가 이미지를 분석하여\n최적화된 광고를 생성합니다',
                            color: Colors.grey[600]!,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 페이지 인디케이터
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentPage == index 
                            ? const Color(0xFF00AEFF)
                            : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 설명 텍스트
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: const Color(0xFF00AEFF),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '사용 팁',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.8,
                                color: const Color(0xFF00AEFF),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '• 고품질 이미지를 사용하면 더 좋은 결과를 얻을 수 있습니다\n• 명확한 요청사항을 입력하면 AI가 더 정확하게 생성합니다\n• 생성된 광고는 언제든지 수정할 수 있습니다',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            letterSpacing: -0.8,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 확인 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: _brandGrad,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(12),
                          child: const Center(
                            child: Text(
                              '가이드 확인',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // 가이드 페이지 위젯
  Widget _buildGuidePage({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: color,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.8,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.8,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ========== Generate (mock) ==========
  void _generateAd() {
    if (_selectedImages.isEmpty) {
      _showCustomSnackBar('이미지를 선택해주세요', Colors.orange);
      return;
    }
    if (_requestController.text.trim().isEmpty) {
      _showCustomSnackBar('광고 요청사항을 입력해주세요', Colors.orange);
      return;
    }

    setState(() => _isGenerating = true);
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => _isGenerating = false);
      _showCustomSnackBar('광고가 성공적으로 생성되었습니다!', const Color(0xFF4CAF50));
      _showGeneratedAdDialog();
    });
  }

  void _showCustomSnackBar(String message, Color backgroundColor) {
    // MainPageLayout을 사용할 때는 ScaffoldMessenger 대신 다른 방법 사용
    // 여기서는 간단히 setState로 상태를 변경하여 UI에 표시
    setState(() {
      // 임시로 상태를 변경하여 사용자에게 알림
    });
  }

  void _showGeneratedAdDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                const Text(
                  '광고 생성 완료!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '요청하신 광고가 성공적으로 생성되었습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.8,
                    color: const Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 48,
                      color: Color(0xFF999999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF666666),
                          side: const BorderSide(color: Color(0xFFE5E5E5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: const Text(
                          '닫기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 다운로드 기능 구현
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00AEFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: const Text(
                          '다운로드',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
