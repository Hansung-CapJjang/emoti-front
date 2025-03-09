import 'package:flutter/material.dart';

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

class ChattingSettingScreen extends StatelessWidget {
  const ChattingSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE5B6),
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
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
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
                _buildOptionButton('조언형', false),
                _buildOptionButton('유머러스형', false),
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
                _buildOptionButton('문자 상담', true),
                _buildOptionButton('음성 상담', false),
              ],
            ),
            const Spacer(flex: 2,),
            Center(
              child: ElevatedButton(
                onPressed: () {},
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

      // 하단 아이콘 바 - mainScreen.dart 이동

      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: const Color(0xFFDDE5B6),
      //   selectedItemColor: Colors.white,
      //   unselectedItemColor: Colors.black54,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
      //     BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: '상담'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
      //   ],
      // ),
    );
  }

  Widget _buildOptionButton(String text, bool selected) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFEFF2DD) : Colors.white,
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
          style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 16, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}