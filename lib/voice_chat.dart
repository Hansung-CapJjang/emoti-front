import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart'; // 🔹 TTS 추가
import 'chatting_setting.dart';

class VoiceChatScreen extends StatefulWidget {
  final String counselorType;

  const VoiceChatScreen({super.key, required this.counselorType});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  bool isListening = false;
  bool isSpeaking = false;
  String recognizedText = ""; 
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts; // 🔹 TTS 인스턴스 추가
  Timer? _timer;
  int _elapsedSeconds = 0;

  final List<String> _defaultResponses = [ // 🔹 기본 말뭉치
    "홍세린님 지금 뭐하시는 거예요?",
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
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  /// 🔹 AI 음성 출력 + 상태 업데이트
  void _speakMessage(String message) async {
    setState(() {
      isSpeaking = true;
    });
    await _flutterTts.speak(message);
  }

  /// 🔹 초기 상담 메시지 음성 출력
  void _speakInitialMessage() async {
    final random = Random();
    String message = _defaultResponses[random.nextInt(_defaultResponses.length)];
    _speakMessage(message);
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
                    text: '상담 중 ',
                    style: TextStyle(
                      fontFamily: 'DungGeunMo',
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                  text: _formatTime(_elapsedSeconds),
                  style: const TextStyle(
                    fontFamily: 'DungGeunMo',
                    fontSize: 23,
                    color: Colors.red,
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
                
                const SizedBox(height: 30),
                SvgPicture.asset(
                  'assets/images/waveformicon.svg',
                  width: 250,
                  height: 150,
                  colorFilter: ColorFilter.mode(
                    isListening ? Colors.red : isSpeaking ? const Color.fromARGB(255, 107, 163, 16) : Colors.black45,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          // 사용자 목소리가 텍스트로 변환되어 화면에 나타나는 기능
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Container(
          //     padding: const EdgeInsets.all(16),
          //     decoration: BoxDecoration(
          //       color: const Color.fromARGB(255, 247, 255, 206),
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: Text(
          //       recognizedText.isEmpty ? "음성을 인식하면 여기에 표시됩니다." : recognizedText,
          //       style: const TextStyle(
          //         fontFamily: 'DungGeunMo',
          //         fontSize: 16,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
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
                  color: isListening ? Colors.red : const Color.fromARGB(175, 0, 0, 0),
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
  Future.delayed(Duration(milliseconds: 100), () { // 약간의 딜레이 후 실행
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
                  '상담을 종료하시겠습니까?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DungGeunMo',
                  ),
                ),
                const SizedBox(height: 20), // 질문과 버튼 간격 증가
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
                    const SizedBox(width: 12), // 버튼 간격 좁힘
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        Navigator.pop(context);
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
  });
}