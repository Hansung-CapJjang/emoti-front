import 'package:flutter/material.dart';
import '../login.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../home.dart'; 
import 'package:flutter_application_1/user_provider.dart'; 
import 'package:provider/provider.dart'; 
import '../main_screen.dart'; 

void main() {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emoti',
      theme: ThemeData(
        fontFamily: 'DungGeunMo',
        scaffoldBackgroundColor: const Color(0xFFE9EBD9),
      ),
      home: const SplashScreen(), 
    );
  }
}




class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  );

  _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);
  _fadeController.forward();

  //로그인여부
  Future.delayed(const Duration(seconds: 2), () async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final email = prefs.getString('email') ?? "";

    if (mounted && isLoggedIn && email.isNotEmpty) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateEmail(email);
      await userProvider.loadUserData();
    }

    Widget nextScreen = isLoggedIn ? MainScreen() : const LoginScreen();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, __, ___) => nextScreen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  });
}


  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EBD9),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '마음을 위로하는 AI 상담 어플',
                style: TextStyle(fontSize: 20, fontFamily: 'DungGeunMo', color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                'emoti',
                style: TextStyle(fontSize: 80, fontWeight: FontWeight.normal, fontFamily: 'DungGeunMo', color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}