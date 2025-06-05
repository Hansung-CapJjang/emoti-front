import 'package:flutter/material.dart';
import 'provider/user_provider.dart';
import 'package:provider/provider.dart';

class StampBoard extends StatefulWidget {
  const StampBoard({super.key});

  @override
  _StampBoardState createState() => _StampBoardState();
}

class _StampBoardState extends State<StampBoard> {
  List<int> stampCounts = [1, 3, 5, 8];
  PageController? _pageController;
  int currentLevel = 1;
  int currentShowLevel = 1;
  List<String> userStamps = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  void _nextLevel() {
    if (currentShowLevel < stampCounts.length - 1) {
      _pageController?.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _prevLevel() {
    if (currentShowLevel > 0) {
      _pageController?.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _loadUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      currentLevel = userProvider.level;
      currentShowLevel = userProvider.level;
      userStamps = userProvider.stamp;
      _pageController = PageController(initialPage: currentShowLevel - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EBD9),
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
                  child: _pageController == null
                    ? const Center(child: CircularProgressIndicator())
                    :PageView.builder(
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

                      int startIdx = index == 0 ? 0 : stampCounts.sublist(0, index).reduce((a, b) => a + b);

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
                                  int absoluteIndex = startIdx + stampIndex;
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
                                      if (absoluteIndex < userStamps.length)
                                        Image.asset(
                                          _getStampImageAsset(userStamps[absoluteIndex]),
                                          width: 70,
                                        )
                                      else
                                        const SizedBox(width: 70, height: 70),
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
            padding: const EdgeInsets.only(top: 10, right: 70),
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "도장 도감",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'DungGeunMo',
                      color: Color(0xFF414728),
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
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
                ],
              ),
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
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.075),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "내 도장",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DungGeunMo',
                        color: Color(0xFF414728),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // 내 도장 리스트
          FutureBuilder<Map<String, int>>(
            future: (() async {
              final List<String> stamps = Provider.of<UserProvider>(context, listen: false).stamp;
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
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.transparent, 
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8, 
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), 
            border: Border.all(color: Colors.black, width: 2), 
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
                  fontFamily: 'DungGeunMo',
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
            ],
          ),
        ),
      );
    },
  );
}

String _getStampImageAsset(String stampName) {
  switch (stampName) {
    case '희망':
      return 'assets/images/hopestamp.png';
    case '용기':
      return 'assets/images/couragestamp.png';
    case '결단':
      return 'assets/images/determinationstamp.png';
    case '성찰':
      return 'assets/images/reflectionstamp.png';
    case '회복':
      return 'assets/images/recoverystamp.png';
    default:
      return '';
  }
}