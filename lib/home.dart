import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/stamp_board.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_main_content.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPetSelected = true;
  int _selectedIndex = 0; // 메인 화면: 0, 도장 화면: 1

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _onTabTapped(0),
                        child: Column(
                          children: [
                            Text(
                              '펫',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'DungGeunMo',
                              color: _selectedIndex == 0
                                ? const Color(0xFF414728)
                                : const Color.fromRGBO(78, 87, 44, 0.25),
                          ),
                            ),
                            if (_selectedIndex == 0)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 6,
                            width: 40,
                            color: const Color.fromRGBO(5, 5, 2, 0.35),
                          ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      
                        GestureDetector(
  onTap: () => _onTabTapped(1), // {
//   print("🔹 도장판 클릭됨! StampBoard 페이지로 이동");
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => StampBoard()), // ✅ 직접 StampBoard 호출
//   );
// },

  child: Container(
    color: Colors.transparent, // 터치 감지 가능하도록 배경 추가
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    child: Column(
      children: [
        Text(
          '도장판',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            fontFamily: 'DungGeunMo',
            color: _selectedIndex == 1
                                ? const Color(0xFF414728)
                                : const Color.fromRGBO(78, 87, 44, 0.25),
                          ),
                            ),
                            if (_selectedIndex == 1)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 6,
            width: 70,
            color: const Color.fromRGBO(5, 5, 2, 0.35),
          ),
      ],
    ),
  ),
),


                      
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.black45,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 2,
                width: MediaQuery.of(context).size.width * 0.85,
                color: const Color.fromRGBO(78, 87, 44, 0.35),
              ),
            ],
          ),
        ),
      ),
      body: 
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0), // 오른쪽에서 등장
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: _selectedIndex == 0
            ? MainContent(key: const ValueKey(0)) // 메인 화면
            : StampBoard(key: const ValueKey(1)), // 도장판 화면
      ),
    );
  }
}