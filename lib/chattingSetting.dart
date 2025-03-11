import 'package:flutter/material.dart';
import 'voiceChat.dart';
import 'textChat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChattingSettingScreen(),
    );
  }
}

class ChattingSettingScreen extends StatefulWidget {
  const ChattingSettingScreen({super.key});

  @override
  State<ChattingSettingScreen> createState() => _ChattingSettingScreenState();
}

class _ChattingSettingScreenState extends State<ChattingSettingScreen> {
  String selectedCounselor = '공감형'; // 기본 선택값
  String selectedMethod = '문자 상담'; // 기본 선택값

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 211, 114),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '상담 방식 선택',
          style: TextStyle(
            fontFamily: 'DungGeunMo',
            fontWeight: FontWeight.bold,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: Colors.black45, thickness: 0.5),
            const SizedBox(height: 30),
            const Text(
              '※ 님이 선호하는 상담사 유형을\n  직접 선택하여 상담 받을 수 있어요.',
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
            const SizedBox(height: 30),
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
                  if (selectedMethod == '음성 상담') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VoiceChatScreen(
                          counselorType: selectedCounselor, // 선택한 상담가 유형 전달
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('문자 상담은 아직 구현되지 않았습니다.')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TextChatScreen(
                          counselorType: selectedCounselor, // 선택한 상담가 유형 전달
                        ),
                      ),
                    );
                  }
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
      endDrawer: _buildDrawer(),
    );
  }

  /// 옵션 선택 버튼 UI
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
          color: isSelected ? Colors.white : Colors.grey[300],
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            )
          ],
        ),
        child: Padding(
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
      ),
    );
  }

  /// 서랍 (Drawer) UI
  Widget _buildDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.grey[300]),
            child: const Center(
              child: Text(
                '메뉴',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('홈'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.question_answer),
            title: const Text('상담'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('프로필'),
            onTap: () {},
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('닫기'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}