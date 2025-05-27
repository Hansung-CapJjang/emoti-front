import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'main_screen.dart';
import 'setting_screen/first_intro.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_application_1/provider/user_provider.dart'; 
bool shouldHandleInitialLink = true; 

void main() {
  runApp(const EmotiApp());
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late final WebViewController _controller;
  late UserProvider userProvider; // 여기는 선언만

  @override
  void initState() {
    super.initState();
    shouldHandleInitialLink = true;

    // 여기에만 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.clear(); // 여기서 안전하게 clear
    });

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://flutter.dev"));

    _listenToLinkStream();
    _checkInitialLink();
  }


  Future<bool> isExistingUser(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.emoti.kr/users?id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        userProvider.loadFromMap(data);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception();
    }
  }

Future<void> _checkInitialLink() async {
  if (!shouldHandleInitialLink) {
    print("딥링크 무시됨");
    return;
  }

  final initialLink = await getInitialLink();
  if (initialLink != null && initialLink.startsWith("emoti://login")) {
    final uri = Uri.parse(initialLink);
    final String userId = uri.queryParameters['userId'].toString();

    final isExisting = await isExistingUser(userId);

    if (isExisting) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      userProvider.setId(userId);
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (_) => const FirstScreen()),
      );
    }
  }
}


  void _listenToLinkStream() {
    linkStream.listen((String? link) async {
      if (link != null && link.startsWith("emoti://login")) {
        final uri = Uri.parse(link);
        final String userId = uri.queryParameters['userId'].toString();

        final isExisting = await isExistingUser(userId);
        
        if (isExisting) {
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (_) => MainScreen()),
          );
        } else {
          userProvider.setId(userId);
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (_) => const FirstScreen()),
          );
        }
      }
    });
  }

  void _handleLogin(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw Exception();
    }
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
                    onTap: () => _handleLogin(context, "https://www.emoti.kr/auth/naver"),
                    imagePath: 'assets/images/naver_logo.png',
                    label: '네이버로 시작하기',
                    backgroundColor: const Color(0xFF03C75B),
                    labelColor: Colors.white,
                  ),
                  _buildLoginButton(
                    onTap: () => _handleLogin(context, "https://www.emoti.kr/auth/kakao"),
                    imagePath: 'assets/images/kakaotalk_logo.png',
                    label: '카카오로 시작하기',
                    backgroundColor: Colors.yellow,
                    labelColor: Colors.black,
                  ),
                  _buildLoginButton(
                    onTap: () => _handleLogin(context, "https://www.emoti.kr/auth/google"),
                    imagePath: 'assets/images/google_logo.png',
                    label: '구글로 시작하기',
                    backgroundColor: Colors.white,
                    labelColor: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  const Text('본 어플은 별도의 회원 가입이 필요없어요!', style: TextStyle(color: Color.fromARGB(221, 65, 65, 65),)), // fontFamily: 'DungGeunMo'),)
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