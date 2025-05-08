import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'user_provider.dart'; // ← 경로 확인

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
  late FlutterTts _flutterTts;
  Timer? _timer;
  int _elapsedSeconds = 0;
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _configureTTS();
    _startTimer();
    _fetchInitialBotMessage(); // 첫 메시지 API 호출
  }

  void _showConfirmEndDialog() {
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
                '상담을 종료하시겠습니까?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'DungGeunMo'),
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
                    child: const Text("아니오", style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo')),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext); // 확인 팝업 닫기
                      _showEndDialog();             // 도장 팝업 띄우기
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF798063),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                    child: const Text("예", style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo')),
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


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _configureTTS() async {
    await _flutterTts.setLanguage("ko-KR");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    _flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  void _speakMessage(String message) async {
    setState(() => isSpeaking = true);
    await _flutterTts.speak(message);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _elapsedSeconds++);
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

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

  void _stopListening() {
    _speech.stop();
    setState(() => isListening = false);
    if (recognizedText.isNotEmpty) {
      _sendMessage(recognizedText);
    }
  }

  String _generateSystemPrompt(String counselorType, String name, String gender, String concern) {
    switch (counselorType) {
      case '공감형':
        return "$gender $name 님의 고민은 '$concern' 입니다. 상담사가 먼저 $name 님의 이름을 부르며 따뜻하고 공감적인 태도로 라포를 형성하고, 고민을 부드럽게 유도하는 말투로 시작하세요.";
      case '조언형':
        return "$gender $name 님의 고민은 '$concern' 입니다. 상담사가 먼저 $name 님의 이름을 부르며 솔직하고 직설적인 어투로 현실적인 조언을 시작하세요.";
      case '유머러스형':
        return "$gender $name 님의 고민은 '$concern' 입니다. 상담사가 먼저 $name 님의 이름을 부르며 유쾌하고 농담 섞인 말투로 고민을 편하게 유도하세요.";
      default:
        return "$gender $name 님의 고민은 '$concern' 입니다. 상담사가 친절하고 공감적인 태도로 대화를 시작하세요.";
    }
  }

  Future<String> _fetchGPTResponse(String userMessage) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userName = userProvider.nickname;
    final userGender = userProvider.gender;
    final userConcern = userProvider.concerns.isNotEmpty ? userProvider.concerns.first : "없음";

    final systemPrompt = _generateSystemPrompt(widget.counselorType, userName, userGender, userConcern);

    const apiKey = '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';
    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        ..._messages.map((m) => {
          'role': m['isUser'] ? 'user' : 'assistant',
          'content': m['text'],
        }),
        {'role': 'user', 'content': userMessage},
      ],
    });

    final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decoded);

      final reply = data['choices'][0]['message']['content'];
      return reply.trim();
    } else {
      throw Exception('API 호출 실패: ${response.statusCode}');
    }
  }

  void _fetchInitialBotMessage() async {
    final reply = await _fetchGPTResponse("상담을 시작해 주세요.");
    setState(() {
      _messages.add({'text': reply, 'isUser': false});
    });
    _speakMessage(reply);
  }

  void _sendMessage(String text) async {
    setState(() {
      _messages.add({'text': text, 'isUser': true});
    });

    final reply = await _fetchGPTResponse(text);
    setState(() {
      _messages.add({'text': reply, 'isUser': false});
    });
    _speakMessage(reply);
  }

  Future<String> _evaluateFinalStampWithGPT() async {
    const apiKey = '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';
    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final analysisPrompt =
        '너는 심리 상담 대화 분석가야. 이 대화를 보고 사용자에게 줄 감정 도장을 결정해. 희망, 용기, 결단, 성찰, 회복 중 하나만 정확히 답해. 다른 설명 없이 단어 하나로만 답해.';

    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': analysisPrompt},
        ..._messages.map((m) => {
          'role': m['isUser'] ? 'user' : 'assistant',
          'content': m['text'],
        }),
        {'role': 'user', 'content': '이 대화에서 사용자에게 부여할 감정 도장은 무엇입니까? 희망, 용기, 결단, 성찰, 회복 중 하나로만 답해.'},
      ],
    });

    final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decoded);
      final reply = data['choices'][0]['message']['content'].trim();
      return reply;
    } else {
      throw Exception('API 호출 실패: ${response.statusCode}');
    }
  }

  void _showEndDialog() async {
    final resultStamp = await _evaluateFinalStampWithGPT();

    Provider.of<UserProvider>(context, listen: false)
        .updateStamp([...Provider.of<UserProvider>(context, listen: false).stamp, resultStamp]);

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
                const Text('🎉 상담이 종료되었습니다!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'DungGeunMo')),
                const SizedBox(height: 16),
                Text('이번 상담에서 받은 도장: [$resultStamp]',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontFamily: 'DungGeunMo')),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF798063),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.black, width: 1.5),
                    ),
                  ),
                  child: const Text("닫기", style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EBD9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(), // ← 뒤로가기 버튼 제거
        title: Column(
          children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '(${widget.counselorType}) ',
                    style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 20, color: Colors.black)),
                const TextSpan(
                    text: '상담 중 ',
                    style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 20, color: Colors.blue)),
                TextSpan(
                    text: _formatTime(_elapsedSeconds),
                    style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 23, color: Colors.red)),
              ]),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Divider(color: Colors.black45, thickness: 0.5, indent: 20, endIndent: 20),
          const SizedBox(height: 10),
          const Text('※ 음성 상담 내용은 저장되지 않아요.',
              style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 40),
          Expanded(
            child: SvgPicture.asset(
              'assets/images/waveformicon.svg',
              width: 250,
              height: 150,
              colorFilter: ColorFilter.mode(
                  isListening
                      ? Colors.red
                      : isSpeaking
                          ? const Color.fromARGB(255, 107, 163, 16)
                          : Colors.black45,
                  BlendMode.srcIn),
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
                Icon(Icons.mic, size: 60, color: isListening ? Colors.red : const Color.fromARGB(175, 0, 0, 0)),
                const SizedBox(height: 10),
                Text(isListening ? '음성 인식 중...' : '마이크를 누르면 시작됩니다.',
                    style: const TextStyle(fontFamily: 'DungGeunMo', fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: _showConfirmEndDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C7448),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('상담 끝내기',
                  style: TextStyle(fontFamily: 'DungGeunMo', fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}