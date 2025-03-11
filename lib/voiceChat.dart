import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VoiceChatScreen extends StatefulWidget {
  final String counselorType; // 상담사 유형

  const VoiceChatScreen({super.key, required this.counselorType});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  bool isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 237, 127),
      appBar: AppBar(
        automaticallyImplyLeading: false, // 앱바 뒤로가기 아이콘 삭제
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '(${widget.counselorType}) ',
                style: const TextStyle(
                  fontFamily: 'DungGeunMo',
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(
                text: '상담 중',
                style: TextStyle(
                  fontFamily: 'DungGeunMo',
                  fontSize: 18,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Divider(color: Colors.black45, thickness: 0.5),
          const SizedBox(height: 10),
          const Text(
            '※ 음성 상담 내용은 저장되지 않아요.',
            style: TextStyle(
              fontFamily: 'DungGeunMo',
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                'assets/waveform.svg', // 음성 인식 시각 효과 (SVG 파일 필요)
                width: 250,
                height: 150,
                colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.srcIn),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isListening = !isListening;
              });
            },
            child: Column(
              children: [
                Icon(
                  Icons.mic,
                  size: 60,
                  color: isListening ? Colors.red : Colors.black45,
                ),
                const SizedBox(height: 10),
                const Text(
                  '마이크를 누른 상태로 말하세요.',
                  style: TextStyle(
                    fontFamily: 'DungGeunMo',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 상담 종료 시 이전 화면으로 이동
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C7448),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                '상담 끝내기',
                style: TextStyle(
                  fontFamily: 'DungGeunMo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}