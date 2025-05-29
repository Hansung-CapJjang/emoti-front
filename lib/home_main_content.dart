import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import '/provider/user_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'home_speech_bubble.dart';
import 'package:http/http.dart' as http;

class MainContent extends StatefulWidget {
  const MainContent({super.key});

  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  final List<int> stampCounts = [1, 3, 5, 8];
  double characterProgress = 0.0;
  late String randomSpeechText;

  String characterIamgePath = "";
  String pet = "";
  int level = 0;
  List<String> stamp = [];

  final List<String> speechTexts = [
    "How can I help you?",
    "I'm here for you!",
    "Let's chat!",
    "What's on your mind?",
    "Ready to talk?",
    "Hi~"
  ];

  @override
  void initState() {
    super.initState();
    randomSpeechText = speechTexts[Random().nextInt(speechTexts.length)];
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  void _loadUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      pet = userProvider.pet;
      level = userProvider.level;
      stamp = userProvider.stamp;
      int prevSum = level == 1 ? 0 : stampCounts.sublist(0, level - 1).reduce((a, b) => a + b);
      characterProgress = ((stamp.length - prevSum) / stampCounts[level - 1]).clamp(0.0, 1.0);
      if (level == 1) {
        pet = 'Egg';
        characterIamgePath = 'assets/images/egg.png';
      } else {
        characterIamgePath = 'assets/images/$pet${level - 1}.png';
      }
    });
  }

  Future<void> updateLevelToServer(String id,int level) async {
    final url = Uri.parse('https://www.emoti.kr/users/update/level');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': id,
          'level': level,
        }),
      );
      if (response.statusCode != 200) {
      }
    } catch (e) {
      rethrow;
    }
  }

  void _showEvolutionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("펫이 진화했습니다!"),
          content: const Text("축하합니다! 다음 레벨로 진화했어요 🐣"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                setState(() {
                  level += 1;
                  int prevSum = level == 1 ? 0 : stampCounts.sublist(0, level - 1).reduce((a, b) => a + b);
                  characterProgress = ((stamp.length - prevSum) / stampCounts[level - 1]).clamp(0.0, 1.0);
                  pet = level == 1 ? 'Egg' : pet;
                  if (pet == 'Egg') {
                    characterIamgePath = 'assets/images/egg.png';
                  } else {
                    characterIamgePath = 'assets/images/$pet${level - 1}.png';
                  }
                });
                userProvider.updateLevel(level);
                await updateLevelToServer(userProvider.id, level);
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final userProvider = context.watch<UserProvider>();
    pet = userProvider.pet;
    level = userProvider.level;
    stamp = userProvider.stamp;
    int prevSum = level == 1 ? 0 : stampCounts.sublist(0, level - 1).reduce((a, b) => a + b);
    characterProgress = ((stamp.length - prevSum) / stampCounts[level - 1]).clamp(0.0, 1.0);
    if (level == 1) {
      pet = 'Egg';
      characterIamgePath = 'assets/images/egg.png';
    } else {
      characterIamgePath = 'assets/images/$pet${level - 1}.png';
    }

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE9EBD9),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Lv.$level',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'DungGeunMo',
                                  color: const Color(0xFF414728).withOpacity(0.64),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                pet,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DungGeunMo',
                                  color: Color(0xFF414728),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final totalWidth = constraints.maxWidth;
                                    final filledWidth = totalWidth * characterProgress;

                                    return Stack(
                                      children: [
                                        Container(
                                          width: totalWidth,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF798063).withOpacity(0.56),
                                            borderRadius: BorderRadius.circular(7),
                                          ),
                                        ),
                                        Container(
                                          width: filledWidth,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF56644B),
                                            borderRadius: BorderRadius.circular(7),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${(characterProgress * 100).round()}%',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'DungGeunMo',
                                  color: Color(0xFF5A6140),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          alignment: Alignment.center,
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                          ),
                          child: SpeechBubble(
                            text: randomSpeechText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: Transform.translate(
                          offset: const Offset(0, -10),
                          child: Image.asset(
                            characterIamgePath,
                            width: 200,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Transform.translate(
                        offset: const Offset(120, -80),
                        child: GestureDetector(
                          onTap: () async {
                            await _saveCharacterImageToGallery(context, characterIamgePath);
                          },
                          child: Image.asset(
                            'assets/images/download.png',
                            width: 100,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ],
              ),
            ),

            // 도장판 제출 버튼
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 60,
              left: screenWidth / 2 - (screenWidth*0.15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<UserProvider>(
                    builder: (context, userProvider, _) {
                      int totalStamps = stamp.length;
                      final requiredStamps = stamp.isEmpty ? 1 : stampCounts.sublist(0, level).reduce((a, b) => a + b);
                      bool canEvolve = totalStamps >= requiredStamps && level < stampCounts.length + 1;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: canEvolve ? () => _showEvolutionDialog(context) : null,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width*0.7),
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: canEvolve
                                  ? const Color.fromRGBO(110, 120, 91, 0.9)
                                  : const Color.fromRGBO(110, 120, 91, 0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              '도장판 제출',
                              style: TextStyle(
                                fontFamily: 'DungGeunMo',
                                fontSize: 18,
                                color: canEvolve ? const Color(0xFF454545) : const Color(0xFFAAAAAA),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      _showPopupDialog(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Image.asset(
                        'assets/images/informationicon.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 이미지를 갤러리에 저장
  Future<void> _saveCharacterImageToGallery(BuildContext context, String characterIamgePath) async {
    try {
      // 권한 요청
      if (Platform.isAndroid) {
        if (await Permission.storage.request().isDenied ||
            await Permission.photos.request().isDenied) {
          return;
        }
      } else if (Platform.isIOS) {
        if (await Permission.photos.request().isDenied) {
          return;
        }
      }

      // assets에서 이미지 로드
      final ByteData data = await rootBundle.load(characterIamgePath);
      final Uint8List bytes = data.buffer.asUint8List();

      // 파일을 임시 디렉토리에 저장
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/character_image.png';
      final File imageFile = File(filePath);
      await imageFile.writeAsBytes(bytes);

      // 갤러리에 저장 (Android & iOS 대응)
      final result = await ImageGallerySaver.saveFile(filePath);
      if (result['isSuccess'] == true) {
        _showSaveSuccessSnackbar(context);
      }
    } catch (e) {
      rethrow;
    }
  }

  // 갤러리 저장 완료 시 알림 메시지
  void _showSaveSuccessSnackbar(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '이미지 저장 완료!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DungGeunMo',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '캐릭터 이미지가\n갤러리에 저장되었습니다!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'DungGeunMo',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF798063),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.black, width: 1.5),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPopupDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '도장판을 완성하면\n버튼이 활성화 돼요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DungGeunMo',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '도장판을 완성할 때마다\n캐릭터가 성장한답니다',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'DungGeunMo',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF798063),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.black, width: 1.5),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}