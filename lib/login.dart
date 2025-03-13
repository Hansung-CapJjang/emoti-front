// import 'package:flutter/material.dart';

// void main() {
//   runApp(const EmotiApp());
// }

// class EmotiApp extends StatelessWidget {
//   const EmotiApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginScreen(),
//     );
//   }
// }

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   void _showSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEFF2DD),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Spacer(),
//             const Text(
//               '마음을 위로하는 AI 상담 어플',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.normal,
//     fontFamily: 'DungGeunMo',
//                 color: Colors.black87,
//               ),
//             ),
//             // const SizedBox(height: 2),
//             const Text(
//   'emoti',
//   style: TextStyle(
//     fontSize: 80,
//     fontWeight: FontWeight.bold,
//     fontFamily: 'Times New Roman',
//     color: Colors.black87,
//   ),
// ),


//             // const SizedBox(height: 10),
//             Image.asset('assets/images/character_1.png', width: 230),
//             const SizedBox(height: 40),
//             const Row(
//   children: [
//                 Expanded(child: Divider(color: Colors.grey, thickness: 2, indent: 20, endIndent: 10)),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: Text(
//                     '간편 로그인',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.normal,
//     fontFamily: 'DungGeunMo',
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ),
//                 Expanded(child: Divider(color: Colors.grey, thickness: 2, indent: 10, endIndent: 20)),
//               ],
//             ),
//             const SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [ 
//                 GestureDetector(
//                   onTap: () => _showSnackBar(context, "naver로 로그인하는 중."), // Naver 로그인 기능 구현 부분    
//                   child: Image.asset('assets/images/naverLogo.png', width: 60),
//                 ),
//                 const SizedBox(width: 20),
//                 GestureDetector(
//                   onTap: () => _showSnackBar(context, "kakao로 로그인하는 중."), // Kakao 로그인 기능 구현 부분   
//                   child: Image.asset('assets/images/kakaotalkLogo.png', width: 60),
//                 ),
//                 const SizedBox(width: 20),  
//                 GestureDetector(
//                   onTap: () => _showSnackBar(context, "Google로 로그인하는 중."), // Google 로그인 기능 구현 부분      
//                   child: Image.asset('assets/images/googleLogo.png', width: 60),
//                 ),
//               ],
//             ),
//             const Spacer(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class EyeWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 40,
//       height: 40,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//       ),
//       child: Center(
//         child: Container(
//           width: 20,
//           height: 20,
//           decoration: const BoxDecoration(
//             color: Colors.black,
//             shape: BoxShape.circle,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_application_1/settingScreens/firstIntro.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // ✅ JavaScript 활성화
      ..loadRequest(Uri.parse("https://flutter.dev"));
  }

void _showFloatingPage(BuildContext context, String url) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      WebViewController dialogController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(url));

      return Dialog(
        insetPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.8,
              child: WebViewWidget(
                controller: dialogController
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onPageFinished: (String url) {
                        if (url.contains("callback_url")) {  // ✅ 로그인 성공 여부 확인 (콜백 URL)
                          Navigator.pop(context);  // 다이얼로그 닫기
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const FirstScreen()),
                          );
                        }
                      },
                    ),
                  ),
              ),
            ),
            Positioned(
              right: 5,
              top: 5,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      );
    },
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
              style: TextStyle(fontSize: 20, fontFamily: 'DungGeunMo', color: Colors.black87),
            ),
            const Text(
              'emoti',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, fontFamily: 'Times New Roman', color: Colors.black87),
            ),
            Image.asset('assets/images/character_1.png', width: 230),
            const SizedBox(height: 40),
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.grey, thickness: 2, indent: 20, endIndent: 10)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '간편 로그인',
                    style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo', color: Colors.black54),
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
                  onTap: () => _showFloatingPage(context, "https://nid.naver.com"), // 추후 주소 수정
                  child: Image.asset('assets/images/naverLogo.png', width: 60),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => _showFloatingPage(context, "https://kauth.kakao.com/oauth/authorize"), // 추후 주소 수정
                  child: Image.asset('assets/images/kakaotalkLogo.png', width: 60),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => _showFloatingPage(context, "https://accounts.google.com"), // 추후 주소 수정
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