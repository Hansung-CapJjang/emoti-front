import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/user_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'home_speech_bubble.dart';

class MainContent extends StatefulWidget {
  const MainContent({super.key});

  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  // 랜덤 문구 리스트
  final List<String> speechTexts = [
    "How can I help you?",
    "I'm here for you!",
    "Let's chat!",
    "What's on your mind?",
    "Ready to talk?",
    "Hi~"
  ];

  // 랜덤 문구를 저장할 변수
  late String randomSpeechText;

  String characterIamgePath = 'assets/images/egg.png';
  String pet = "Egg";
  int level = 1;

  Future<void> _getLoadData() async {
    final userEmail = Provider.of<UserProvider>(context, listen: false).email;
    final String jsonString = await rootBundle.loadString('assets/data/user_data.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    final user = jsonData.cast<Map<String, dynamic>>().firstWhere(
      (u) => u['email'] == userEmail,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      setState(() {
        if (user['level'] == 1) {
          pet = 'Egg';
          level = user['level'];
          characterIamgePath = 'assets/images/egg.png';
        } else if (user['level'] != 1) { // else
          pet = user['pet'];
          level = user['level'];
          String imageName = '${pet == "뱁새" ? "baebse" : "penguin"}${level-1}.png'; //'baebse1.png';
          characterIamgePath = 'assets/images/$imageName';
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    randomSpeechText = speechTexts[Random().nextInt(speechTexts.length)];

    Future.microtask(() async {
      await _getLoadData();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF798063).withOpacity(0.56),
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF56644B),
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '60%',
                        style: TextStyle(
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
                alignment: Alignment.topCenter, // 중앙 정렬
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  alignment: Alignment.center, // 중앙 정렬
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  child: SpeechBubble(
                    text: randomSpeechText, // 랜덤 문구 적용
                  ),
                ),
              ),

              // 캐릭터 이미지 위치 조정
              const SizedBox(height: 20,),
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
              const SizedBox(height: 20,),
              Transform.translate(
                offset: const Offset(120, -80),
                child: GestureDetector(
                  onTap: () async {
                    await _saveCharacterImageToGallery(context, characterIamgePath); // context 전달
                  },
                  child: Image.asset(
                    'assets/images/download.png',
                    width: 100,
                  ),
                ),
              ),
              // 캐릭터 아래 여백
              Center(
                child: Transform.translate(
                  offset: const Offset(0, -60),
                  child: ElevatedButton(
                    onPressed: () {
                      // 도장판 제출 버튼 클릭 시 동작
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(110, 120, 91, 0.56),// 배경색
                      foregroundColor: const Color(0xFF454545), // 글씨색
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(150, 45), // 버튼 크기 유지
                    ),
                    child: const Text(
                      '도장판 제출',
                      style: TextStyle(
                        fontFamily: 'DungGeunMo',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
    
              // 아이콘 위치 조정 가능
              Transform.translate(
                offset: const Offset(120, -95),
                child: GestureDetector(
                  onTap: () {
                    _showPopupDialog(context); // 팝업 호출
                  },
                  child: Container(
                    color: Colors.transparent, // 터치 영역 확보
                    child: Image.asset(
                      'assets/images/informationicon.png',
                      width: 17,
                      height: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// 이미지를 갤러리에 저장하는 함수
Future<void> _saveCharacterImageToGallery(BuildContext context, String characterIamgePath) async {
  try {
    // 권한 요청 (Android 13 이상 및 iOS 대응)
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
      _showSaveSuccessSnackbar(context); // 저장 성공 시 사용자에게 메시지 표시
    }
  } catch (e) {
    rethrow;
  }
}

// 갤러리 저장 완료 시 알림 메시지
void _showSaveSuccessSnackbar(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // 팝업 바깥 클릭 시 닫기 가능
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.transparent, // 배경 투명
        contentPadding: EdgeInsets.zero, // 기본 패딩 제거
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, // 팝업 배경색
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
                  color: Colors.black, // 글자색 검정
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '캐릭터 이미지가\n갤러리에 저장되었습니다!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'DungGeunMo',
                  color: Colors.black, // 글자색 검정
                ),
              ),
              const SizedBox(height: 20), // 간격 추가
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext), // 팝업 닫기
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF798063), // 배경색
                  foregroundColor: Colors.white, // 글씨색
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
    barrierDismissible: true, // 팝업 바깥 클릭 시 닫기
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.transparent, // 배경 투명 처리
        contentPadding: EdgeInsets.zero, // 기본 패딩 제거
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, // 팝업 배경색
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2), // 검은 테두리
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
                onPressed: () => Navigator.of(dialogContext).pop(), // 팝업 닫기
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF798063), // 배경색
                  foregroundColor: Colors.white, // 글씨색
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