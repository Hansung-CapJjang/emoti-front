import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/setting_screen/concern_input.dart';
import 'package:flutter_application_1/setting_screen/name_input.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/user_provider.dart';
import 'package:flutter_application_1/notification_service.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

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
  bool isOn = false;
  bool isExpanded = false;
  late NotificationService notificationService;
  List<Map<String, dynamic>> chatRecords = [];

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
  final String jsonString = await rootBundle.loadString('assets/data.json');
  final List<dynamic> jsonData = json.decode(jsonString);

  final records = jsonData.map<Map<String, dynamic>>((item) {
    final timestamp = DateTime.parse(item['timestamp']);
    final formattedDate = '${timestamp.month}/${timestamp.day}';
    final stamp = item['stamp'] ?? '희망';

    return {
      'date': formattedDate, // ✅ 이 부분이 핵심
      'stamp': stamp,
    };
  }).toList();

  setState(() {
    chatRecords = records;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE5B6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
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
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/character_1.png',
                  width: 120,
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
                            fontSize: 26,
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
                                builder: (context) => const NameInputScreen(isEdit: true),
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 18),
                      child: Text(
                        'Lv.1',
                        style: TextStyle(
                          fontFamily: 'DungGeunMo',
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          color: Color.fromARGB(255, 87, 99, 43),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(right: 18),
                      child: Text(
                        '60%',
                        style: TextStyle(
                          fontFamily: 'DungGeunMo',
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          color: Color.fromARGB(255, 87, 99, 43),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const SizedBox(
                    width: 300,
                    child: LinearProgressIndicator(
                      value: 0.6,
                      minHeight: 15,
                      backgroundColor: Color.fromARGB(136, 119, 137, 60),
                      color: Color.fromARGB(255, 66, 75, 34),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: chatRecords.length,
                itemBuilder: (context, index) {
                  final record = chatRecords[index];
                  final imageMap = {
                    '희망': 'assets/images/hopestamp.png',
                    '회복': 'assets/images/recoverystamp.png',
                    '결단': 'assets/images/determinationstamp.png',
                    '성찰': 'assets/images/reflectionstamp.png',
                    '용기': 'assets/images/couragestamp.png',
                  };
                  final imagePath = imageMap[record['stamp']] ?? 'assets/images/hopestamp.png';
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 246, 250, 222),
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
                        Text(record['date'], style: const TextStyle(fontFamily: "DungGeunMo", fontSize: 18, color: Color.fromARGB(255, 73, 76, 57))),
                        Image.asset(imagePath, width: 30, height: 30),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(indent: 30, endIndent: 30, thickness: 2, color: Color.fromARGB(100, 121, 138, 61)),
          Expanded(
            child: ListView(
              children: [
                _buildExpandableMenuItem(),
                if (isExpanded) _buildSelectedConcerns(),
                if (isOn)
                  _buildToggleMenuItem('알람 설정', Icons.notifications_active)
                else
                  _buildToggleMenuItem('알람 설정', Icons.notifications_off),
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

  Widget _buildSelectedConcerns() {
    final concerns = Provider.of<UserProvider>(context).concerns;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          ...concerns.map((concern) => _buildConcernChip(concern)),
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
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 16),
      ),
      trailing: Switch(
        value: isOn,
        onChanged: (value) {
          setState(() {
            isOn = value;
            notificationService.initialize();
            notificationService.scheduleNotification(isOn);
          });
        },
        activeColor: const Color.fromARGB(255, 71, 75, 51),
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
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        foregroundColor: Colors.black,
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
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF798063),
                        foregroundColor: Colors.white,
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