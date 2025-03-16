import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart'; // 🔹 TTS 추가

class VoiceChatScreen extends StatefulWidget {
  final String counselorType;

  const VoiceChatScreen({super.key, required this.counselorType});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  bool isListening = false;
  String recognizedText = ""; 
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts; // 🔹 TTS 인스턴스 추가
  Timer? _timer;
  int _elapsedSeconds = 0;

  final List<String> _defaultResponses = [ // 🔹 기본 말뭉치
    "박한비 솔직히 바보인듯ㅋㅋ",
    "오늘 기분이 어떠신가요?",
    "편하게 이야기해주세요. 제가 듣고 있습니다.",
    "어떤 고민이 있으신가요?",
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts(); // 🔹 TTS 초기화
    _configureTTS();
    _startTimer();
    _speakInitialMessage(); // 🔹 앱 시작 시 첫 음성 출력
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// 🔹 TTS 설정
  void _configureTTS() async {
    await _flutterTts.setLanguage("ko-KR"); // 한국어 설정
    await _flutterTts.setSpeechRate(0.5); // 속도 조절
    await _flutterTts.setVolume(1.5);
    await _flutterTts.setPitch(0.3);
  }

  /// 🔹 초기 상담 메시지 음성 출력
  void _speakInitialMessage() async {
    final random = Random();
    String message = _defaultResponses[random.nextInt(_defaultResponses.length)];
    await _flutterTts.speak(message);
  }

  /// 타이머 시작
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  /// 경과 시간을 "MM:SS" 형식으로 변환
  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  /// 음성 인식 시작
  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        isListening = true;
        recognizedText = "";
      });
      _speech.listen(
        onResult: (result) {
          setState(() {
            recognizedText = result.recognizedWords;
          });
        },
        localeId: "ko_KR",
      );
    }
  }

  /// 음성 인식 중지
  void _stopListening() {
    _speech.stop();
    setState(() {
      isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE6B7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '(${widget.counselorType}) ',
                    style: const TextStyle(
                      fontFamily: 'DungGeunMo',
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const TextSpan(
                    text: '상담 중',
                    style: TextStyle(
                      fontFamily: 'DungGeunMo',
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Divider(color: Colors.black45, thickness: 0.5, indent: 20, endIndent: 20),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatTime(_elapsedSeconds),
                  style: const TextStyle(
                    fontFamily: 'DungGeunMo',
                    fontSize: 25,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 30),
                SvgPicture.asset(
                  'assets/images/waveformicon.svg',
                  width: 250,
                  height: 150,
                  colorFilter: ColorFilter.mode(
                    isListening ? Colors.red : Colors.black45,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 227, 246, 132),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                recognizedText.isEmpty ? "음성을 인식하면 여기에 표시됩니다.\n실제 기기에서만 작동합니다." : recognizedText,
                style: const TextStyle(
                  fontFamily: 'DungGeunMo',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 80),
          GestureDetector(
            onTap: () {
              if (isListening) {
                _stopListening();
              } else {
                _startListening();
              }
            },
            child: Column(
              children: [
                Icon(
                  Icons.mic,
                  size: 60,
                  color: isListening ? Colors.red : Colors.black45,
                ),
                const SizedBox(height: 10),
                Text(
                  isListening ? '음성 인식 중...' : '마이크를 누르면 시작됩니다.',
                  style: const TextStyle(
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
                _showEndDialog(context);
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

/// 상담 종료 다이얼로그
void _showEndDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("상담을 종료하시겠습니까?", style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 18),),
        // content: const Text("상담을 종료하시겠습니까?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
            },
            child: const Text("아니오", style: TextStyle(fontFamily: 'DungGeunMo',),),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context); // 서랍 닫기 (상담 종료 처리)
            },
            child: const Text("예", style: TextStyle(fontFamily: 'DungGeunMo',),),
          ),
        ],
      );
    },
  );
}