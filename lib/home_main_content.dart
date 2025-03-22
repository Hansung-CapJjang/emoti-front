import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
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

  @override
  void initState() {
    super.initState();
    randomSpeechText = speechTexts[Random().nextInt(speechTexts.length)];
  }

  @override
  Widget build(BuildContext context) {
    return
    SingleChildScrollView(
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
                          'Lv.1',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'DungGeunMo',
                            color: const Color(0xFF414728).withOpacity(0.64),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Egg',
                          style: TextStyle(
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
    // Align(
    //   alignment: Alignment.topCenter, // 중앙 정렬
    //   child: 
Align(
  alignment: Alignment.topCenter, // 중앙 정렬
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // 패딩 조정
  alignment: Alignment.center, // 중앙 정렬
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * 0.9,
    ),
    child: SpeechBubble(
      text: randomSpeechText, // 랜덤 문구 적용
      // color: Colors.white, // 말풍선 색상
    ),
  ),
),

    // 캐릭터 이미지 위치 조정 가능
    Align(
  alignment: Alignment.center,
  child: Transform.translate(
    offset: const Offset(0, -10), // 🔥 원하는 만큼 위로 올리기 (숫자 조정 가능)
    child: Image.asset(
      'assets/images/baebse.png',
      width: 230,
    ),
  ),
),

Transform.translate(
  offset: const Offset(120, -80), // 원하는 만큼 오른쪽으로 이동
  child: GestureDetector(
    onTap: () async {
      print("🔹 Vector image tapped! Saving demo_baebse image...");
      await _saveBaebseImageToGallery(context); // context 전달
    },
    child: Image.asset(
      'assets/images/Vector.png', // Vector 이미지 경로
      width: 100, // 원하는 크기로 설정
    ),
  ),
),
    // 캐릭터 아래 여백 (버튼과 겹치지 않도록 조정 가능)
   Center(
  child: Transform.translate(
    offset: const Offset(0, -60), // 원하는 만큼 위로 올리기
    child: ElevatedButton(
      onPressed: () {
        // 도장판 제출 버튼 클릭 시 동작
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF798063).withOpacity(0.56), // 배경색
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

    
// 🔹 아이콘 위치 조정 가능
Transform.translate(
  offset: const Offset(120, -95), // 기존 위치값 유지 (오른쪽 120, 위로 180)
  child: GestureDetector(
    onTap: () {
      print("🔹 Information icon tapped!"); // 터미널 로그 확인용
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
            const SizedBox(height: 30), // 버튼 아래 간격 추가
          ],
        ),
      );
  }
}

// 📌 이미지를 갤러리에 저장하는 함수
Future<void> _saveBaebseImageToGallery(BuildContext context) async {
  try {
    // 🔹 권한 요청 (Android 13 이상 및 iOS 대응)
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isDenied ||
          await Permission.photos.request().isDenied) {
        print("❌ 저장 권한이 거부됨");
        return;
      }
    } else if (Platform.isIOS) {
      if (await Permission.photos.request().isDenied) {
        print("❌ iOS 갤러리 저장 권한이 거부됨");
        return;
      }
    }

    // 🔹 assets에서 demo_baebse.png 이미지 로드
    final ByteData data = await rootBundle.load('assets/images/baebse.png');
    final Uint8List bytes = data.buffer.asUint8List();

    // 🔹 파일을 임시 디렉토리에 저장
    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}/baebse.png';
    final File imageFile = File(filePath);
    await imageFile.writeAsBytes(bytes);

    // 🔹 갤러리에 저장 (Android & iOS 대응)
    final result = await ImageGallerySaver.saveFile(filePath);
    if (result['isSuccess'] == true) {
      print("✅ demo_baebse.png saved to gallery: $result");

      // ✅ 저장 성공 시 사용자에게 메시지 표시
      _showSaveSuccessSnackbar(context);
    } else {
      print("❌ Image save failed: $result");
    }
  } catch (e) {
    print("❌ Error saving image: $e");
  }
}

// ✅ 갤러리 저장 완료 시 알림 메시지
void _showSaveSuccessSnackbar(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // 팝업 바깥 클릭 시 닫기 가능
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.transparent, // 배경 투명
        contentPadding: EdgeInsets.zero, // 기본 패딩 제거
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 팝업 크기 조정
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, // 팝업 배경색
            borderRadius: BorderRadius.circular(10), // 모서리 둥글게
            border: Border.all(color: Colors.black, width: 2), // 검은 테두리 추가
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

// 📌 Vector 이미지 다운로드 함수 (수정된 버전)
Future<void> _downloadImage() async {
  try {
    // 🔹 assets에서 이미지 로드
    final ByteData data = await rootBundle.load('assets/images/Vector.png');
    final Uint8List bytes = data.buffer.asUint8List();

    // 🔹 앱 내 저장소에 저장
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/Vector.png';
    final File imageFile = File(filePath);
    await imageFile.writeAsBytes(bytes);

    print("✅ Image saved at: ${imageFile.path}");
  } catch (e) {
    print("❌ Error downloading image: $e");
  }
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
          width: MediaQuery.of(context).size.width * 0.8, // 팝업 크기 조정
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, // 팝업 배경색
            borderRadius: BorderRadius.circular(10), // 모서리 둥글게
            border: Border.all(color: Colors.black, width: 2), // 검은 테두리 추가
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