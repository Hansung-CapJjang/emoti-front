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
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE5B6), // ����
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '마이 페이지',
          style: TextStyle(
            fontFamily: 'DungGeunMo',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark, color: Colors.black54),
            onPressed: () {


            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          
          //
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.brown[200], 
                      child: const Icon(Icons.remove_red_eye, size: 40, color: Colors.black),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'EGG',
                      style: TextStyle(
                        fontFamily: 'DungGeunMo',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18, color: Colors.black54),
                      onPressed: () {},
                    )
                  ],
                ),
                const Text(
                  '도장판 5/10',
                  style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lv.1   60%',
                  style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.6, // 60% 
                    minHeight: 8,
                    backgroundColor: Colors.black12,
                    color: Colors.green[500],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          
          // 메뉴 선택란
          Expanded(
            
            child: ListView(
              children: [
                _buildMenuItem(Icons.keyboard_arrow_right, '고민 사항'),
                _buildToggleMenuItem('알람 설정', true),
                _buildMenuItem(Icons.logout, '로그아웃'),
                _buildDisabledMenuItem('회원 탈퇴'),
              ],
            ),
          ),
        ],
      ),

      // 하단 아이콘 바 - mainScreen.dart 이동

      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: const Color(0xFFDDE5B6),
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.black54,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   currentIndex: 2, 
      //   onTap: (index) {},
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ȩ'),
      //     BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: '���'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: '������'),
      //   ],
      // ),
    );
  }

  // 고민 사항 & 로그아웃
  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 16)),
      onTap: () {},
    );
  }

  // 알람 설정 토글 버튼
  Widget _buildToggleMenuItem(String title, bool isOn) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 16)),
      trailing: Switch(
        value: isOn,
        onChanged: (value) {},
      ),
    );
  }

  // 회원 탈퇴 버튼
  Widget _buildDisabledMenuItem(String title) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 16, color: Colors.black38),
      ),
    );
  }
}