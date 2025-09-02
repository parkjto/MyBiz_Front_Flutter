import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_upload_service.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
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

  File? _selectedImage;
  bool _isGenerating = false;
  String? _uploadError;
  double? _selectedImageAspect;

  // 광고 생성 결과 상태
  Map<String, dynamic>? _generatedAdResult;
  bool _hasGeneratedAd = false;
  double? _generatedAspect;
  Uint8List? _generatedImageBytes;

  // 단계별 진행 상태
  String _currentStep = '';
  int _currentStepNumber = 0;
  final List<String> _steps = [
    '이미지 분석 중...',
    '텍스트 최적화 중...',
    '광고 디자인 생성 중...',
    '광고 생성 완료!'
  ];

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

        // 생성된 광고가 있는 경우: 결과 렌더링
        if (_hasGeneratedAd && _generatedAdResult != null) ...[
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
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 500, minHeight: 200),
                          child: _generatedAdResult!['poster_url'] != null
                              ? (_generatedAspect != null
                                  ? AspectRatio(
                                      aspectRatio: _generatedAspect!,
                                      child: _buildGeneratedAdImage(_generatedAdResult!['poster_url']),
                                    )
                                  : _buildGeneratedAdImage(_generatedAdResult!['poster_url']))
                              : Container(color: Colors.grey[100]),
                        ),
                      ),
                    ),
                    if (_getPurposeRecommendationText().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.recommend, color: Color(0xFF00AEFF), size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                _getPurposeRecommendationText(),
                                style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _createNewAd,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFE5E5E5)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('새 광고 만들기'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _downloadGeneratedAd,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00AEFF),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: const Text('다운로드', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ] else if (_selectedImage != null) ...[
          // 단일 선택 이미지 미리보기 + 변경/삭제 버튼
          LayoutBuilder(
            builder: (context, cons) => SizedBox(
              width: cons.maxWidth,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 400, minHeight: 180),
                          child: _selectedImageAspect != null
                              ? AspectRatio(
                                  aspectRatio: _selectedImageAspect!,
                                  child: Image.file(_selectedImage!, fit: BoxFit.contain),
                                )
                              : Image.file(_selectedImage!, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _pickImage,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFE5E5E5)),
                                foregroundColor: const Color(0xFF00AEFF),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('이미지 변경'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _removeSelectedImage,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFE5E5E5)),
                                foregroundColor: const Color(0xFF00AEFF),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('이미지 삭제'),
                            ),
                          ),
                        ],
                      ),
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
                onTap: _pickImage,
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
                        '이미지 1장만 선택 가능',
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
                '매장명 / 메뉴 / 슬로건 형식으로 입력하세요.\n예) MyBiz / Ice Americano / 감각적이고 편안한 공간',
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.8,
              color: Color(0xFF999999),
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
    // 단계 기반 로딩 UI
    final total = _steps.length;
    final current = _currentStepNumber.clamp(0, total);
    final progress = total == 0 ? null : (current / total);

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
          LinearProgressIndicator(
            backgroundColor: const Color(0xFFE0E0E0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00AEFF)),
            value: progress,
          ),
          const SizedBox(height: 12),
          if (_currentStep.isNotEmpty)
            Text(
              _currentStep,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.8,
                color: Colors.grey[600],
              ),
            )
          else
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
  Future<void> _pickImage() async {
    try {
      final hasPermission = await _uploadService.requestGalleryPermission();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('갤러리 접근 권한이 필요합니다.'), backgroundColor: Colors.orange),
        );
        return;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final file = File(image.path);
      if (!_uploadService.isValidImageFormat(file.path)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('지원하지 않는 이미지 형식입니다. (JPG, PNG, WEBP만 지원)'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (!_uploadService.isValidImageSize(file)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지 크기가 너무 큽니다. (최대 10MB)'), backgroundColor: Colors.red),
        );
        return;
      }

      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final w = frame.image.width.toDouble();
      final h = frame.image.height.toDouble();
      setState(() {
        _selectedImage = file;
        _selectedImageAspect = w / (h == 0 ? 1 : h);
        _uploadError = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _removeSelectedImage() {
    setState(() {
      _selectedImage = null;
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
                  const Text(
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
                            description: '광고에 사용할 이미지를\n1장 선택하세요',
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
                        const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Color(0xFF00AEFF),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '사용 팁',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.8,
                                color: Color(0xFF00AEFF),
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
            style: const TextStyle(
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

  // 사용자가 입력한 요청 텍스트를 간단 규칙으로 구조화
  Map<String, dynamic> _parseRequestToInputs(String text) {
    final result = {
      'brand_name': '',
      'main_product': '',
      'slogan': '',
      'event_info': '',
      'contact_info': '',
    };

    if (text.isEmpty) return result;

    // 1차: 엄격한 슬래시 포맷 "브랜드 / 메뉴 / 슬로건"
    final slashParts = text
        .split('/')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (slashParts.isNotEmpty) result['brand_name'] = slashParts[0];
    if (slashParts.length >= 2) result['main_product'] = slashParts[1];
    if (slashParts.length >= 3) result['slogan'] = slashParts[2];

    // 2차: 슬래시가 없을 때를 위한 라벨 기반(하위호환)
    if ((result['main_product'] as String).isEmpty || (result['slogan'] as String).isEmpty) {
      final parts = text.split('/').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      for (final p in parts.skip(1)) {
        final lower = p.toLowerCase();
        if ((result['main_product'] as String).isEmpty && (lower.startsWith('대표 메뉴') || lower.startsWith('메뉴') || lower.contains('menu'))) {
          final idx = p.indexOf(':');
          final value = idx >= 0 ? p.substring(idx + 1).trim() : p;
          result['main_product'] = value.split(',').first.trim();
          continue;
        }
        if ((result['slogan'] as String).isEmpty && (lower.startsWith('슬로건') || lower.contains('slogan'))) {
          final idx = p.indexOf(':');
          result['slogan'] = (idx >= 0 ? p.substring(idx + 1) : p).trim();
          continue;
        }
      }
    }
    return result;
  }

  // ========== Generate (real API) ==========
  Future<void> _generateAd() async {
    if (_selectedImage == null) {
      _showSnackBar('이미지를 선택해주세요', Colors.orange);
      return;
    }
    if (_requestController.text.trim().isEmpty) {
      _showSnackBar('매장명과 주요 메뉴를 포함해 요청사항을 입력해주세요', Colors.orange);
      return;
    }

    try {
      setState(() {
        _isGenerating = true;
        _currentStepNumber = 1;
        _currentStep = _steps[0]; // 이미지 분석 중...
      });

      final dio = ApiClient().dio;

      // 1) 이미지 업로드 + 분석 호출
      final analyzeForm = FormData.fromMap({
        'image': await MultipartFile.fromFile(_selectedImage!.path, filename: 'ad_image.jpg'),
      });
      final analyzeResp = await dio.post(
        '/api/posters/analyze-and-generate-posters',
        data: analyzeForm,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      final analyzeData = analyzeResp.data;
      if (analyzeData is! Map || analyzeData['image_analysis'] == null) {
        throw Exception('이미지 분석 응답이 올바르지 않습니다');
      }
      final imageAnalysis = Map<String, dynamic>.from(analyzeData['image_analysis'] as Map);

      setState(() {
        _currentStepNumber = 2;
        _currentStep = _steps[1]; // 텍스트 최적화 중...
      });

      // 2) 업로드 이미지 위 합성 생성 호출 (요구사항 준수)
      final userInputs = _parseRequestToInputs(_requestController.text.trim());
      final composeForm = FormData.fromMap({
        'style': 'sns',
        'image': await MultipartFile.fromFile(_selectedImage!.path, filename: 'ad_image.jpg'),
        'user_inputs': jsonEncode(userInputs),
        'image_analysis': jsonEncode(imageAnalysis),
      });

      final composeResp = await dio.post(
        '/api/posters/generate-single-composite',
        data: composeForm,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      final genData = composeResp.data;
      if (genData is! Map || genData['after_b64'] == null) {
        throw Exception('합성 포스터 생성 응답이 올바르지 않습니다');
      }
      final b64 = genData['after_b64'] as String;
      final bytes = base64Decode(b64);
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final w = frame.image.width.toDouble();
      final h = frame.image.height.toDouble();
      final posterUrl = 'data:image/webp;base64,$b64';

      setState(() {
        _currentStepNumber = 3;
        _currentStep = _steps[2]; // 광고 디자인 생성 중...
      });

      setState(() {
        _generatedAdResult = {
          'poster_url': posterUrl,
          'style': 'sns',
        };
        _hasGeneratedAd = true;
        _isGenerating = false;
        _currentStepNumber = 4;
        _currentStep = _steps[3]; // 광고 생성 완료!
        _generatedAspect = (w > 0 && h > 0) ? (w / h) : _generatedAspect;
        _generatedImageBytes = bytes;
      });

      _showSnackBar('AI 광고가 성공적으로 생성되었습니다!', const Color(0xFF4CAF50));
    } on DioException catch (e) {
      final msg = e.response?.data is Map && (e.response!.data['message'] is String)
          ? e.response!.data['message']
          : e.message ?? '네트워크 오류가 발생했습니다';
      _showSnackBar('생성 실패: $msg', Colors.red);
      setState(() {
        _isGenerating = false;
      });
    } catch (e) {
      _showSnackBar('생성 실패: $e', Colors.red);
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  // 생성 결과 이미지 렌더링 (Base64/네트워크 모두 지원)
  Widget _buildGeneratedAdImage(String urlOrData) {
    if (urlOrData.startsWith('data:image')) {
      final bytes = _generatedImageBytes ?? base64Decode(urlOrData.split(',').last);
      return Image.memory(bytes, fit: BoxFit.contain, gaplessPlayback: true, filterQuality: FilterQuality.high);
    }
    return Image.network(urlOrData, fit: BoxFit.contain, gaplessPlayback: true, filterQuality: FilterQuality.high);
  }

  // 다운로드: 네트워크는 URL 오픈, Base64는 임시 파일로 저장
  Future<void> _downloadGeneratedAd() async {
    final posterUrl = _generatedAdResult?['poster_url'];
    if (posterUrl == null || posterUrl is! String || posterUrl.isEmpty) {
      _showSnackBar('다운로드할 광고가 없습니다.', Colors.orange);
      return;
    }
    try {
      if (posterUrl.startsWith('data:image')) {
        await _saveBase64ToGallery(posterUrl);
        _showSnackBar('갤러리에 저장됩니다!', const Color(0xFF4CAF50));
      } else {
        final uri = Uri.parse(posterUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          _showSnackBar('URL을 열 수 없습니다.', Colors.red);
        }
      }
    } catch (e) {
      _showSnackBar('다운로드 실패: $e', Colors.red);
    }
  }

  Future<void> _saveBase64ToGallery(String dataUrl) async {
    final base64Part = dataUrl.split(',').last;
    final bytes = base64Decode(base64Part);
    await Gal.putImageBytes(bytes);
  }

  // (측정은 생성 직후 1회 수행, 빌드 중 setState 방지)

  // 추천 목적 텍스트 안전 접근
  String _getPurposeRecommendationText() {
    final result = _generatedAdResult;
    if (result == null) return '';
    final rec = result['purpose_recommendation'];
    if (rec is Map && rec['recommended_purpose'] is String) {
      final p = rec['recommended_purpose'] as String;
      return 'AI 추천 목적: $p';
    }
    return '';
  }

  void _createNewAd() {
    setState(() {
      _hasGeneratedAd = false;
      _generatedAdResult = null;
      _selectedImage = null;
      _requestController.clear();
      _currentStepNumber = 0;
      _currentStep = '';
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
                const Text(
                  '요청하신 광고가 성공적으로 생성되었습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.8,
                    color: Color(0xFF666666),
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
