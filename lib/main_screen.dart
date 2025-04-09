import 'package:flutter/material.dart';
import 'home.dart';
import 'chatting_setting.dart';
import 'profile.dart';

// 앱 내 공통 하단 아이콘바 구현
class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(),
          CounselorSelectionPage(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child:  BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFDCE6B7),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFF474C34),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/homeicon.png'),
              size: 40,
              color: _currentIndex == 0 ? const Color(0xFF474C34) : Colors.grey,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/messageicon.png'),
              size: 40,
              color: _currentIndex == 1 ? const Color(0xFF474C34) : Colors.grey,
            ),
            label: '상담',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/usericon.png'),
              size: 40,
              color: _currentIndex == 2 ? const Color(0xFF474C34) : Colors.grey,
            ),
            label: '프로필',
          ),
        ],
      ),
      ),
    );
  }
}