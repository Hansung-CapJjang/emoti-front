import 'login.dart';
import 'main_screen.dart';
import 'stamp_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'setting_screen/splash_logo.dart'; 

void main() async {
  await dotenv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoti',
      debugShowCheckedModeBanner: false, 

      theme: ThemeData(
        fontFamily: 'DungGeunMo',
        scaffoldBackgroundColor: const Color(0xFFEEEEEE),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0XFF776767)),
          bodyMedium: TextStyle(color: Color(0XFF776767)),
          headlineLarge: TextStyle(color: Color(0XFF776767)),
        ),
      ),

      locale: const Locale('ko'), 
      supportedLocales: const [
        Locale('ko'), 
        Locale('en'), 
      ],

      // 기본 화면 설정 (로그인 여부에 따라 변경)
      initialRoute: isLoggedIn ? '/main' : '/login',

     
      routes: {
        '/main': (context) => MainScreen(),
        '/login': (context) => LoginScreen(),
        '/stampBoard': (context) => StampBoard(),
        '/splash': (context) => const SplashLogoScreen(),
      },
    );
  }
}