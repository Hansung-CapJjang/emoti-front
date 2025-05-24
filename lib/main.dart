import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/main_screen.dart';
import 'package:flutter_application_1/setting_screen/splash_logo.dart';
import 'package:flutter_application_1/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    print('✅ .env 로딩 완료');
  } catch (e) {
    print('❌ .env 로딩 실패: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const EmotiApp(),
    ),
  );
}

class EmotiApp extends StatelessWidget {
  const EmotiApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('📦 EmotiApp build 실행됨');

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
      localizationsDelegates: const [ 
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/splash',
      routes: {
        '/main': (context) => MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/splash': (context) => const SplashScreen(),
      },
    );
  }
}