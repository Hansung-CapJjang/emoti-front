import 'package:flutter/material.dart';
import 'voice_chat.dart';
import 'text_chat.dart';

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
      backgroundColor: const Color(0xFFDCE6B7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '상담 방식 선택',
          style: TextStyle(
            fontFamily: 'DungGeunMo',
            // ontWeight: FontWeight.bold,
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
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text('문자 상담은 아직 구현되지 않았습니다.')),
                    // );
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
      // ),
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
          color: isSelected ? const Color.fromARGB(255, 247, 253, 217) : const Color.fromARGB(255, 217, 225, 176),
          border: Border.all(
            color: isSelected ? const Color.fromARGB(104, 141, 170, 102) : const Color.fromARGB(255, 119, 147, 82),
            width: isSelected ? 2 : 0,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
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
    width: MediaQuery.of(context).size.width * 0.6,
    child: Container(
      color: const Color(0xFFEFEFCC), // 배경색 조정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Icon(Icons.arrow_back, size: 30),
                // SizedBox(width: 10),
                Text(
                  '채팅 기록',
                  style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 20,),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildChatRecord('2월 10일'),
                _buildChatRecord('2월 8일'),
                _buildChatRecord('2월 5일'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// 채팅 이전 기록 항목 위젯
  Widget _buildChatRecord(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 18),
          ),
          Row(
            children: [
              Image.asset(
                'assets/images/hopestamp.png',
                width: 40,
                height: 40,
              ),
            ],
          ),
          const Divider(thickness: 1, color: Colors.black26),
        ],
      ),
    );
  }
}