import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/provider/user_provider.dart';
import 'dto/chat_dto.dart';
import 'dto/message_dto.dart';
import 'voice_chat.dart';
import 'text_chat.dart';
import 'counsel_confirm_dialog.dart';
import 'package:http/http.dart' as http;


class CounselorSelectionPage extends StatefulWidget {
  @override
  _CounselorSelectionPageState createState() => _CounselorSelectionPageState();
}

class _CounselorSelectionPageState extends State<CounselorSelectionPage> {
  String selectedCounselor = '공감형';
  String selectedMethod = 'chat';
  List<ChatDTO> chatRecords = [];

  @override
  void initState() {
    super.initState();
    _loadChatData();
  }

  Future<void> _loadChatData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.id;

    if (userId.isEmpty) {
      return;
    }

    final response = await http.get(
      Uri.parse('https://www.emoti.kr/chats/get/chats?userId=$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      chatRecords = data
        .map((e) => ChatDTO.fromJson(e))
        .where((chat) => chat.counselorType != "도장") // 음성채팅 제외
        .toList();
      setState(() {});
    }
  }

  Widget _buildCounselorButton(String label, String imagePath) {
    bool isSelected = selectedCounselor == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCounselor = label;
        });
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFFDDE3CB) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? const Color.fromARGB(255, 110, 120, 91)
                : Colors.white54,
            width: 3,
          ),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'DungGeunMo',
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodButton(String label, Widget iconWidget, String value) {
    bool isSelected = selectedMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected 
              ? const Color(0xFFDDE3CB)  
              : const Color(0xFFF1F3E5), 
          border: Border.all(
            color: isSelected 
                ? const Color.fromARGB(255, 110, 120, 91)
                : Colors.white,
            width: 3,
          ),
        ),
        child: SizedBox(
          width: 55,
          height: 55,
          child: iconWidget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EBD9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFE9EBD9),
        elevation: 0,
        title: const Text(' 상담 준비하기', style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 30, color: Colors.black)),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0), 
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, size: 30, color: Colors.black),
                onPressed: () async {
                  await _loadChatData();
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ),
        ],
      ),
      endDrawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('  * 상담사 유형 선택', style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 110, 120, 91), fontFamily: 'DungGeunMo')),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCounselorButton('공감형', 'assets/images/empathetic _counselor.png'),
                _buildCounselorButton('조언형', 'assets/images/advisory_counselor.png'),
                _buildCounselorButton('유머러스형', 'assets/images/humorous_counselor.png'),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
              child: Divider(color: Colors.black26, thickness: 2, indent: 8, endIndent: 8),
            ),
            const Text('  * 상담 방식 선택', style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 110, 120, 91), fontFamily: 'DungGeunMo')),
            const SizedBox(height: 4),
            const Text('  * 음성 상담 시 상담 기록은 저장되지 않아요!', style: TextStyle(fontSize: 15, color: const Color.fromARGB(255, 110, 120, 91), fontFamily: 'DungGeunMo')),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMethodButton('채팅', Image.asset('assets/images/chatcounsel.png', width: 24, height: 24), 'chat'),
                _buildMethodButton('음성', Image.asset('assets/images/voicecounsel.png', width: 24, height: 24), 'voice'),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ConfirmDialog(
                        counselorType: selectedCounselor,
                        method: selectedMethod,
                        onConfirm: () {
                          Navigator.pop(context);
                          final screen = selectedMethod == 'voice' ? VoiceChatScreen(counselorType: selectedCounselor) : TextChatScreen(counselorType: selectedCounselor);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => screen),
                          );
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 110, 120, 91),
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '상담 시작하기',
                  style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Container(
        color: const Color(0xFFE9EBD9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '채팅 기록',
                style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 20),
              ),
            ),
            Expanded(
              child: chatRecords.isEmpty
                  ? const Center(
                      child: Text(
                        ' 채팅 기록이\n아직 없습니다',
                        style: TextStyle(
                          fontFamily: 'DungGeunMo',
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                itemCount: chatRecords.length,
                itemBuilder: (context, index) {
                  final record = chatRecords[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatHistoryDetailScreen(
                            timestamp: record.timestamp,
                            stamp: record.stamp,
                            messages: record.messages
                          ),
                        ),
                      );
                    },
                    child: _buildChatRecord(record.timestamp, record.stamp, record.messages.last),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatRecord(DateTime timestamp, String stamp, MessageDTO lastMessage) {
    
    final imageMap = {
      '희망': 'assets/images/hopestamp.png',
      '회복': 'assets/images/recoverystamp.png',
      '결단': 'assets/images/determinationstamp.png',
      '성찰': 'assets/images/reflectionstamp.png',
      '용기': 'assets/images/couragestamp.png',
    };

    final imagePath = imageMap[stamp] ?? 'assets/images/hopestamp.png';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('yyyy/MM/dd').format(timestamp),
            style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 18),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Image.asset(
                imagePath,
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              if (lastMessage.text.isNotEmpty)
                Expanded(
                  child: Text(
                    lastMessage.text,
                    style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 14, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          const Divider(thickness: 1, color: Colors.black26),
        ],
      ),
    );
  }
}

class ChatHistoryDetailScreen extends StatelessWidget {
  final DateTime timestamp;
  final String stamp;
  final List<MessageDTO> messages;

  const ChatHistoryDetailScreen({
    super.key,
    required this.timestamp,
    required this.stamp,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    final imageMap = {
      '희망': 'assets/images/hopestamp.png',
      '회복': 'assets/images/recoverystamp.png',
      '결단': 'assets/images/determinationstamp.png',
      '성찰': 'assets/images/reflectionstamp.png',
      '용기': 'assets/images/couragestamp.png',
    };
    final imagePath = imageMap[stamp] ?? 'assets/images/hopestamp.png';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          '${DateFormat('yyyy/MM/dd').format(timestamp)} 상담 기록',
          style: const TextStyle(
            fontFamily: 'DungGeunMo',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.asset(imagePath, width: 50, height: 50),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isUser = msg.isUser == true;
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.green[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg.text,
                        style: const TextStyle(
                          fontFamily: 'DungGeunMo',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}