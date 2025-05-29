import 'package:flutter/material.dart';
import '/provider/user_provider.dart'; 
import 'package:provider/provider.dart'; 

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