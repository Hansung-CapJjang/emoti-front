import 'package:flutter/material.dart';

void main() {
  runApp(const EmotiApp());
}

class EmotiApp extends StatelessWidget {
  const EmotiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF2DD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              '마음을 위로하는 AI 상담 어플',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
    fontFamily: 'DungGeunMo',
                color: Colors.black87,
              ),
            ),
            // const SizedBox(height: 2),
            const Text(
  'emoti',
  style: TextStyle(
    fontSize: 80,
    fontWeight: FontWeight.bold,
    fontFamily: 'Times New Roman',
    color: Colors.black87,
  ),
),


            // const SizedBox(height: 10),
            Image.asset('assets/images/character_1.png', width: 230),
            const SizedBox(height: 40),
            const Row(
  children: [
                Expanded(child: Divider(color: Colors.grey, thickness: 2, indent: 20, endIndent: 10)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '간편 로그인',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
    fontFamily: 'DungGeunMo',
                      color: Colors.black54,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey, thickness: 2, indent: 10, endIndent: 20)),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ 
                GestureDetector(
                  onTap: () => _showSnackBar(context, "naver로 로그인하는 중."), // Naver 로그인 기능 구현 부분    
                  child: Image.asset('assets/images/naverLogo.png', width: 60),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => _showSnackBar(context, "kakao로 로그인하는 중."), // Kakao 로그인 기능 구현 부분   
                  child: Image.asset('assets/images/kakaotalkLogo.png', width: 60),
                ),
                const SizedBox(width: 20),  
                GestureDetector(
                  onTap: () => _showSnackBar(context, "Google로 로그인하는 중."), // Google 로그인 기능 구현 부분      
                  child: Image.asset('assets/images/googleLogo.png', width: 60),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class EyeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}