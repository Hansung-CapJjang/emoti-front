import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math'; // Random을 사용하기 위한 import


class TextChatScreen extends StatefulWidget {
  final String counselorType;

  const TextChatScreen({super.key, required this.counselorType});

  @override
  State<TextChatScreen> createState() => _TextChatScreenState();
}

class _TextChatScreenState extends State<TextChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final List<Map<String, dynamic>> _presetMessagesQueue = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _currentPresetIndex = 0;
  bool _isWaitingForUser = false;

  @override
  void initState() {
    super.initState();
    _loadPresetMessages();
  }

  Future<void> _loadPresetMessages() async {
  final String jsonString = await rootBundle.loadString('assets/data.json');
  final List<dynamic> jsonData = json.decode(jsonString);

  final matches = jsonData.where((item) => item['counselorType'] == widget.counselorType).toList();

  if (matches.isNotEmpty) {
    final randomMatch = matches[Random().nextInt(matches.length)];
    final List<dynamic> msgs = randomMatch['messages'];

    setState(() {
      _presetMessagesQueue.addAll(msgs.map((e) => {
        'text': e['text'],
        'isUser': e['isUser'],
      }));
    });

    // 🟢 첫 메시지 출력 시작
    if (_presetMessagesQueue.isNotEmpty) {
      _playNextBotMessage();
    }
  }
}



  void _sendMessage(String text) {
    if (text.trim().isEmpty || !_isWaitingForUser) return;

    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _controller.clear();
      _isWaitingForUser = false;
      _currentPresetIndex++;
    });

    _scrollToBottom();
    _playNextBotMessage();
  }

  void _playNextBotMessage() async {
    if (_currentPresetIndex >= _presetMessagesQueue.length) return;

    final current = _presetMessagesQueue[_currentPresetIndex];
    final isUser = current['isUser'];

    if (isUser) {
      _isWaitingForUser = true;
    } else {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _messages.add(current);
        _currentPresetIndex++;
      });
      _scrollToBottom();
      _playNextBotMessage();
    }
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

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  void _showEndDialog() {
    Future.delayed(const Duration(milliseconds: 100), () {
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
                        child: const Text("아니오", style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo')),
                      ),
                      const SizedBox(width: 12),
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
                        child: const Text("예", style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE6B7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '(${widget.counselorType}) 상담 중',
          style: const TextStyle(fontFamily: 'DungGeunMo', color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              children: _messages
                  .map((m) => _buildMessageBubble(m['text'], m['isUser']))
                  .toList(),
            ),
          ),
          _buildInputBar(),
        ],
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
              onPressed: _showEndDialog,
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



/// 상담 종료 다이얼로그
void _showEndDialog(BuildContext context) {
  Future.delayed(Duration(milliseconds: 100), () { // 약간의 딜레이 후 실행
    showDialog(
      context: context,
      barrierDismissible: true, // 팝업 바깥 클릭 시 닫기
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent, // 배경 투명 처리
          contentPadding: EdgeInsets.zero, // 기본 패딩 제거
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8, // 팝업 크기 조정
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16), // 내부 패딩 증가
            decoration: BoxDecoration(
              color: Colors.white, // 팝업 배경색
              borderRadius: BorderRadius.circular(10), // 모서리 둥글게
              border: Border.all(color: Colors.black, width: 2), // 검은 테두리 추가
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
                const SizedBox(height: 20), // 질문과 버튼 간격 증가
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400], // 중립적인 색상
                        foregroundColor: Colors.black, // 글씨색
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
                    const SizedBox(width: 12), // 버튼 간격 좁힘
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF798063), // 기존 팝업과 동일한 배경색
                        foregroundColor: Colors.white, // 글씨색
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