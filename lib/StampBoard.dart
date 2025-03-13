import 'package:flutter/material.dart';

class StampBoardPage extends StatelessWidget {
  const StampBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE6B7),
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildChallengeTitle(),
            const SizedBox(height: 20),
            _buildStampBoard(),
            const SizedBox(height: 15),
            _buildStampCollectionInfo(context),
            const SizedBox(height: 20),
            _buildMyStamps(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  /// ? **앱바 (HomeScreen과 동일)**
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Text(
                            '펫',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DungGeunMo',
                              color: const Color.fromRGBO(78, 87, 44, 0.25),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 25),
                    Column(
                      children: [
                        Text(
                          '도장판',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DungGeunMo',
                            color: const Color(0xFF414728),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 6,
                          width: 70,
                          color: const Color.fromRGBO(5, 5, 2, 0.35),
                        ),
                      ],
                    ),
                  ],
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
    );
  }

  /// ? **도전 중! 텍스트**
  Widget _buildChallengeTitle() {
    return const Text(
      "~~ 도전 중! ~~",
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        fontFamily: 'DungGeunMo',
      ),
    );
  }

  /// ? **도장판 UI**
  Widget _buildStampBoard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => _buildStamp()),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => _buildStamp()),
          ),
        ],
      ),
    );
  }

  /// ? **도장판 도감 (정보 버튼 포함)**
  Widget _buildStampCollectionInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '도장 도감',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'DungGeunMo',
          ),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            _showPopupDialog(context);
          },
          child: const Icon(Icons.info_outline, size: 22),
        ),
      ],
    );
  }

  /// ? **내 도장 UI**
  Widget _buildMyStamps() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            '내 도장',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'DungGeunMo',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStampIcon("?", 0),
              _buildStampIcon("?", 0),
              _buildStampIcon("?", 0),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStampIcon("??", 0),
              _buildStampIcon("?", 0),
            ],
          ),
        ],
      ),
    );
  }

  /// ? **도장 아이콘 (도장판에 있는 빈 원)**
  Widget _buildStamp() {
    return Container(
      margin: const EdgeInsets.all(5),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF9FA77D),
        shape: BoxShape.circle,
      ),
    );
  }

  /// ? **내 도장 아이콘 + 개수**
  Widget _buildStampIcon(String emoji, int count) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 28),
        ),
        Text(
          "x $count",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// ? **팝업 다이얼로그 (도장 도감 정보)**
  void _showPopupDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '도장 도감 설명',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DungGeunMo',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '도장을 모아보세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ? **하단 네비게이션 바 (HomeScreen과 동일)**
  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromRGBO(171, 177, 148, 0.45),
      selectedItemColor: Colors.white,
      unselectedItemColor: const Color(0xFF474C34),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: 1, // 도장판 페이지 (홈은 0)
      onTap: (index) {
        if (index == 0) {
          Navigator.pop(context);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: '상담'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
      ],
    );
  }
}