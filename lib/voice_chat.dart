import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '/dto/message_dto.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dto/user_dto.dart';
import 'provider/user_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
const llamaApiUrl = 'https://emoti.ngrok.app/generate';
const pollyUrl = 'https://www.emoti.kr/tts';

class VoiceChatScreen extends StatefulWidget {
  final String counselorType;

  const VoiceChatScreen({super.key, required this.counselorType});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {

  bool isListening = false;
  bool isSpeaking = false;
  bool _isLoading = false;
  String recognizedText = "";
  late stt.SpeechToText _speech;
  bool _speechAvailable = false;
  Timer? _timer;
  int _elapsedSeconds = 0;
  List<MessageDTO> _messages = [];
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); 
    _speech = stt.SpeechToText();
    _startTimer();
    _initializeSpeech();
    Future.delayed(const Duration(seconds: 0), () async {
      await _fetchInitialBotMessage();
    });
  }

  void _initializeSpeech() async {
    _speechAvailable = await _speech.initialize();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _speech.stop();
    _timer?.cancel();
    super.dispose();
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

  String preprocessForTTS(String input) {
    return input
      .replaceAll(RegExp(r'[~]+'), '   ')
      .replaceAll(RegExp(r'(ㅋ|ㅋ{2,})'), ' 크크 ')
      .replaceAll(RegExp(r'(ㅎ|ㅎ{2,})'), ' 흐흐 ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  }

  void _startListening() async {
    if (_speech.isListening || isSpeaking || !_speechAvailable) return; // 중복 방지 - 음성 출력 중에는 마이크를 켜지 못하도록
    try {
      setState(() {
        isListening = true;
        recognizedText = "";
      });
      _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            setState(() {
              recognizedText = result.recognizedWords;
              isListening = false;
            });
            _speech.stop();

            if (recognizedText.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("말씀이 인식되지 않았어요.")),
              );
              return;
            }

            final text = recognizedText.trim();
            recognizedText = ""; // 리셋
            _sendMessage(text);
          }
        },
        localeId: "ko_KR",
      );
    } catch (e) {
      setState(() => isListening = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("음성 인식 오류: $e")),
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => isListening = false);
  }

  Future<void> _speakMessage(String message) async {
    setState(() => isSpeaking = true);
    try {
      final response = await http.post(
        Uri.parse(pollyUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': message}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final url = json['url'];
        if (_audioPlayer.playing) await _audioPlayer.stop();
        if (url == null || url.toString().isEmpty) {
          throw Exception("TTS 응답에 유효한 URL이 없습니다.");
        }
        await _audioPlayer.setUrl(url);
        await _audioPlayer.seek(Duration.zero);

        await _audioPlayer.play();
      } else {
        throw Exception("TTS 서버 오류: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Polly 오류: $e')),
      );
    } finally {
      setState(() => isSpeaking = false);
    }
  }

  Future<String> _fetchLlamaReply(String userMessage) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userName = userProvider.nickname;
    final userGender = userProvider.gender;
    final userConcern = userProvider.concerns.isNotEmpty ? userProvider.concerns.first : "없음";

    final headers = {'Content-Type': 'application/json'};

    final history = _messages
        .map((m) => m.isUser ? "내담자: $m.text'" : "상담사: $m.text")
        .toList();

    final body = jsonEncode({
      'name': userName,
      'gender': userGender,
      'issue': userConcern,
      'counselor_type': widget.counselorType,
      'history': history,
      'user_message': userMessage,
    });

    final response = await http.post(Uri.parse(llamaApiUrl), headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['output'].trim();
    } else {
      throw Exception('FastAPI 호출 실패: ${response.statusCode}');
    }
  }

  Future<String> _refineWithGPT(String llamaReply, String userMessage) async {
    String _truncateToThreeSentences(String text) {
      final sentences = text.split(RegExp(r'(?<=[.!?])\s+'));
      if (sentences.length <= 3) return text;
      return sentences.take(3).join(' ');
    }

    final tone = widget.counselorType;
    final truncatedReply = _truncateToThreeSentences(llamaReply);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userConcern = userProvider.concerns.join(', ');
    final userName = userProvider.nickname;
    final userGender = userProvider.gender;

    // 기존 프롬프트 대신 상담사 스타일 prompt 생성
    final tonePrompt = _generateSystemPrompt(tone, userName, userGender, userConcern);

    final systemPrompt = '''
$tonePrompt

내담자: '$userMessage'에 대해 다음과 같이 답하려고 해: '$truncatedReply'.

이 문장이 어색하거나 맥락에 맞지 않으면 꼭 그대로 말하지 말고,
자연스럽고 진심 어린 상담사처럼 다듬어줘.

내담자가 긍정적으로 반응하면 그 고민을 이어서 상담하고,
새로운 고민이 등장하면 그에 맞게 전환해서 대화를 이어가.

질문을 자주 던지고, 상대방의 감정에 관심을 가지며 대화를 계속 이어가줘.
음성으로 사용할 텍스트를 생성할 거라 'ㅋㅋㅋ'나 'ㅎㅎ', 'ㄱㄱ' 등 초성이 필요하면 음성으로 그대로 출력 시 어색하지 않게 '크크크', '히히', '고 고' 등으로 바꿔 사용해줘. 
'~'와 같이 물결은 늘어지게 말하는 텍스트로 만들어줘. 예를 들어 '좋죠~'는 '좋죠오'와 같은 방식으로 변경해줘.
대답은 무조건 50자 내외로 대답해야 해.
''';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userMessage}
      ],
    });

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('OpenAI GPT 후처리 실패: ${response.statusCode}');
    }
  }

  // 상담 시 첫 음성
  String _generateInitialMessage(String counselorType, String name, String concern) {
    switch (counselorType) {
      case '공감형':
        return '''
'$name'님, 만나서 반가워요!
기존에 말씀해주신 고민은 '$concern' 인데요, 그 이야기부터 나눠볼까요?
아니면 요즘 더 마음 쓰이는 일이 생기셨을까요? 
편하게 얘기해주세요.
''';

      case '조언형':
        return '''
'$name'님, 안녕하세요.
말씀해주신 고민은 '$concern'이네요. 그 문제를 해결하려면 우선 정확히 짚고 넘어가야 합니다.
지금 그 이야기를 해볼까요? 
아니면 최근 더 중요한 고민이 있으신가요?
''';

      case '유머러스형':
        return '''
'$name'님, 하이하이이
'$concern'? 바로 얘기해봐요 고고고!
아니면 요즘 인생 뭐, 하드모드임? 저한테 다 쏟아내봐요
''';

      default:
        return '''
'$name'님, 안녕하세요. 기존에 말씀해주신 고민은 '$concern'입니다.
그 이야기를 이어가도 좋고, 최근에 생긴 새로운 고민이 있다면 그것부터 말씀해주셔도 좋아요.
''';
    }
  }

  String _generateSystemPrompt(String counselorType, String name, String gender, String concern) {
    switch (counselorType) {
      case '공감형':
        return '''
당신은 공감형 심리 상담사입니다.
- 말투: 따뜻하고 부드러운 말투를 사용합니다.
- 화법: 감정에 공감하는 표현을 자주 사용하고, 경청의 태도를 보여줍니다.
- 자주 쓰는 표현 예시: "그랬군요", "많이 힘드셨겠어요", "그 마음 이해돼요", "괜찮아요", "함께 해결해 나가봐요"

'$name'님은 $gender이며, 주된 고민은 '$concern' 입니다.
상담사가 먼저 '$name'님의 이름을 부르며 라포를 형성하고, 공감하는 말로 대화를 시작하세요.
''';

      case '조언형':
        return '''
당신은 조언형 심리 상담사입니다.
- 말투: 단호하고 현실적인 말투를 사용합니다.
- 화법: 문제를 직시하고 명확한 해결책을 제시하는 방식으로 말합니다.
- 자주 쓰는 표현 예시: "중요한 건 지금입니다", "이건 바꿔야 해요", "회피하면 반복됩니다", "솔직히 말씀드리자면"

'$name'님은 $gender이며, 주된 고민은 '$concern' 입니다.
상담사가 먼저 '$name'님의 이름을 부르며 솔직하고 직설적인 어투로 상담을 시작하세요.
''';

      case '유머러스형':
        return '''
당신은 유머러스한 심리 상담사입니다.
- 말투: 밝고 장난스러운 어투로 분위기를 가볍게 만듭니다. 기본은 존댓말을 사용하며, 웃음소리는 "킄크크킄크", "푸하앗"처럼 표현합니다. 존댓말 안에서도 센스 있는 표현을 섞어, 가볍지만 예의를 갖춘 대화를 이끌어갑니다.
- 화법: 우스운 비유, 유머, 감탄사, 밈 표현, 그리고 MZ세대가 즐겨 쓰는 말투를 적절히 사용합니다. 다만, **사용자가 우울하거나 슬픈 감정을 표현할 경우**에는 장난스러운 말투를 **초반에는 자제**하고, **공감과 위로를 우선**한 진정성 있는 반응을 제공합니다. 이후 분위기가 풀리면 센스 있는 유머로 자연스럽게 전환하세요.
- 자주 쓰는 표현 예시: "무야호오", "허거덩 거덩스!", "어떡하냐,,,", "GMG"

'$name' 님은 $gender이며, 주된 고민은 '$concern' 입니다.
상담사가 먼저 '$name'님의 이름을 부르며 유쾌하게 농담을 던지며 대화를 시작하세요.
''';

    default:
      return '''
당신은 친절한 상담사입니다.
'$name'님은 $gender이며, 주된 고민은 '$concern' 입니다.
상담사는 따뜻하고 공감적인 말투로 라포를 형성하며 대화를 시작하세요.
''';
    }
  }

  Future<void> _fetchInitialBotMessage() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userName = userProvider.nickname;
    final userConcerns = userProvider.concerns.join(', ');
    final initialMessage = _generateInitialMessage(widget.counselorType, userName, userConcerns);

    setState(() {
      _messages.add(MessageDTO(text: initialMessage, isUser: false));
    });
    final processed = preprocessForTTS(initialMessage);

    await _speakMessage(processed);
    }

    void _sendMessage(String text) async {

      if (_audioPlayer.playing) await _audioPlayer.stop();

      setState(() {
        _isLoading = true;
        _messages.add(MessageDTO(text: text, isUser: true));
      });

      try {
        final llamaReply = await _fetchLlamaReply(text);
        final refinedReply = await _refineWithGPT(llamaReply, text);

        setState(() {
          _messages.add(MessageDTO(text: refinedReply, isUser: false));
          _isLoading = false;
        });
        final processed = preprocessForTTS(refinedReply);
        
        await _speakMessage(processed);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('응답 오류: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
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
                          Navigator.pop(dialogContext);
                          _showFinalStampDialog();
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

  Future<String> _evaluateFinalStampWithGPT() async {

    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    const analysisPrompt =
      '너는 심리 상담 대화 분석가야. 이 대화를 보고 사용자에게 줄 감정 도장을 결정해. 희망, 용기, 결단, 성찰, 회복 중 하나만 정확히 답해. 다른 설명 없이 단어 하나로만 답해.';

    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': analysisPrompt},
        ..._messages.map((m) => {
          'role': m.isUser ? 'user' : 'assistant',
          'content': m.text,
        }),
        {'role': 'user', 'content': '이 대화에서 사용자에게 부여할 감정 도장은 무엇입니까? 희망, 용기, 결단, 성찰, 회복 중 하나로만 답하시오.'},
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

  void _showEndDialog(BuildContext context) {
    Future.delayed(Duration(milliseconds: 100), () {
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
                          _showFinalStampDialog();
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
    });
  }

  // 도장 획득 불가할 시 나타나는 팝업창
  void _showAlert(String message) {
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
                  "🚫 도장 획득 불가 🚫",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DungGeunMo',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DungGeunMo',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.black, width: 1.5),
                        ),
                      ),
                      child: const Text(
                        "취소",
                        style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
                      ),
                    ),
                    const SizedBox(width: 12),
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
                      child: const Text(
                        "확인",
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

  Future<bool> hasReceivedStampToday(String userId) async {
    final response = await http.get(
      Uri.parse('https://www.emoti.kr/chats/stamp/check?userId=$userId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) == true;
    } else {
      return false;
    }
  }

  Future<void> _saveStampOnlyChatToServer(String stamp, String userId) async {
    final response = await http.post(
      Uri.parse('https://www.emoti.kr/chats'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'counselorType': '도장',
        'stamp': stamp,
        'timestamp': DateTime.now().toUtc().add(const Duration(hours: 9)).toIso8601String(),
        'messages': [],
      }),
    );

    if (response.statusCode != 200) {
    }
  }

  Future<void> _updateUserStampToServer(UserDTO dto) async {
    final url = Uri.parse('https://www.emoti.kr/users/update/stamp');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': dto.id,
        'stamp': dto.stamp,
      }),
    );

    if (response.statusCode != 200) {
    }
  }

  void _showFinalStampDialog() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // 조건 1: 오늘 도장 이미 받았는지 확인
    if (await hasReceivedStampToday(userProvider.id)) {
      _showAlert("오늘은 이미 도장을 받았습니다.");
      return;
    }

    // 조건 2: meaningful한 대화가 이루어졌는지 확인 (예: 최소 3개 이상)
    final messageCount = _messages.where((m) => m.text != '작성 중...').length;
    if (messageCount < 6) {
      _showAlert("상담 내용이 너무 짧아서\n도장을 받을 수 없어요.\n그래도 종료하실 건가요?");
      return;
    }

    try {
      final resultStamp = await _evaluateFinalStampWithGPT();

      userProvider.addStamp(resultStamp);
      final dto = UserDTO(
        id: userProvider.id,
        stamp: userProvider.stamp,
      );

      await _saveStampOnlyChatToServer(resultStamp, userProvider.id);
      await _updateUserStampToServer(dto);

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
                    '🎉 상담이 종료되었습니다!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'DungGeunMo'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '이번 상담에서 받은 도장: [$resultStamp]',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
                  ),
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('도장 평가 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EBD9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(),
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
          const Text('※ 음성 상담 내용은 대화 내용이 저장되지 않아요.',
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
            onTap: isSpeaking ? null : () {
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
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
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