import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/user_provider.dart';
import 'package:provider/provider.dart';

class StampBoard extends StatefulWidget {
  const StampBoard({super.key});

  @override
  _StampBoardState createState() => _StampBoardState();
}

class _StampBoardState extends State<StampBoard> {
  List<int> stampCounts = [1, 3, 5, 8];
  late PageController _pageController;
  int currentLevel = 1;
  int currentShowLevel = 1;
  List<String> userStamps = []; // 추가

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentShowLevel);
    _loadUserData(); // 추가
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextLevel() {
    if (currentShowLevel < stampCounts.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _prevLevel() {
    if (currentShowLevel > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _loadUserData() async { // 추가
    final userEmail = Provider.of<UserProvider>(context, listen: false).email;
    final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    final user = jsonData.cast<Map<String, dynamic>>().firstWhere(
      (u) => u['email'] == userEmail,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      setState(() {
        currentLevel = user['level'];
        userStamps = List<String>.from(user['stamp']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE6B7),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            "~~ 도전 중! Lv.$currentLevel ~~",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'DungGeunMo',
              color: Color(0xFF414728),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.71,
                  height: 185,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: stampCounts.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentShowLevel = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final stampCount = stampCounts[index];
                      List<List<int>> rows = [];
                      if (stampCount == 5) {
                        rows = [
                          [0, 1, 2],
                          [3, 4]
                        ];
                      } else {
                        for (int i = 0; i < stampCount; i += 4) {
                          int end = (i + 4 < stampCount) ? i + 4 : stampCount;
                          rows.add(List.generate(end - i, (j) => i + j));
                        }
                      }
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9EFC7),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFF798063), width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: rows.map((row) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: row.map((stampIndex) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF798063),
                                        ),
                                      ),
                                      Image.asset(
                                        "assets/images/stamp${(stampIndex % 5) + 1}.png",
                                        width: 70,
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
                // 좌우 화살표
                Positioned(
                  left: -25,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    icon: Icon(
                      Icons.chevron_left,
                      color: currentShowLevel > 0 ? const Color(0xFF56644B) : Colors.black.withOpacity(0.27),
                      size: 50,
                    ),
                    onPressed: _prevLevel,
                  ),
                ),
                Positioned(
                  right: -25,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    icon: Icon(
                      Icons.chevron_right,
                      color: currentShowLevel < stampCounts.length - 1
                          ? const Color(0xFF56644B)
                          : Colors.black.withOpacity(0.27),
                      size: 50,
                    ),
                    onPressed: _nextLevel,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 0),
          // 도장 도감 버튼
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(95, 5),
                  child: const Text(
                    "도장 도감",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'DungGeunMo',
                      color: Color(0xFF414728),
                    ),
                  ),
                ),
                const SizedBox(width: 1.5),
                Transform.translate(
                  offset: const Offset(100, 5),
                  child: GestureDetector(
                    onTap: () {
                      _showPopupDialog(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: const Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Color(0xFF798063),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 구분선
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(0, 17),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 2,
                  color: const Color.fromRGBO(78, 87, 44, 0.35),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // 내 도장 텍스트
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(-115, 17),
                child: const Text(
                  "내 도장",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DungGeunMo',
                    color: Color(0xFF414728),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 내 도장 리스트
          FutureBuilder<Map<String, int>>(
            future: (() async {
              final userEmail = Provider.of<UserProvider>(context, listen: false).email;
              final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
              final List<dynamic> jsonData = json.decode(jsonString);
              final user = jsonData.cast<Map<String, dynamic>>().firstWhere(
                (u) => u['email'] == userEmail,
                orElse: () => {},
              );
              final List<dynamic> stamps = user['stamp'] ?? [];
              final Map<String, int> stampCounts = {
                '희망': 0,
                '회복': 0,
                '결단': 0,
                '성찰': 0,
                '용기': 0,
              };
              for (var stamp in stamps) {
                if (stampCounts.containsKey(stamp)) {
                  stampCounts[stamp] = stampCounts[stamp]! + 1;
                }
              }
              return stampCounts;
            })(),
            builder: (context, snapshot) {
              final counts = snapshot.data ?? {
                '희망': 0,
                '회복': 0,
                '결단': 0,
                '성찰': 0,
                '용기': 0,
              };
              return Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EFC7),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF798063), width: 2),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/images/hopestamp.png", width: 60),
                            const SizedBox(width: 5),
                            Text("x ${counts['희망']}", style: const TextStyle(fontSize: 18, fontFamily: 'DungGeunMo')),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset("assets/images/couragestamp.png", width: 60),
                            const SizedBox(width: 5),
                            Text("x ${counts['용기']}", style: const TextStyle(fontSize: 18, fontFamily: 'DungGeunMo')),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset("assets/images/determinationstamp.png", width: 60),
                            const SizedBox(width: 5),
                            Text("x ${counts['결단']}", style: const TextStyle(fontSize: 18, fontFamily: 'DungGeunMo')),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/images/reflectionstamp.png", width: 60),
                            const SizedBox(width: 5),
                            Text("x ${counts['성찰']}", style: const TextStyle(fontSize: 18, fontFamily: 'DungGeunMo')),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            Image.asset("assets/images/recoverystamp.png", width: 60),
                            const SizedBox(width: 5),
                            Text("x ${counts['회복']}", style: const TextStyle(fontSize: 18, fontFamily: 'DungGeunMo')),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

void _showPopupDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // 팝업 바깥 클릭 시 닫기
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.transparent, // 배경 투명 처리
        contentPadding: EdgeInsets.zero, // 기본 패딩 제거
        content: Container(
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
                '레벨 별 필요 도장 개수',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Lv 1 -> 0개\nLv 2 -> 1개\nLv 3 -> 3개\nLv 4 -> 5개\nLv 5 -> 8개',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'DungGeunMo',
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(), // 팝업 닫기
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF798063), // 배경색
                  foregroundColor: Colors.white, // 글씨색
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
            ],
          ),
        ),
      );
    },
  );
}