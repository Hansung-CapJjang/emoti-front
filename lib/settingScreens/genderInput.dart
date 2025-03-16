import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'firstIntro.dart';
import 'concernInput.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/userProvider.dart';
import 'package:flutter_application_1/main.dart';

class GenderInputScreen extends StatefulWidget {
  const GenderInputScreen({super.key});

  @override
  _GenderInputScreenState createState() => _GenderInputScreenState();
}

class _GenderInputScreenState extends State<GenderInputScreen> {

// 성별 정보 저장하고 고민 세부 사항 설정 페이지로 이동
void _selectGenderAndProceed(String gender) { // async {
    // await _sendDataToServer(context.watch<UserProvider>().nickname, gender); // 서버로 이름 + 성별 저장
    // ConcernInputScreen으로 이동할 때 name과 gender 함께 전달
    Provider.of<UserProvider>(navigatorKey.currentContext!, listen: false).updateGender(gender);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConcernInputScreen(isEdit: false),
      ),
    );
  }

  Future<void> _sendDataToServer(String name, String gender) async {
    const String apiUrl = ''; // 

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "gender": gender}), // 🔹 JSON으로 전송
      );

      if (response.statusCode == 200) {
        print("사용자 정보 저장 완료!");
      } else {
        print("서버 오류: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("네트워크 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E7C0), 
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
            ProgressBar(progress: 0.5), // Progress Bar (50%)
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

            //
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

  // void _goToNextScreen(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const ConcernInputScreen()),
  //   );
  // }
}

// 
class GenderButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap; // 

  const GenderButton({super.key, required this.label, required this.onTap}); // onTap 

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap, 
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 167, 177, 115), // ��ư ���� (�ø����)
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
