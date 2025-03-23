import 'login.dart';
import 'main_screen.dart';
import 'stamp_board.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(isLoggedIn: false));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoti',
      debugShowCheckedModeBanner: false, // 디버그 띠 비활성화

      theme: ThemeData(
        fontFamily: 'DungGeunMo',
        scaffoldBackgroundColor: const Color(0xFFEEEEEE),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0XFF776767)),
          bodyMedium: TextStyle(color: Color(0XFF776767)),
          headlineLarge: TextStyle(color: Color(0XFF776767)),
        ),
      ),

      locale: const Locale('ko'), // 한국어로 기본 설정
      supportedLocales: const [
        Locale('ko'), // 한국어 지원
        Locale('en'), // 영어 지원 (필요시 추가)
      ],

      // 기본 화면 설정 (로그인 여부에 따라 변경)
      initialRoute: isLoggedIn ? '/main' : '/login',

      // `routes` 설정 (화면 이동 가능하도록 설정)
      routes: {
        '/main': (context) => MainScreen(),
        '/login': (context) => LoginScreen(),
        '/stampBoard': (context) => StampBoard(),
      },
    );
  }
}