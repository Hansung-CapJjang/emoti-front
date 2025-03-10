import 'package:flutter/material.dart';
import 'home.dart';
import 'chattingSetting.dart';
import 'profile.dart';

// 앱 내 공통 하단 아이콘바 구현 

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          ChattingSettingScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home, size: 30,), label: '홈'),
    BottomNavigationBarItem(icon: Icon(Icons.question_answer, size: 30,), label: '상담'),
    BottomNavigationBarItem(icon: Icon(Icons.person, size: 30,), label: '내 정보'),
  ],
  backgroundColor: const Color(0xFFDDE5B6),
  selectedItemColor: const Color.fromARGB(255, 30, 30, 30),
  unselectedItemColor: const Color.fromARGB(255, 157, 157, 157),
  showSelectedLabels: false, // 선택된 아이콘 라벨 숨기기
  showUnselectedLabels: false, // 선택되지 않은 아이콘 라벨 숨기기
      ),
    );
  }
}