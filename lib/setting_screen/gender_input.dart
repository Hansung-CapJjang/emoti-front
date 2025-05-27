import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'first_intro.dart';
import 'concern_input.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/provider/user_provider.dart';

class GenderInputScreen extends StatefulWidget {
  const GenderInputScreen({super.key});

  @override
  _GenderInputScreenState createState() => _GenderInputScreenState();
}

class _GenderInputScreenState extends State<GenderInputScreen> {
  Future<void> _selectGenderAndProceed(String gender) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.updateGender(gender);

    await _sendDataToServer(userProvider.nickname, gender);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConcernInputScreen(isEdit: false),
      ),
    );
  }

  Future<void> _sendDataToServer(String name, String gender) async {
    const String apiUrl = ''; // TODO: 여기에 실제 API 주소 입력

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "gender": gender}),
      );

      if (response.statusCode == 200) {
        print("✅ 사용자 정보 저장 완료!");
      } else {
        print("❗ 서버 오류: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("❗ 네트워크 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EBD9),
      appBar: AppBar(
        title: const Text(
          '세부 정보',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontFamily: 'DungGeunMo',
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProgressBar(progress: 0.5),
            const SizedBox(height: 30),
            const Text(
              '성별을 선택 해주세요.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'DungGeunMo',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              '※ 더 정확한 상담이 가능해져요.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                fontFamily: 'DungGeunMo',
                color: Colors.black87,
              ),
            ),
            const Spacer(flex: 10),
            const SizedBox(height: 30),
            GenderButton(label: '남성', onTap: () => _selectGenderAndProceed('남성')),
            const SizedBox(height: 15),
            GenderButton(label: '여성', onTap: () => _selectGenderAndProceed('여성')),
            const SizedBox(height: 15),
            GenderButton(label: '기타', onTap: () => _selectGenderAndProceed('기타')),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

class GenderButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const GenderButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 167, 177, 115),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.normal,
          fontFamily: 'DungGeunMo',
        ),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(label),
    );
  }
}
