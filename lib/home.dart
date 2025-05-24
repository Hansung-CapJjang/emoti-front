import 'package:flutter/material.dart';
import 'package:flutter_application_1/stamp_board.dart';
import 'home_main_content.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPetSelected = true;
  int _selectedIndex = 0; // 메인 화면: 0, 도장 화면: 1

  void _showLevelDialog(BuildContext parentContext) {
  showDialog(
    context: parentContext,
    builder: (BuildContext dialogContext) => AlertDialog(
      title: const Text( 
        '레벨 별 펫 도감',
        style: TextStyle(fontFamily: 'DungGeunMo'),
      ),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 350,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            _levelPetImageRow(
              level: 1,
              imagePath1: 'assets/images/egg_shadow.png',
              imagePath2: 'assets/images/egg_shadow.png',
            ),
            _levelPetImageRow(
              level: 2,
              imagePath1: 'assets/images/baebse1_shadow.png',
              imagePath2: 'assets/images/penguin1_shadow.png',
            ),
            _levelPetImageRow(
              level: 3,
              imagePath1: 'assets/images/baebse2_shadow.png',
              imagePath2: 'assets/images/penguin2_shadow.png',
            ),
            _levelPetImageRow(
              level: 4,
              imagePath1: 'assets/images/baebse3_shadow.png',
              imagePath2: 'assets/images/penguin3_shadow.png',
            ),
            _levelPetImageRow(
              level: 5,
              imagePath1: 'assets/images/baebse4_shadow.png',
              imagePath2: 'assets/images/penguin4_shadow.png',
            ),
            
          ],
          
        ),
        
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF798063),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.black, width: 1.5),
              ),
            ),
           child: const Text(
              '확인',
              style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
            ),
          ),
        )
      ],
    ),
  );
}

  Widget _levelPetImageRow({
  required int level,
  required String imagePath1,
  required String imagePath2,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('레벨 $level',
            style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 18)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath1, width: 80, height: 80, fit: BoxFit.contain),
            const SizedBox(width: 20),
            Image.asset(imagePath2, width: 80, height: 80, fit: BoxFit.contain),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(indent: 10, endIndent: 10, thickness: 2,)
      ],
    ),
  );
}

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
      backgroundColor: const Color(0xFFE9EBD9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
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
                        onTap: () => _onTabTapped(1),
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
                                    ? const Color(0xFF414728) : const Color.fromRGBO(78, 87, 44, 0.25),
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
                  // IconButton으로 바꾸고 onPressed에 다이얼로그 연결
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: IconButton(
                      icon: const Icon(
                        Icons.question_mark,
                        color: Colors.black45,
                        size: 25,
                      ),
                      onPressed: () => _showLevelDialog(context),
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
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: _selectedIndex == 0
          ? MainContent(key: const ValueKey(0)) : StampBoard(key: const ValueKey(1)),
      ),
    );
  }
}