import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/setting_screen/concern_input.dart';
import 'package:flutter_application_1/setting_screen/name_input.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/user_provider.dart';
import 'package:flutter_application_1/notification_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isOn = false; // 알람 설정 상태
  bool isExpanded = false; // 고민 사항 확장 여부
  late NotificationService notificationService;

  // 더미 도장 데이터 (날짜, 도장 유형)
  final List<Map<String, dynamic>> stampData = [
    {'date': 'Sun', 'stamp': 'X'},
    {'date': 'Mon', 'stamp': '⭐️'},
    {'date': 'Tue', 'stamp': 'x'},
    {'date': 'Wed', 'stamp': '🌱'},
    {'date': 'Thu', 'stamp': '🔥'},
    {'date': 'Fri', 'stamp': '🌱'},
    {'date': 'Sat', 'stamp': '?'},
  ];

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE5B6),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent, // 색이 변하지 않음
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '마이 페이지',
          style: TextStyle(
            fontFamily: 'DungGeunMo',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20), // 간격 추가
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/character_1.png',
                  width: 120, // 기존 CircleAvatar 반지름 * 2
                  height: 120,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          Provider.of<UserProvider>(context).nickname,
                          style: const TextStyle(
                            fontFamily: 'DungGeunMo',
                            fontSize: 35,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 63, 71, 31),
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18, color: Colors.black54),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NameInputScreen(isEdit: true,),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    const Text(
                      '도장판 5/10',
                      style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 14, color: Colors.black54),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 10), // 간격 추가
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lv.1                             60%',
                  style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 17, fontWeight: FontWeight.normal, color: Color.fromARGB(255, 87, 99, 43),),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    value: 0.6,
                    minHeight: 15,
                    backgroundColor: Color.fromARGB(136, 119, 137, 60),
                    color: Color.fromARGB(255, 66, 75, 34),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 날짜별 도작 리스트 추가
          _buildStampScroll(),

          const SizedBox(height: 10),

          const Divider(indent: 30, endIndent: 30, thickness: 2, color: Color.fromARGB(100, 121, 138, 61),),

          // const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildExpandableMenuItem(),
                
                if (isExpanded) _buildSelectedConcerns(),
                if (isOn) _buildToggleMenuItem('알람 설정', Icons.notifications_active) else _buildToggleMenuItem('알람 설정', Icons.notifications_off),
                _buildLogoutItem(Icons.logout, '로그아웃'),
                _buildDeleteItem('회원 탈퇴'),
              ],
            ),
          ),
          
        ],
      ),
      
    );
  }

  Widget _buildExpandableMenuItem() {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40, right: 20),
      leading: Icon(
        isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
        color: Colors.black54,
      ),
      title: Row(
        children: [
          const Text('고민 사항', style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 16)),
          if (isExpanded) ...[
            const SizedBox(width: 5),
            IconButton(
              icon: const Icon(Icons.edit, size: 18, color: Colors.black54),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConcernInputScreen(isEdit: true),
                  ),
                );
              },
            ),
          ],
        ],
      ),
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
    );
  }

  // 날짜별 도장 가로 스크롤
  Widget _buildStampScroll() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Stack(
      children: [
        SizedBox(
          height: 70,
          
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: stampData.length,
            itemBuilder: (context, index) {
              return _buildStampItem(stampData[index]['date'], stampData[index]['stamp']);
            },
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFDDE5B6),
                    Color(0xFFDDE5B6).withOpacity(0),
                    Color(0xFFDDE5B6).withOpacity(0),
                    Color(0xFFDDE5B6),
                  ],
                  stops: [0.0, 0.2, 0.8, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  // 개별 도장 아이템
  Widget _buildStampItem(String date, String stamp) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 246, 250, 222),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
            
          ),
          
        ],
      ),
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(date, style: const TextStyle(fontFamily: "DungGeunMo", fontSize: 18, fontWeight: FontWeight.normal, color: Color.fromARGB(255, 73, 76, 57),)),
          Text(stamp, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 73, 76, 57),)),
        ],
      ),
    );
    
  }


  Widget _buildSelectedConcerns() {
    final concerns = Provider.of<UserProvider>(context).concerns; // concerns 리스트 가져오기
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
         ...concerns.map((concern) => _buildConcernChip(concern)), // 리스트에 있는 값만 Chip으로 생성
        ],
      ),
    );
  }

  Widget _buildConcernChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 14, color: Colors.black),
      ),
    );
  }

  Widget _buildLogoutItem(IconData icon, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40, right: 20),
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 16)),
      onTap: () {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
      },
    );
  }

  Widget _buildToggleMenuItem(String title, IconData icon) {
  return ListTile(
    contentPadding: const EdgeInsets.only(left: 40, right: 40),
    leading: Icon(icon, color: Colors.black54), // 알림 아이콘 추가
    title: Text(
      title, 
      style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 16),
    ),
    trailing: Switch(
      value: isOn,
      onChanged: (value) {
        setState(() {
          isOn = value;
          notificationService.initialize(); // 알림 권한 요청
          notificationService.scheduleNotification(isOn);
        });
      },
      activeColor:  Color.fromARGB(255, 71, 75, 51),
      activeTrackColor: const Color(0xFF959D75),
      inactiveThumbColor: const Color(0xFFDCE6B7),
      inactiveTrackColor: const Color(0xFF959D75),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
  );
}


  Widget _buildDeleteItem(String title) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40, right: 20),
      title: Text(title, style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 16, color: Colors.grey)),
      onTap: () {
        _showConfirmDialog(context);
      },
    );
  }

  void _showConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // 팝업 바깥 클릭 시 닫기
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.transparent, // 배경 투명 처리
        contentPadding: EdgeInsets.zero, // 기본 패딩 제거
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 팝업 크기 조정
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16), // 내부 패딩 증가
          decoration: BoxDecoration(
            color: Colors.white, // 팝업 배경색
            borderRadius: BorderRadius.circular(10), // 모서리 둥글게
            border: Border.all(color: Colors.black, width: 2), // 검은 테두리 추가
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '정말 탈퇴하시겠습니까?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DungGeunMo',
                ),
              ),
              const SizedBox(height: 20), // 질문과 버튼 사이 간격 증가
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400], // 중립적인 색상
                      foregroundColor: Colors.black, // 글씨색
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                    child: const Text(
                      "아니오",
                      style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
                    ),
                  ),
                  const SizedBox(width: 12), // 버튼 간격 조정
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF798063), // 기존 팝업과 동일한 배경색
                      foregroundColor: Colors.white, // 글씨색
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                    child: const Text(
                      "예",
                      style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

}