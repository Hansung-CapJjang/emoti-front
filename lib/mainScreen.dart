import 'package:flutter/material.dart';
import 'home.dart';
import 'chattingSetting.dart';
import 'profile.dart';

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
    BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
    BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: '상담'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
  ],
  backgroundColor: Color(0xFFEEEEEE),
  selectedItemColor: Colors.grey,
  unselectedItemColor: Colors.black,
  showSelectedLabels: false, // 선택된 아이템의 라벨 숨기기
  showUnselectedLabels: false, // 선택되지 않은 아이템의 라벨 숨기기
      ),
    );
  }
}