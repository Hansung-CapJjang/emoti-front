import 'package:flutter/material.dart';

class StampBoard extends StatefulWidget {
  const StampBoard({super.key});

  @override
  _StampBoardState createState() => _StampBoardState();
}

class _StampBoardState extends State<StampBoard> {
  List<bool> stampStates = List.generate(8, (index) => true); // 도장 상태를 저장하는 리스트

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE6B7),
      body: Column(
        children: [
          // 🔹 도전 중! 텍스트
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              "~~ 도전 중! ~~",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'DungGeunMo',
                color: Color(0xFF414728),
              ),
            ),
          ),

          // 🔹 도장판 UI
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 🔹 도장판 박스
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EFC7),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFF798063), width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (rowIndex) => 
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (colIndex) {
                            int index = rowIndex * 4 + colIndex;
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
                                if (stampStates[index])
                                  Image.asset(
                                    "assets/images/stamp${(index % 5) + 1}.png",
                                    width: 35,
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
      // 🔹 좌측 화살표 (더 정교한 위치 조정 가능)
Transform.translate(
  offset: const Offset(-155, 0), // ✅ (X축, Y축) 조정 가능
  child: Icon(
    Icons.chevron_left,
    color: Colors.black.withOpacity(0.27), // ✅ 27% 불투명도 적용
    size: 50,
  ),
),

// 🔹 우측 화살표 (더 정교한 위치 조정 가능)
Transform.translate(
  offset: const Offset(155, 0), // ✅ (X축, Y축) 조정 가능
  child: const Icon(
    Icons.chevron_right,
    color: Colors.black, // ✅ 완전 검은색 적용
    size: 50,
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
      // 도장 도감 텍스트 (위치 조정 가능)
      Transform.translate(
        offset: const Offset(80, 10), // ✅ 왼쪽으로 5만큼 이동
        child: const Text(
          "도장 도감",
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'DungGeunMo',
            color: Color(0xFF414728),
          ),
        ),
      ),

      const SizedBox(width: 1.5), // ✅ 간격 조정 가능

      // 아이콘 (위치 조정 가능)
      Transform.translate(
        offset: const Offset(85, 10), // ✅ 오른쪽으로 5만큼 이동
        child: const Icon(
          Icons.info_outline,
          size: 20,
          color: Color(0xFF798063),
        ),
      ),
    ],
  ),
),

          // 🔹 구분선
         Padding(
  padding: const EdgeInsets.symmetric(vertical: 10),
  child: Align(
    alignment: Alignment.center, // ✅ 중앙 정렬
    child: Transform.translate(
      offset: const Offset(0, 27), // ✅ 여기서 x, y 값 조정 가능
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 2,
        color: const Color.fromRGBO(78, 87, 44, 0.35),
      ),
    ),
  ),
),

const SizedBox(height: 10,),

          // 🔹 내 도장 텍스트
          Padding(
  padding: const EdgeInsets.only(bottom: 10),
  child: Align(
    alignment: Alignment.center, // ✅ 기본 중앙 정렬
    child: Transform.translate(
      offset: const Offset(-105, 35), // ✅ x, y 값 조정 가능 (예: Offset(0, -5) → 위로 이동)
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


          // 🔹 내 도장 리스트
          Padding(
  padding: const EdgeInsets.only(bottom: 20),
  child: Align(
    alignment: Alignment.center, // 기본 중앙 정렬
    child: Transform.translate(
      offset: const Offset(0, 40), // x, y 값 조정 가능
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85, // 컨테이너 너비 조정
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFE9EFC7),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF798063), width: 2),
        ),
        child: Column(
          children: [
            // 첫 번째 줄 (🔥, ⭐, 🌱)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 간격 조절
              children: [
                Row(
                  children: [
                    Image.asset("assets/images/stamp1.png", width: 60), // 🔥 이미지 크기 줄임
                    const SizedBox(width: 5),
                    const Text("x 0", style: TextStyle(fontSize: 18, fontFamily: 'DungGeunMo')),
                  ],
                ),
                Row(
                  children: [
                    Image.asset("assets/images/stamp2.png", width: 60), // ⭐
                    const SizedBox(width: 5),
                    const Text("x 0", style: TextStyle(fontSize: 18, fontFamily: 'DungGeunMo')),
                  ],
                ),
                Row(
                  children: [
                    Image.asset("assets/images/stamp3.png", width: 60), // 🌱
                    const SizedBox(width: 5),
                    const Text("x 0", style: TextStyle(fontSize: 18, fontFamily: 'DungGeunMo')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 두 번째 줄 (⚔, 🩹)
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
              children: [
                Row(
                  children: [
                    Image.asset("assets/images/stamp4.png", width: 60), // ⚔
                    const SizedBox(width: 5),
                    const Text("x 0", style: TextStyle(fontSize: 18, fontFamily: 'DungGeunMo')),
                  ],
                ),
                const SizedBox(width: 20), // 두 번째 줄 아이템 간격 조정
                Row(
                  children: [
                    Image.asset("assets/images/stamp5.png", width: 60), // 🩹
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