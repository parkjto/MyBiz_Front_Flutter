import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybiz_app/widgets/main_header.dart';
import 'revenue_analysis_page.dart';
import 'scraping_page.dart';
import 'package:mybiz_app/services/chatbot_service.dart';
import 'ad_creation_page.dart';
import 'package:mybiz_app/services/sales_service.dart';
import 'package:dio/dio.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final ChatbotService _chatbot = ChatbotService();
  final SalesService _sales = SalesService();

  bool _hasText = false;
  bool _isAiTyping = false;

  // 녹음(말하는 중)
  bool _isRecording = false;
  Timer? _recTimer;
  int _recTick = 0;

  // 파장 애니메이션
  late final AnimationController _waveCtrl;
  double _wavePhase = 0;

  // 사이즈(인풋/버튼 동일 높이)
  static const double _inputHeight = 52;
  static const double _actionSize = _inputHeight;

  // --------- 컬러/타이포 ---------
  static const _c333 = Color(0xFF333333);
  static const _c999 = Color(0xFF999999);
  static const _cLine = Color(0xFFE5E5E5);
  static const _bgChip = Color(0x0D000000);
  static const _brandBlue = Color(0xFF2D6EFF);

  // removed unused _title18
  static const TextStyle _aiName14 =
      TextStyle(fontSize: 14, letterSpacing: -0.55, color: _c999);
  static const TextStyle _aiText16 =
      TextStyle(fontSize: 16, letterSpacing: -0.55, color: Colors.white, height: 1.35);
  static const TextStyle _userText16 =
      TextStyle(fontSize: 16, letterSpacing: -0.55, color: Color(0xFF505050), height: 1.35);
  static const TextStyle _hint16 =
      TextStyle(color: _c999, fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: -0.55);
  static const TextStyle _chip14 =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: _c999, letterSpacing: -0.55);

  @override
  void initState() {
    super.initState();

    _messages.add(ChatMessage(
      text: "안녕하세요.\nAI비서 MyBiz입니다. 무엇을 도와드릴까요?",
      isUser: false,
      timestamp: DateTime.now(),
    ));

    _messageController.addListener(() {
      setState(() => _hasText = _messageController.text.trim().isNotEmpty);
    });

    _waveCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..addListener(() => setState(() => _wavePhase = _waveCtrl.value));

    // 포커스 변화: 스크롤 보정 + 녹음 중이면 종료
    _focusNode.addListener(() {
      _scrollToBottom();
      if (_focusNode.hasFocus && _isRecording) _toggleRecording();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _waveCtrl.dispose();
    _recTimer?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    final txt = _messageController.text.trim();
    if (txt.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: txt, isUser: true, timestamp: DateTime.now()));
      _isAiTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    // 의도 분기: 특정 화면 이동/즉시 응답 처리
    if (_isAdCreationQuery(txt)) {
      setState(() => _isAiTyping = false);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AdCreationPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
      return;
    }

    if (_isBestsellerQuery(txt)) {
      _answerBestsellerTop3();
      return;
    }

    // 의도 분기: 매출/리뷰 관련 질문일 경우 해당 화면으로 이동
    if (_isRevenueQuery(txt)) {
      final month = _extractMonth(txt);
      setState(() => _isAiTyping = false);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => RevenueAnalysisPage(
            initialYear: DateTime.now().year,
            initialMonth: month,
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
      return;
    }

    if (_isReviewQuery(txt)) {
      setState(() => _isAiTyping = false);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const ScrapingPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
      return;
    }

    // 백엔드 챗봇 호출 (개선 방안 등 일반 대화 응답 포함)
    _handleChatbotReply(txt);
  }

  Future<void> _handleChatbotReply(String userText) async {
    try {
      final res = await _chatbot.sendMessage(text: userText);
      final success = res['success'] == true;
      if (!success) throw Exception(res['message'] ?? '요청 실패');

      final data = Map<String, dynamic>.from(res['data'] ?? {});
      final type = data['type'] as String?; // 'navigation' | 'response' | 'error'
      final screen = data['screen'] as String?; // 'sales' | 'review' | ...
      final message = data['message']?.toString() ?? '';

      if (!mounted) return;

      if (type == 'navigation' && (screen == 'sales' || screen == 'review')) {
        // 화면 이동 전 안내 메시지 한 줄 출력
        setState(() {
          _messages.add(ChatMessage(text: message.isNotEmpty ? message : '화면으로 이동합니다.', isUser: false, timestamp: DateTime.now()));
          _isAiTyping = false;
        });
        _scrollToBottom();

        await Future.delayed(const Duration(milliseconds: 250));
        if (screen == 'sales') {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => const RevenueAnalysisPage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        } else if (screen == 'review') {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => const ScrapingPage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
        return;
      }

      // 일반 응답 (개선 방안 포함)
      setState(() {
        _messages.add(ChatMessage(text: message.isNotEmpty ? message : '답변을 불러오지 못했습니다.', isUser: false, timestamp: DateTime.now()));
        _isAiTyping = false;
      });
      _scrollToBottom();
    } on DioException catch (e) {
      String errMsg = '요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
      try {
        final data = e.response?.data;
        if (data is Map && data['message'] is String) {
          errMsg = data['message'] as String;
        } else if (e.message != null) {
          errMsg = e.message!;
        }
      } catch (_) {}
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: errMsg, isUser: false, timestamp: DateTime.now()));
        _isAiTyping = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: '요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.', isUser: false, timestamp: DateTime.now()));
        _isAiTyping = false;
      });
      _scrollToBottom();
    }
  }

  bool _isRevenueQuery(String q) {
    final t = q.toLowerCase();
    // 개선안(올리/증가/개선/방법/추천) 요청은 매출 화면 이동에서 제외하고 AI 응답으로 처리
    if (RegExp(r"(올리|증가|개선|방법|추천)").hasMatch(t)) {
      return false;
    }
    const patterns = [
      '매출', '매상', '매출액', '월 매출', '이번달 매출', '이번 달 매출', '지난달 매출', '지난 달 매출', '매출 알려줘', '매출알려줘'
    ];
    for (final p in patterns) {
      if (t.contains(p)) return true;
    }
    // 숫자+월+매출 패턴 간단 매칭
    final monthSales = RegExp(r"(\d{1,2})\s*월\s*매출");
    return monthSales.hasMatch(q);
  }

  bool _isReviewQuery(String q) {
    final t = q.toLowerCase();
    const patterns = [
      '리뷰', '후기', '평점', '리뷰 분석', '리뷰분석', '리뷰 알려줘', '리뷰알려줘', '리뷰 긍정', '리뷰 부정'
    ];
    for (final p in patterns) {
      if (t.contains(p)) return true;
    }
    return false;
  }

  bool _isAdCreationQuery(String q) {
    final t = q.toLowerCase();
    return t.contains('광고 생성') || t.contains('광고 만들어') || t.contains('포스터') || t.contains('홍보물');
  }

  bool _isBestsellerQuery(String q) {
    final t = q.toLowerCase();
    final hasBestWord = t.contains('베스트') || t.contains('베스트셀러') || t.contains('top 3') || t.contains('top3') || t.contains('탑3');
    final hasItemWord = t.contains('메뉴') || t.contains('상품') || t.contains('제품') || t.contains('품목') || t.contains('판매');
    return hasBestWord && hasItemWord;
  }

  Future<void> _answerBestsellerTop3() async {
    setState(() => _isAiTyping = true);
    try {
      final now = DateTime.now().toUtc();
      final start = DateTime.utc(now.year, now.month, 1, 0, 0, 0).toIso8601String();
      final end = DateTime.utc(now.year, now.month + 1, 0, 23, 59, 59).toIso8601String();
      final list = await _sales.getBestsellers(start: start, end: end, limit: 3);
      final items = List<Map<String, dynamic>>.from(list);
      final lines = <String>[];
      for (int i = 0; i < items.length; i++) {
        final e = items[i];
        final name = (e['productName'] ?? '-').toString();
        final total = (e['total'] ?? 0).toString();
        lines.add('${i + 1}. $name · ${_formatNumber(total)}원');
      }
      final msg = lines.isEmpty
          ? '해당 기간 베스트셀러 데이터를 찾지 못했습니다.'
          : '이번달 베스트 메뉴 TOP3\n' + lines.join('\n');
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: msg, isUser: false, timestamp: DateTime.now()));
        _isAiTyping = false;
      });
      _scrollToBottom();
    } on DioException catch (e) {
      String errMsg = '베스트셀러 조회 중 오류가 발생했습니다.';
      try {
        final data = e.response?.data;
        if (data is Map && data['message'] is String) {
          errMsg = data['message'] as String;
        } else if (e.message != null) {
          errMsg = e.message!;
        }
      } catch (_) {}
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: errMsg, isUser: false, timestamp: DateTime.now()));
        _isAiTyping = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: '베스트셀러 조회 중 오류가 발생했습니다.', isUser: false, timestamp: DateTime.now()));
        _isAiTyping = false;
      });
      _scrollToBottom();
    }
  }

  String _formatNumber(String n) {
    final numVal = int.tryParse(n) ?? 0;
    final s = numVal.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (m) => '${m[1]},');
  }

  int? _extractMonth(String q) {
    // "2월", "02월", "2 월" 등을 추출 (1~12)
    final m = RegExp(r"(1[0-2]|0?[1-9])\s*월");
    final match = m.firstMatch(q);
    if (match != null) {
      final val = int.tryParse(match.group(1)!.replaceAll(RegExp(r'^0'), ''));
      if (val != null && val >= 1 && val <= 12) return val;
    }
    return null;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  // ---- 녹음 토글 ----
  void _toggleRecording() {
    if (_isRecording) {
      _recTimer?.cancel();
      _waveCtrl.stop();
      setState(() => _isRecording = false);
      _scrollToBottom();
      return;
    }
    setState(() => _isRecording = true);
    _waveCtrl.repeat(); // 파장 시작
    _recTimer?.cancel();
    _recTimer = Timer.periodic(const Duration(milliseconds: 220), (_) {
      setState(() => _recTick++);
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final keyboardOpen = bottomInset > 0;

    // 하단 영역 높이(리스트 padding에도 사용)
    final double bottomRegionHeight =
        keyboardOpen ? (_inputHeight + 24) : (_isRecording ? 220 : (_inputHeight + 24));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const MainHeader(title: 'AI 채팅'),
                const Divider(height: 1, thickness: 1, color: _cLine),
                // 채팅 영역 + '입력 중…' 버블을 리스트 마지막에 붙이기
                Expanded(child: _buildChatAreaWithTyping(bottomRegionHeight)),
                // ====== 하단 ======
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  height: bottomRegionHeight,
                  padding: EdgeInsets.only(bottom: keyboardOpen ? 6 : 0),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // 움직이는 파장(녹음 중 + 키보드 닫힘일 때만)
                      if (!keyboardOpen && _isRecording)
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: CustomPaint(
                              size: const Size(double.infinity, 200),
                              painter: _WavePainter(
                                phase: _wavePhase,
                                opacity: 0.65,
                                colors: const [Color(0xFF9B8CFF), _brandBlue],
                              ),
                            ),
                          ),
                        ),
                      // "듣고 있어요" 알약 (탭하면 녹음 종료)
                      if (!keyboardOpen && _isRecording)
                        Positioned(
                          bottom: 128,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: _toggleRecording,
                              child: _listeningPill(),
                            ),
                          ),
                        ),
                      // AI 타이핑 중일 때 로딩 애니메이션
                      if (_isAiTyping)
                        Positioned(
                          bottom: 80,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
                                    'AI가 응답을 작성중입니다...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      
                      // 입력 영역
                      Positioned(left: 0, right: 0, bottom: 0, child: _buildInputArea()),
                    ],
                  ),
                ),
              ],
            ),
            // 마이크 버튼 제거 (AI 채팅에서는 불필요)
            // Positioned(
            //   bottom: bottomRegionHeight + 5,
            //   left: 0,
            //   right: 0,
            //   child: const MainMicFab(),
            // ),
          ],
        ),
      ),
    );
  }

  // (removed unused _buildAppBar)

  // ---- 채팅 영역(입력중 버블 포함) ----
  Widget _buildChatAreaWithTyping(double bottomRegionHeight) {
    final itemCount = _messages.length + (_isAiTyping ? 1 : 0);
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(20, 18, 20, 20 + bottomRegionHeight),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (_isAiTyping && index == itemCount - 1) {
          return _buildTypingBubble();
        }
        final m = _messages[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMessageBubble(m),
            if (!m.isUser && index == 0) _buildExampleChips(),
          ],
        );
      },
    );
  }

  Widget _buildExampleChips() {
    final qs = [
      "광고 생성 도와줘",
      "2월 매출 분석",
      "리뷰 분석 시작",
      "베스트 메뉴 TOP3 알려줘",
      "매출 올릴 방법 추천해줘",
    ];
    return Container(
      margin: const EdgeInsets.only(bottom: 12, top: 6),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: qs.map((q) => _chip(q)).toList(),
      ),
    );
  }

  Widget _chip(String text) {
    return GestureDetector(
      onTap: () {
        _messageController.text = text;
        _sendMessage();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: _bgChip, borderRadius: BorderRadius.circular(12)),
        child: Text(text, style: _chip14),
      ),
    );
  }

  // 리스트 안에 들어가는 '입력 중…' 버블
  Widget _buildTypingBubble() {
    final dots = '.' * (1 + (_recTick % 3));
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: _brandBlue, borderRadius: BorderRadius.circular(16)),
          child: Text('입력 중$dots', style: _aiText16),
        ),
      ),
    );
  }

  // ---- 메시지 버블 ----
  Widget _buildMessageBubble(ChatMessage m) {
    final isUser = m.isUser;
    final bubbleColor = isUser ? Colors.white : _brandBlue;

    final userShadow = [
      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Row(
              children: [
                Container(width: 8, height: 8,
                    decoration: BoxDecoration(color: _brandBlue, borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 8),
                const Text('MyBiz AI', style: _aiName14),
              ],
            ),
            const SizedBox(height: 8),
          ],
          GestureDetector(
            onLongPress: () async {
              await Clipboard.setData(ClipboardData(text: m.text));
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('메시지를 복사했습니다.', style: TextStyle(letterSpacing: -0.8))),
                );
              }
            },
            child: Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(20),
                  border: isUser ? Border.all(color: _cLine) : null,
                  boxShadow: isUser ? userShadow : null,
                ),
                child: Text(m.text, style: isUser ? _userText16 : _aiText16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- 입력창 (버튼 높이 같게) ----
  Widget _buildInputArea() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: _inputHeight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: _cLine),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3))],
                ),
                child: Center(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    minLines: 1,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 16, letterSpacing: -0.8, color: _c333),
                    decoration: const InputDecoration(
                      hintText: '무엇이 궁금하신가요?',
                      hintStyle: _hint16,
                      isDense: true,
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                if (_hasText) {
                  _sendMessage();
                } else {
                  _toggleRecording();
                }
              },
              borderRadius: BorderRadius.circular(_actionSize / 2),
              child: Container(
                width: _actionSize,
                height: _actionSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_actionSize / 2),
                  gradient: _hasText
                      ? const LinearGradient(
                          colors: [Color(0xFF6AA8FF), Color(0xFF2D6EFF)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight)
                      : null,
                  color: _hasText ? null : Colors.white,
                  border: _hasText ? null : Border.all(color: _cLine),
                  boxShadow: _hasText
                      ? [BoxShadow(color: const Color(0xFF2D6EFF).withOpacity(0.28), blurRadius: 10, offset: const Offset(0, 4))]
                      : [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))],
                ),
                child: Center(
                  child: _hasText
                      ? const Icon(Icons.send_rounded, size: 20, color: Colors.white)
                      : Icon(_isRecording ? Icons.stop_rounded : Icons.mic_none_rounded,
                          size: 24, color: _isRecording ? const Color(0xFFFF4D4F) : _c333),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== “듣고 있어요” 알약 버튼 =====
  Widget _listeningPill() {
    final scale = 1.0 + 0.03 * math.sin(_wavePhase * 2 * math.pi);
    return Transform.scale(
      scale: scale,
      child: Container(
        padding: const EdgeInsets.all(1.5), // 그라 테두리
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9B8CFF), Color(0xFFFFB3B3)],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: const Color(0xFF9B8CFF).withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
          child: const Text('듣고 있어요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.8, color: _c333)),
        ),
      ),
    );
  }
}

// ------ 모델 ------
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  ChatMessage({required this.text, required this.isUser, required this.timestamp});
}

/// 파장 Painter (강도 업: 3겹 웨이브 + 더 진한 헤이즈)
class _WavePainter extends CustomPainter {
  final double phase; // 0~1
  final List<Color> colors;
  final double opacity;

  _WavePainter({required this.phase, required this.colors, this.opacity = 0.6});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 아래 큰 그라디언트 헤이즈(더 진하게)
    final radial = RadialGradient(
      center: const Alignment(0, 1.15),
      radius: 1.35,
      colors: [
        colors.first.withOpacity(opacity * 0.35),
        colors.last.withOpacity(opacity * 0.5),
        Colors.transparent,
      ],
      stops: const [0.06, 0.72, 1.0],
    ).createShader(rect);

    final bgPaint = Paint()
      ..shader = radial
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28);
    final hazeRRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(-80, size.height * 0.20, size.width + 160, size.height),
      topLeft: const Radius.circular(260),
      topRight: const Radius.circular(260),
    );
    canvas.drawRRect(hazeRRect, bgPaint);

    // 파장 3겹 (진폭/속도 상향)
    void drawWave(double amp, double yBase, double speed, double shift,
        List<Color> cs, double blur) {
      final p = Path()..moveTo(0, yBase);
      for (double x = 0; x <= size.width; x += 2) {
        final t = (x / size.width * 2 * math.pi) + (phase * 2 * math.pi * speed) + shift;
        final y = yBase - math.sin(t) * amp;
        p.lineTo(x, y);
      }
      p.lineTo(size.width, size.height);
      p.lineTo(0, size.height);
      p.close();

      final grad = LinearGradient(
        colors: [cs.first.withOpacity(opacity), cs.last.withOpacity(opacity)],
        begin: Alignment.bottomLeft, end: Alignment.topRight,
      ).createShader(rect);

      final paint = Paint()
        ..shader = grad
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
      canvas.drawPath(p, paint);
    }

    drawWave(20, size.height * 0.52, 1.2, 0.0, colors, 12);
    drawWave(16, size.height * 0.60, 1.8, math.pi / 2, colors.reversed.toList(), 12);
    drawWave(10, size.height * 0.68, 2.4, math.pi / 1.2, colors, 10);
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) =>
      old.phase != phase || old.colors != colors || old.opacity != opacity;
}
