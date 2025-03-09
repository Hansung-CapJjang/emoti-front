import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'firstIntro.dart';
import 'concernInput.dart';

class GenderInputScreen extends StatefulWidget {
  const GenderInputScreen({super.key});

  @override
  _GenderInputScreenState createState() => _GenderInputScreenState();
}

class _GenderInputScreenState extends State<GenderInputScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E7C0), // ����
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
            /// ? ProgressBar�� ���ǵǾ� �ִ��� Ȯ�� �� ���
            ProgressBar(progress: 0.5), // ? Progress Bar (50%)
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
            GenderButton(label: '남성', onTap: () => _goToNextScreen(context)),
            const SizedBox(height: 15),
            GenderButton(label: '여성', onTap: () => _goToNextScreen(context)),
            const SizedBox(height: 15),
            GenderButton(label: '기타', onTap: () => _goToNextScreen(context)),

            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  void _goToNextScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConcernInputScreen()),
    );
  }
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
