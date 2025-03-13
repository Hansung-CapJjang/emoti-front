import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

Future<void> _downloadImage() async {
  final ByteData data = await rootBundle.load('assets/images/Vector.png');
  final Uint8List bytes = data.buffer.asUint8List();

  final Directory directory = await getApplicationDocumentsDirectory();
  final File imageFile = File('${directory.path}/Vector.png');
  await imageFile.writeAsBytes(bytes);

  print("Image saved at: ${imageFile.path}");
}

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
  int _selectedIndex = 0; // 선택된 인덱스

  // 랜덤 문구 리스트
  final List<String> speechTexts = [
    "How can I help you?",
    "I'm here for you!",
    "Let's chat!",
    "What's on your mind?",
    "Ready to talk?",
    "Hi~"
  ];

  // 랜덤 문구를 저장할 변수
  late String randomSpeechText;

  void _showPopupDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // 팝업 바깥 클릭하면 닫힘
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent, // 배경 투명 처리
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 팝업 크기 조정
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, // 팝업 배경색
            borderRadius: BorderRadius.circular(10), // 모서리 둥글게
            border: Border.all(color: Colors.black, width: 2), // 검은 테두리 추가
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '도장판을 완성하면\n버튼이 활성화 돼요!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DungGeunMo', // 기존 스타일 유지
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '도장판을 완성할 때마다\n캐릭터가 성장한답니다',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'DungGeunMo',
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF798063), // 배경색
                  foregroundColor: Colors.white, // 글씨색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.black, width: 1.5), // 버튼 테두리 추가
                  ),
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  @override
  void initState() {
    super.initState();
    randomSpeechText = speechTexts[Random().nextInt(speechTexts.length)];
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
        automaticallyImplyLeading: false, // 앱바 뒤로가기 아이콘 삭제
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
                        onTap: () {
                          setState(() {
                            isPetSelected = true;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              '펫',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'DungGeunMo',
                                color: isPetSelected
                                    ? const Color(0xFF414728)
                                    : const Color.fromRGBO(78, 87, 44, 0.25),
                              ),
                            ),
                            if (isPetSelected)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                height: 6,
                                width: 40,
                                color: const Color.fromRGBO(5, 5, 2, 0.35),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 25),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isPetSelected = false;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              '도장판',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'DungGeunMo',
                                color: !isPetSelected
                                    ? const Color(0xFF414728)
                                    : const Color.fromRGBO(78, 87, 44, 0.25),
                              ),
                            ),
                            if (!isPetSelected)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                height: 6,
                                width: 90,
                                color: const Color.fromRGBO(5, 5, 2, 0.35),
                              ),
                          ],
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Lv.1',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'DungGeunMo',
                            color: const Color(0xFF414728).withOpacity(0.64),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Egg',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DungGeunMo',
                            color: const Color(0xFF414728),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                height: 14,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF798063).withOpacity(0.56),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.42,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF56644B),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '60%',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'DungGeunMo',
                            color: const Color(0xFF5A6140),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                // 캐릭터 이미지
                Image.asset(
                  'assets/images/demo_baebse.png',
                  width: 280,
                  
                  alignment: Alignment.bottomCenter,
                ),
                // 말풍선
                Positioned(
                  bottom: 320, // 캐릭터와 막대 사이에 위치
                 
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.95, // 말풍선 너비 조정
                    ),
                    padding: const EdgeInsets.all(10), // 말풍선 패딩 조정
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Wrap(
                      children: [
                        Text(
                          randomSpeechText,
                          style: const TextStyle(
                            fontSize: 20, // 텍스트 크기 조정
                            fontFamily: 'DungGeunMo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // 캐릭터 아래 간격 추가
        Row(
  mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
  children: [
    ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF798063).withOpacity(0.56),
        foregroundColor: const Color(0xFF454545),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(180, 60), // 버튼 크기 유지
      ),
      child: Center(
  child: const Text(
    '도장판 제출',
    style: TextStyle(
      fontFamily: 'DungGeunMo',
      fontSize: 20,
    ),
  ),
),

    ),
    const SizedBox(width: 20), // 버튼과 아이콘 간격 추가
    GestureDetector(
  onTap: () => _showPopupDialog(context), // 👈 클릭하면 팝업 띄우기
  child: Image.asset(
    'assets/images/informationicon.png',
    width: 30,
    height: 30,
  ),
),

  ],
),
            const SizedBox(height: 30), // 버튼 아래 간격 추가
          ],
        ),
      ),
    );
  }

  static Widget _buildEye() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: const Center(
        child: CircleAvatar(
          backgroundColor: Colors.black,
          radius: 5,
        ),
      ),
    );
  }
}