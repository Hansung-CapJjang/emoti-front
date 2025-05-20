import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart'; 




class TextChatScreen extends StatefulWidget {
  final String counselorType;

  const TextChatScreen({super.key, required this.counselorType});

  @override
  State<TextChatScreen> createState() => _TextChatScreenState();
}

class _TextChatScreenState extends State<TextChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isBotTyping = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialBotMessage();
  }

  void _showEndDialog(BuildContext context) {
  Future.delayed(Duration(milliseconds: 100), () {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '상담을 종료하시겠습니까?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DungGeunMo',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.black, width: 1.5),
                        ),
                      ),
                      child: const Text(
                        "아니오",
                        style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);        // 첫 번째 팝업 닫기
                        _showFinalStampDialog();             // 도장 결과 팝업 띄우기!
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF798063),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                    child: const Text(
                      "예",
                      style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
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
  });
}


  void _fetchInitialBotMessage() async {
    setState(() {
      _isBotTyping = true;
      _messages.add({'text': '작성 중...', 'isUser': false});
    });
    _scrollToBottom();

    try {
      final reply = await _fetchGPTResponse("상담을 시작해 주세요.");

      setState(() {
        _messages.removeWhere((m) => m['text'] == '작성 중...');
        _messages.add({'text': reply, 'isUser': false});
        _isBotTyping = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.removeWhere((m) => m['text'] == '작성 중...');
        _messages.add({'text': '⚠️ 오류 발생: $e', 'isUser': false});
        _isBotTyping = false;
      });
      _scrollToBottom();
    }
  }

  String _generateSystemPrompt(String counselorType, String name, String gender, String concern) {
    switch (counselorType) {
      case '공감형':
        return "$gender $name 님의 고민은 '$concern' 입니다. 상담사가 먼저 $name 님의 이름을 부르며 따뜻하고 공감적인 태도로 라포를 형성하고, 고민을 부드럽게 유도하는 말투로 시작하세요.";
      case '조언형':
        return "$gender $name 님의 고민은 '$concern' 입니다. 상담사가 먼저 $name 님의 이름을 부르며 솔직하고 직설적인 어투로 현실적인 조언을 시작하세요.";
      case '유머러스형':
        return "$gender $name 님의 고민은 '$concern' 입니다. 상담사가 먼저 $name 님의 이름을 부르며 유쾌하고 농담 섞인 말투로 고민을 편하게 유도하세요.";
      default:
        return "$gender $name 님의 고민은 '$concern' 입니다. 상담사가 친절하고 공감적인 태도로 대화를 시작하세요.";
    }
  }

  Future<String> _fetchGPTResponse(String userMessage) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userName = userProvider.nickname;
    final userGender = userProvider.gender;
    final userConcern = userProvider.concerns.isNotEmpty ? userProvider.concerns.first : "없음";

    final systemPrompt = _generateSystemPrompt(widget.counselorType, userName, userGender, userConcern);

    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        ..._messages.where((m) => m['text'] != '작성 중...').map((m) => {
          'role': m['isUser'] ? 'user' : 'assistant',
          'content': m['text'],
        }),
        {'role': 'user', 'content': userMessage},
      ],
    });

    final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decoded);

      final reply = data['choices'][0]['message']['content'];
      return reply.trim();
    } else {
      throw Exception('API 호출 실패: ${response.statusCode}');
    }
  }

  Future<String> _evaluateFinalStampWithGPT() async {
    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final analysisPrompt =
        '너는 심리 상담 대화 분석가야. 이 전체적인 대화의 맥락을 보고 사용자에게 줄 감정 도장을 결정해. "희망", "용기", "결단", "성찰", "회복" 중 하나만 정확히 답해. 다른 설명 없이 단어 하나로만 답해.';

    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': analysisPrompt},
        ..._messages.where((m) => m['text'] != '작성 중...').map((m) => {
          'role': m['isUser'] ? 'user' : 'assistant',
          'content': m['text'],
        }),
        {'role': 'user', 'content': '이 대화에서 사용자에게 부여할 감정 도장은 무엇입니까? "희망", "용기", "결단", "성찰", "회복" 중 하나로만 답해.'},
      ],
    });

    final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decoded);

      final reply = data['choices'][0]['message']['content'].trim();
      return reply;
    } else {
      throw Exception('API 호출 실패: ${response.statusCode}');
    }
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _isBotTyping = true;
      _messages.add({'text': '작성 중...', 'isUser': false});
      _controller.clear();
    });
    _scrollToBottom();

    try {
      final reply = await _fetchGPTResponse(text);

      setState(() {
        _messages.removeWhere((m) => m['text'] == '작성 중...');
        _messages.add({'text': reply, 'isUser': false});
        _isBotTyping = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.removeWhere((m) => m['text'] == '작성 중...');
        _messages.add({'text': '⚠️ 오류 발생: $e', 'isUser': false});
        _isBotTyping = false;
      });
      _scrollToBottom();
    }
  }

  void _showFinalStampDialog() async {
    try {
      final resultStamp = await _evaluateFinalStampWithGPT();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.updateStamp([...userProvider.stamp, resultStamp]);

  
    // JSON 저장 호출
    await userProvider.saveUserData();
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '🎉 상담이 종료되었습니다!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'DungGeunMo'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '이번 상담에서 받은 도장: [$resultStamp]',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF798063),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                    child: const Text("닫기", style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo')),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('도장 평가 실패: $e')),
      );
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

@override
Widget build(BuildContext context) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: const Color(0xFFE9EBD9),
      statusBarIconBrightness: Brightness.dark,
    ),
    child: Scaffold(
      backgroundColor: const Color(0xFFE9EBD9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE9EBD9),
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          '(${widget.counselorType}) 상담 중',
          style: const TextStyle(
            fontFamily: 'DungGeunMo',
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              physics: const BouncingScrollPhysics(),
              children: _messages
                  .map((m) => _buildMessageBubble(m['text'], m['isUser']))
                  .toList(),
            ),
          ),
          _buildInputBar(),
        ],
      ),
    ),
  );
}




  Widget _buildMessageBubble(String message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? const Color.fromARGB(255, 109, 131, 2) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isUser ? const Radius.circular(12) : const Radius.circular(0),
            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(12),
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 3),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                fontFamily: 'DungGeunMo',
                fontSize: 15,
                color: isUser ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _getCurrentTime(),
                style: const TextStyle(fontSize: 10, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black45),
                  ),
                  child: TextField(
                    style: const TextStyle(fontFamily: 'DungGeunMo'),
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '메시지를 입력하세요...',
                      hintStyle: TextStyle(fontFamily: 'DungGeunMo', color: Colors.black38),
                    ),
                    onChanged: (text) => setState(() {}),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: _controller.text.trim().isEmpty ? Colors.grey : const Color(0xFF6C7448),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Transform.rotate(
                    angle: -0.7854,
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                  onPressed: _controller.text.trim().isEmpty ? null : () => _sendMessage(_controller.text),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Visibility(
          visible: !isKeyboardVisible,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () => _showEndDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C7448),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                '상담 끝내기',
                style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}