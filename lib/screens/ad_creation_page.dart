import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_upload_service.dart';
import 'ai_chat_page.dart';
import 'main_page.dart';
import 'mypage.dart';
import 'revenue_analysis_page.dart';

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
  static const LinearGradient _brandGrad = LinearGradient(
    colors: [Color(0xFF00AEFF), Color(0xFF0084FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  void dispose() {
    _requestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
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
                        letterSpacing: -0.8,
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
                  ],
                ),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  // ========== Header ==========
  Widget _buildHeader() {
    return SizedBox(
      height: 62,
      child: Stack(
        children: [
          const Center(
            child: Text(
              'AI 광고 생성',
              style: TextStyle(

                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.8,
                color: Color(0xFF333333),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const MainPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.arrow_back_ios, size: 16, color: Color(0xFF333333)),
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
                letterSpacing: -0.8,
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
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!, width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(gradient: _brandGrad, shape: BoxShape.circle),
                        child: const Icon(Icons.add_photo_alternate, color: Colors.white, size: 30),
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
              borderRadius: BorderRadius.circular(8),
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
              fontWeight: FontWeight.w300,
              letterSpacing: -0.8,
              color: Colors.grey[400],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
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
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00AEFF).withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
        borderRadius: BorderRadius.circular(16),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'AI 광고 생성 가이드',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.8,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: PageView(
                        onPageChanged: (i) => setState(() => currentPage = i),
                        children: const [
                          Center(child: Icon(Icons.image, size: 72, color: Colors.grey)),
                          Center(child: Icon(Icons.image, size: 72, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00AEFF).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${currentPage + 1}/2',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.8,
                        color: Color(0xFF00AEFF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '광고 이미지를 업로드하면 AI가 자동으로\n최적화된 광고를 생성해드립니다.\n\n최대 5장까지 선택 가능합니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -0.8,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00AEFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        '확인',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.8),
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

  // ========== Generate (mock) ==========
  void _generateAd() {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('이미지를 선택해주세요'), backgroundColor: Colors.orange));
      return;
    }
    if (_requestController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('광고 요청사항을 입력해주세요'), backgroundColor: Colors.orange));
      return;
    }

    setState(() => _isGenerating = true);
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('광고가 성공적으로 생성되었습니다!'), backgroundColor: Color(0xFF4CAF50)));
      _showGeneratedAdDialog();
    });
  }

  void _showGeneratedAdDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('광고 생성 완료!', style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.8)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF00AEFF).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image, size: 60, color: Color(0xFF00AEFF)),
              ),
              const SizedBox(height: 16),
              Text(
                '요청하신 광고가 성공적으로 생성되었습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.8,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인', style: TextStyle(color: Color(0xFF00AEFF), fontWeight: FontWeight.w600, letterSpacing: -0.8)),
            ),
          ],
        );
      },
    );
  }

  // ========== Bottom Navigation (간격/터치 영역 정돈) ==========
  Widget _buildBottomNavigation() {
    return SizedBox(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem('assets/images/menuHome.png', '홈', false),
                _buildNavItem('assets/images/menuAD.png', '광고 생성', true),
                const SizedBox(width: 64),
                _buildNavItem('assets/images/menuAnalysis.png', '분석', false),
                _buildNavItem('assets/images/menuMypage.png', '마이페이지', false),
              ],
            ),
          ),
          Positioned(top: -25, left: 0, right: 0, child: Center(child: _buildMicButton())),
        ],
      ),
    );
  }

  Widget _buildNavItem(String imagePath, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (label == '광고 생성') {
          Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => AdCreationPage(), transitionDuration: Duration.zero));
        } else if (label == '분석') {
          Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const RevenueAnalysisPage(), transitionDuration: Duration.zero));
        } else if (label == '마이페이지') {
          Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => MyPage(), transitionDuration: Duration.zero));
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: isSelected ? 1.0 : 0.55,
            child: Image.asset(imagePath, width: 24, height: 24, fit: BoxFit.contain),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w600,
              color: isSelected ? const Color(0xFF333333) : Colors.grey[600],
              letterSpacing: -0.8
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMicButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AiChatPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.95),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 10, offset: const Offset(0, 6))],
            ),
          ),
          Container(width: 64, height: 64, decoration: const BoxDecoration(shape: BoxShape.circle, 
            gradient: LinearGradient(
              colors: [Color(0xFF98E0F8), Color(0xFF9CCEFF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ))),
          Image.asset('assets/images/navMic.png', width: 30, height: 30, fit: BoxFit.contain),
        ],
      ),
    );
  }
}
