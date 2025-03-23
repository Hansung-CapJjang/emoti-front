import 'package:flutter/material.dart';

class StampBoard extends StatefulWidget {
  const StampBoard({super.key});

  @override
  _StampBoardState createState() => _StampBoardState();
}

class _StampBoardState extends State<StampBoard> {
  int currentLevel = 0;
  List<int> stampCounts = [1, 3, 5, 8];

  void _nextLevel() {
    setState(() {
      if (currentLevel < stampCounts.length - 1) {
        currentLevel++;
      }
    });
  }

  void _prevLevel() {
    setState(() {
      if (currentLevel > 0) {
        currentLevel--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int currentStampCount = stampCounts[currentLevel];
    int rowCount = (currentStampCount / 4).ceil();
    double containerHeight = rowCount * 60.0 + 40.0;

    return Scaffold(
      backgroundColor: const Color(0xFFDCE6B7),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            "~~ 도전 중! Lv.${currentLevel + 1} ~~",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'DungGeunMo',
              color: Color(0xFF414728),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.85, // 도장판 + 화살표 포함 넉넉한 너비
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 도장판
                Container(
                  width: MediaQuery.of(context).size.width * 0.71,
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EFC7),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFF798063), width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: () {
                      int currentStampCount = stampCounts[currentLevel];
                      List<List<int>> rows = [];
                      if (currentStampCount == 5) {
                        rows = [
                          [0, 1, 2],
                          [3, 4]
                        ];
                      } else {
                        for (int i = 0; i < currentStampCount; i += 4) {
                          int end = (i + 4 < currentStampCount) ? i + 4 : currentStampCount;
                          rows.add(List.generate(end - i, (j) => i + j));
                        }
                      }
                      return rows.map((row) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
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
                      }).toList();
                    }(),
                  ),
                ),
                // 왼쪽 화살표
                Positioned(
                  left: -25,
                  child: IconButton(
                    splashColor: Colors.transparent,        // 🔒 효과 제거
                    highlightColor: Colors.transparent,     // 🔒 강조 제거
                    hoverColor: Colors.transparent,         // 🔒 마우스 hover 제거
                    icon: Icon(
                      Icons.chevron_left,
                      color: currentLevel > 0
                          ? const Color(0xFF56644B)
                          : Colors.black.withOpacity(0.27),
                      size: 50,
                    ),
                    onPressed: currentLevel > 0 ? _prevLevel : null,
                  ),
                ),
                // 오른쪽 화살표
                Positioned(
                  right: -25,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    icon: Icon(
                      Icons.chevron_right,
                      color: currentLevel < stampCounts.length - 1
                          ? const Color(0xFF56644B)
                          : Colors.black.withOpacity(0.27),
                      size: 50,
                    ),
                    onPressed: currentLevel < stampCounts.length - 1 ? _nextLevel : null,
                  ),
                ),
              ],
            ),
          ),
          // 도장 도감 버튼
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(80, 10),
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
                  offset: const Offset(85, 10),
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
                offset: const Offset(0, 27),
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
                offset: const Offset(-105, 35),
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
          // 내 도장 리스트
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(0, 40),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EFC7),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFF798063), width: 2),
                  ),
                  child: Column(
                    children: [
                      // 첫 번째 줄
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/images/stamp1.png", width: 60),
                              const SizedBox(width: 5),
                              const Text("x 0", style: TextStyle(fontSize: 18, fontFamily: 'DungGeunMo')),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset("assets/images/stamp2.png", width: 60),
                              const SizedBox(width: 5),
                              const Text("x 0", style: TextStyle(fontSize: 18, fontFamily: 'DungGeunMo')),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset("assets/images/stamp3.png", width: 60),
                              const SizedBox(width: 5),
                              const Text("x 0", style: TextStyle(fontSize: 18, fontFamily: 'DungGeunMo')),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // 두 번째 줄
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/images/stamp4.png", width: 60),
                              const SizedBox(width: 5),
                              const Text("x 0", style: TextStyle(fontSize: 18, fontFamily: 'DungGeunMo')),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Row(
                            children: [
                              Image.asset("assets/images/stamp5.png", width: 60),
                              const SizedBox(width: 5),
                              const Text("x 0", style: TextStyle(fontSize: 18, fontFamily: 'DungGeunMo')),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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