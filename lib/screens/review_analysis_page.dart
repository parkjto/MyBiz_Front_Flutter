import 'package:flutter/material.dart';
import 'main_page.dart';
import 'ad_creation_page.dart';
import 'revenue_analysis_page.dart';
import 'mypage.dart';
import 'ai_chat_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/image_upload_service.dart';
import 'capture_tutorial_page.dart';

class ReviewAnalysisPage extends StatefulWidget {
  const ReviewAnalysisPage({super.key});

  @override
  State<ReviewAnalysisPage> createState() => _ReviewAnalysisPageState();
}

class _ReviewAnalysisPageState extends State<ReviewAnalysisPage> {
  final ImageUploadService _uploadService = ImageUploadService();
  List<File> _selectedImages = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String? _uploadError;

  /// 분석 영역 노출 여부 (업로드 성공 후 true)
  bool _analysisReady = false;

  // 브랜드 그라데이션(버튼/포커스 컬러 통일)
  static const LinearGradient _brandGrad = LinearGradient(
    colors: [Color(0xFF00AEFF), Color(0xFF0084FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  void _showGuideImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  '리뷰 분석 가이드',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333), letterSpacing: -0.8),
                ),
                SizedBox(height: 16),
                Text(
                  '네이버 플레이스 리뷰 이미지를 업로드하면\nAI가 자동으로 분석해드립니다.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAnalysisTypeButtons(),
                    const SizedBox(height: 24),

                    /// 1) 업로드 섹션(맨 위)
                    _buildImageUploadSection(),

                    /// 2) 버튼 눌러 업로드 성공해야 분석 섹션 노출
                    if (_analysisReady) ...[
                      const SizedBox(height: 24),
                      _buildCustomerSatisfactionAnalysis(),
                      const SizedBox(height: 24),
                      _buildPositivePoints(),
                      const SizedBox(height: 24),
                      _buildNegativePoints(),
                      const SizedBox(height: 40),
                    ],
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

  // ========== APP BAR ==========
  Widget _buildAppBar() {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          const Center(
            child: Text(
              '분석',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
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
                width: 24,
                height: 24,
                child: Icon(Icons.arrow_back_ios, size: 16, color: Color(0xFF333333)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== 탭(매출/리뷰) – 라운드 15px 고정 ==========
  Widget _buildAnalysisTypeButtons() {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const RevenueAnalysisPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: const Center(
                  child: Text(
                    '매출 분석',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, letterSpacing: -0.8, color: Color(0xFF6B6A6F)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              decoration: BoxDecoration(gradient: _brandGrad, borderRadius: BorderRadius.circular(15)),
              child: const Center(
                child: Text(
                  '리뷰 분석',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.8, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== 고객 만족도(스택 막대) ==========
  Widget _buildCustomerSatisfactionAnalysis() {
    final int pos = 75;
    final int neu = 15;
    final int neg = 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '고객 만족도 분석',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.8, color: Color(0xFF333333)),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: const Color(0xFFF3F6F9),
                    child: Row(
                      children: [
                        Expanded(flex: pos, child: Container(color: const Color(0xFFC2E1FF))),
                        Expanded(flex: neu, child: Container(color: const Color(0xFFFFCB9B))),
                        Expanded(flex: neg, child: Container(color: const Color(0xFFFFBCB7))),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _legend('긍정 (${pos}%)', const Color(0xFFC2E1FF)),
                  _legend('보통 (${neu}%)', const Color(0xFFFFCB9B)),
                  _legend('부정 (${neg}%)', const Color(0xFFFFBCB7)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _legend(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600], letterSpacing: -0.2)),
      ],
    );
  }

  // ========== 이런 점이 좋아요! ==========
  Widget _buildPositivePoints() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFFEFEFE), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '이런 점이 좋아요!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.8, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 20),
          _buildPointItem('친절한 서비스', 92,
              slotColor: const Color(0xFFF2F6FF), fillColor: const Color(0xFFE1EBFF), textColor: const Color(0xFF1E2A44)),
          const SizedBox(height: 8),
          _buildPointItem('신선한 재료', 81,
              slotColor: const Color(0xFFF2F6FF), fillColor: const Color(0xFFE1EBFF), textColor: const Color(0xFF1E2A44)),
          const SizedBox(height: 8),
          _buildPointItem('넓고 쾌적한 공간', 87,
              slotColor: const Color(0xFFF2F6FF), fillColor: const Color(0xFFE1EBFF), textColor: const Color(0xFF1E2A44)),
        ],
      ),
    );
  }

  // ========== 이런 점이 아쉬워요! ==========
  Widget _buildNegativePoints() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '이런 점이 아쉬워요!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.8, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 20),
          _buildPointItem('부족한 주차공간', 23),
          const SizedBox(height: 8),
          _buildPointItem('적은 음식양', 19),
          const SizedBox(height: 8),
          _buildPointItem('긴 대기시간', 12),
        ],
      ),
    );
  }

  // 퍼센트 바(단색, 슬롯보다 살짝 어두움)
  Widget _buildPointItem(
    String label,
    int percentage, {
    Color slotColor = const Color(0xFFF5F6F8),
    Color fillColor = const Color(0xFFE7EAF0),
    Color textColor = const Color(0xFF30323A),
  }) {
    final double w = (percentage.clamp(0, 100)) / 100.0;

    return SizedBox(
      height: 40,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(decoration: BoxDecoration(color: slotColor, borderRadius: BorderRadius.circular(10))),
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: w,
            child: Container(decoration: BoxDecoration(color: fillColor, borderRadius: BorderRadius.circular(10))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$label ($percentage%)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: textColor, letterSpacing: -0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== 이미지 업로드 섹션 ==========
  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '리뷰 분석에 사용할 이미지를 선택하세요',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.8, color: Color(0xFF333333)),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _showGuideImage,
              child: Image.asset('assets/images/exclamation.png', width: 16, height: 16, fit: BoxFit.contain),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 이미지 미리보기
        if (_selectedImages.isNotEmpty) ...[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
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
                            border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
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

                // 업로드 버튼
                if (_selectedImages.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _PrimaryGradientButton(
                      label: _isUploading ? '업로드 중... ${(_uploadProgress * 100).toInt()}%' : '리뷰 분석 시작',
                      onTap: _isUploading ? null : _uploadImages,
                      busy: _isUploading,
                      gradient: _brandGrad,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ] else
          // 이미지 선택 가이드 박스
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(gradient: _brandGrad, borderRadius: BorderRadius.circular(30)),
                    child: const Icon(Icons.add_photo_alternate, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 12),
                  Text('이미지를 선택하세요',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700], letterSpacing: -0.4)),
                  const SizedBox(height: 4),
                  Text('최대 5장까지 선택 가능', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                ],
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
                Expanded(child: Text(_uploadError!, style: TextStyle(fontSize: 14, color: Colors.red[600]))),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ========== 이미지 선택/업로드 로직 ==========
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

        List<File> validImages = [];
        for (final image in images) {
          final file = File(image.path);
          if (!_uploadService.isValidImageFormat(file.path)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('지원하지 않는 이미지 형식입니다. (JPG, PNG, WEBP만 지원)'), backgroundColor: Colors.red),
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
          _analysisReady = false; // 새로 선택하면 다시 분석 필요
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
      _analysisReady = false; // 변경 시 분석 초기화
    });
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('업로드할 이미지를 선택해주세요.'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _uploadError = null;
    });

    try {
      await _uploadService.uploadImagesWithProgress(
        _selectedImages,
        (progress) => setState(() => _uploadProgress = progress),
      );

      setState(() {
        _isUploading = false;
        _uploadProgress = 1.0;
        _analysisReady = true; // ✅ 이제 분석 섹션 보이기
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('리뷰 분석이 완료되었습니다!'), backgroundColor: Color(0xFF4CAF50)),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
        _uploadError = e.toString();
        _analysisReady = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('업로드 실패: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // ========== Bottom Nav ==========
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
                _buildNavItem('assets/images/menuAD.png', '광고 생성', false),
                const SizedBox(width: 64),
                _buildNavItem('assets/images/menuAnalysis.png', '분석', true),
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
              fontWeight: isSelected ? FontWeight.w300 : FontWeight.w600,
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

// ================== 공용: 그라데이션 버튼 ==================
class _PrimaryGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool busy;
  final Gradient gradient;

  const _PrimaryGradientButton({
    required this.label,
    required this.onTap,
    this.busy = false,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = onTap == null;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: disabled ? null : onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: disabled
              ? const LinearGradient(colors: [Color(0xFFBFDFF5), Color(0xFFAECBED)])
              : gradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: busy
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '업로드 중...',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.8, // ✅ 추가
                    ),
                  ),
                ],
              )
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8, // ✅ 추가
                ),
              ),
      ),
    );
  }

}
