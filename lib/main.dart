import 'login.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Provider 임포트

// 로그인 기능 구현하면 
// 첫 로그인 시 로그인 화면, 로그인 되어 있다면 홈화면으로 바로 넘어가게 하기 위한 파일
// 아직 구현 안됐으므로 각 파일 별로 직접 실행해보기

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'AI심리상담가',
      debugShowCheckedModeBanner: false, // 디버그 띠 비활성화
      locale: Locale('ko'), // 한국어로 기본 설정
      supportedLocales: const [
        Locale('ko'), // 한국어 지원
        Locale('en'), // 영어 지원 (필요시 추가)
      ],
    );
  }
}