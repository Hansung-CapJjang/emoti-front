import 'package:flutter/material.dart';
import 'package:flutter_application_1/setting_screen/first_intro.dart';
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
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
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
                          if (url.contains("callback_url")) {
                            Navigator.pop(context);
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

  Widget _buildLoginButton({
  required VoidCallback onTap,
  required String imagePath,
  required String label,
  required Color backgroundColor,
  required Color labelColor,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Image.asset(imagePath, width: 32, height: 32),
            ),
          ),
          Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'DungGeunMo',
                color: labelColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 255, 237), // const Color(0xFFE9EBD9),
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 1),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/emoti_character.png', width: 130),
                    const SizedBox(height: 12),
                    const Text(
                      ' 환영합니다',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'DungGeunMo',
                      ),
                    ),
                    const Text(
                      '   마음을 위로하는 AI 상담 어플입니다',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'DungGeunMo',
                        color: Color.fromARGB(221, 33, 33, 33),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.grey, thickness: 2, indent: 40, endIndent: 10)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '간편 로그인',
                    style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo', color: Colors.black54),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey, thickness: 2, indent: 10, endIndent: 40)),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _buildLoginButton(
                    onTap: () => _showFloatingPage(context, "https://nid.naver.com"),
                    imagePath: 'assets/images/naver_logo.png',
                    label: '네이버로 시작하기',
                    backgroundColor: const Color(0xFF03C75B),
                    labelColor: Colors.white,
                  ),
                  _buildLoginButton(
                    onTap: () => _showFloatingPage(context, "https://kauth.kakao.com/oauth/authorize"),
                    imagePath: 'assets/images/kakaotalk_logo.png',
                    label: '카카오로 시작하기',
                    backgroundColor: Colors.yellow,
                    labelColor: Colors.black,
                  ),
                  _buildLoginButton(
                    onTap: () => _showFloatingPage(context, "https://accounts.google.com"),
                    imagePath: 'assets/images/google_logo.png',
                    label: '구글로 시작하기',
                    backgroundColor: Colors.white,
                    labelColor: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  const Text('� 본 어플은 별도의 회원 가입이 필요없어요!', style: TextStyle(color: const Color.fromARGB(221, 65, 65, 65),)), // fontFamily: 'DungGeunMo'),)
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}