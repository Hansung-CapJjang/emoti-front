import 'package:flutter/material.dart';
import 'chatting_setting.dart';

class TextChatScreen extends StatefulWidget {
  final String counselorType;

  const TextChatScreen({super.key, required this.counselorType});

  @override
  _TextChatScreenState createState() => _TextChatScreenState();
}

class _TextChatScreenState extends State<TextChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 채팅 추가 및 스크롤 맨 아래로 이동
  void _sendMessage() {
    final String text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isUser': true});
    });

    _textController.clear();
    _scrollToBottom();
  }

  // ListView를 가장 아래로 스크롤
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE6B7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '(${widget.counselorType}) ',
                style: const TextStyle(
                  fontFamily: 'DungGeunMo',
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const TextSpan(
                text: '상담 중',
                style: TextStyle(
                  fontFamily: 'DungGeunMo',
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Divider(color: Colors.black26, thickness: 1),
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '※ 상담을 시작합니다.',
                style: TextStyle(
                  fontFamily: 'DungGeunMo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildMessageBubble("안녕하세요, 00님! 만나서 반가워요.", false),
                _buildMessageBubble("앞서 작성한 고민 키워드와 관련한 내용으로 상담하시겠어요?", false),
                _buildMessageBubble("응?", false),
                for (var message in _messages)
                  _buildMessageBubble(message['text'], message['isUser']),
              ],
            ),
          ),
          _buildChatInput(),
        ],
      ),
    );
  }

  /// 채팅 메시지 버블 (사용자 입력 시 오른쪽 정렬)
  Widget _buildMessageBubble(String message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6, // 최대 가로 길이 60%
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
          boxShadow: [
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
                style: const TextStyle(fontSize: 10, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 현재 시간을 "HH:mm" 형식으로 반환
  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  /// 입력창 및 상담 종료 버튼
  Widget _buildChatInput() {
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
                    style: TextStyle(fontFamily: 'DungGeunMo',),
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '메시지를 입력하세요...',
                      hintStyle: TextStyle(fontFamily: 'DungGeunMo', color: Colors.black38),
                    ),
                    onChanged: (text) {
                      setState(() {}); // 입력값이 변경될 때마다 UI 업데이트
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: _textController.text.trim().isEmpty ? Colors.grey : const Color(0xFF6C7448),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
  icon: Transform.rotate(
    angle: -0.7854, // 라디안 단위 (-45도 = -π/4)
    child: const Icon(Icons.send, color: Colors.white),
  ),
  onPressed: _textController.text.trim().isEmpty ? null : _sendMessage,
),

              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
  width: double.infinity,
  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  child: ElevatedButton(
    onPressed: () {
      _showEndDialog(context);
    },
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
      ],
    );
  }
}

/// 상담 종료 다이얼로그
void _showEndDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("상담을 종료하시겠습니까?", style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 18),),
        // content: const Text("상담을 종료하시겠습니까?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
            },
            child: const Text("아니오", style: TextStyle(fontFamily: 'DungGeunMo',),),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
               Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChattingSettingScreen(),
                  ),
                ); // (상담 종료 처리)
            },
            child: const Text("예", style: TextStyle(fontFamily: 'DungGeunMo',),),
          ),
        ],
      );
    },
  );
}