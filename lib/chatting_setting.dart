import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'voice_chat.dart';
import 'text_chat.dart';

class ChattingSettingScreen extends StatefulWidget {
  const ChattingSettingScreen({super.key});

  @override
  State<ChattingSettingScreen> createState() => _ChattingSettingScreenState();
}

class _ChattingSettingScreenState extends State<ChattingSettingScreen> {
  String selectedCounselor = '공감형';
  String selectedMethod = '문자 상담';

  List<Map<String, dynamic>> chatRecords = [];

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    final String jsonString = await rootBundle.loadString('assets/data.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    final records = jsonData.map<Map<String, dynamic>>((item) {
      final timestamp = DateTime.parse(item['timestamp']);
      final month = timestamp.month;
      final day = timestamp.day;
      final formattedDate = '$month월 $day일';
      final stamp = item['stamp'] ?? '희망';

      final messages = item['messages'] as List<dynamic>;
      final preview = messages.firstWhere(
        (m) => m['isUser'] == true,
        orElse: () => {'text': ''},
      )['text'];

      return {
        'date': formattedDate,
        'stamp': stamp,
        'preview': preview,
      };
    }).toList();

    setState(() {
      chatRecords = records;
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
        title: const Text(
          '상담 방식 선택',
          style: TextStyle(
            fontFamily: 'DungGeunMo',
            color: Colors.black,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: Color.fromARGB(130, 65, 80, 62), thickness: 1),
            const SizedBox(height: 30),
            const Text(
              '※ 선호하는 상담사 유형을 직접 선택할 수 있어요!',
              style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildOptionButton('공감형', true),
                _buildOptionButton('조언형', true),
                _buildOptionButton('유머러스형', true),
              ],
            ),
            const Spacer(),
            const Divider(color: Colors.black45, thickness: 0.5),
            const SizedBox(height: 30),
            const Text(
              '※ 음성으로 상담 시 상담 기록이\n  저장되지 않아요!',
              style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildOptionButton('문자 상담', false),
                _buildOptionButton('음성 상담', false),
              ],
            ),
            const Spacer(flex: 2),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final screen = selectedMethod == '음성 상담'
                      ? VoiceChatScreen(counselorType: selectedCounselor)
                      : TextChatScreen(counselorType: selectedCounselor);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screen),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C7448),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '상담 시작하기',
                  style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String text, bool isCounselor) {
    bool isSelected = isCounselor ? (selectedCounselor == text) : (selectedMethod == text);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isCounselor) {
            selectedCounselor = text;
          } else {
            selectedMethod = text;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 247, 253, 217)
              : const Color.fromARGB(255, 217, 225, 176),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(104, 141, 170, 102)
                : const Color(0xFF779352),
            width: isSelected ? 2 : 0,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'DungGeunMo',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: isSelected ? Colors.black : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Container(
        color: const Color(0xFFEFEFCC),
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
              child: ListView.builder(
                itemCount: chatRecords.length,
                itemBuilder: (context, index) {
                  final record = chatRecords[index];
                  return _buildChatRecord(record['date'], record['stamp'], record['preview']);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatRecord(String date, String stamp, [String? preview]) {
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
            date,
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
              if (preview != null && preview.isNotEmpty)
                Expanded(
                  child: Text(
                    preview,
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
