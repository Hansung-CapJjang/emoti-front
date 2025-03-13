import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE5B6),
      appBar: AppBar(
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
          const SizedBox(height: 40), // 간격 추가
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/character_1.png',
                  width: 100, // 기존 CircleAvatar 반지름 * 2
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'nickname',
                          style: TextStyle(
                            fontFamily: 'DungGeunMo',
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18, color: Colors.black54),
                          onPressed: () {},
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
          const SizedBox(height: 50), // 간격 추가
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lv.1   60%',
                  style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.6,
                    minHeight: 8,
                    backgroundColor: Colors.black12,
                    color: Colors.green[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildExpandableMenuItem(),
                if (isExpanded) _buildSelectedConcerns(),
                _buildToggleMenuItem('알람 설정'),
                _buildMenuItem(Icons.logout, '로그아웃'),
                _buildDisabledMenuItem('회원 탈퇴'),
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
              onPressed: () {},
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _buildConcernChip('좁은 인간 관계'),
          _buildConcernChip('친구'),
          _buildConcernChip('학교 성적'),
          _buildConcernChip('취업 및 진로'),
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

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40, right: 20),
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 16)),
      onTap: () {},
    );
  }

  Widget _buildToggleMenuItem(String title) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40, right: 40),
      title: Text(title, style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 16)),
      trailing: Switch(
        value: isOn,
        onChanged: (value) {
          setState(() {
            isOn = value;
          });
        },
        activeColor: const Color(0xFF5A6140),
        activeTrackColor: const Color(0xFF959D75),
        inactiveThumbColor: const Color(0xFFDCE6B7),
        inactiveTrackColor: const Color(0xFF959D75),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  Widget _buildDisabledMenuItem(String title) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40, right: 20),
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 16, color: Colors.black38),
      ),
    );
  }
}