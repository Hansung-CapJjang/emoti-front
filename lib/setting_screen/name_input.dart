import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/setting_screen/first_intro.dart';
import 'package:flutter_application_1/setting_screen/gender_input.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class NameInputScreen extends StatefulWidget {
  final bool isEdit;

  const NameInputScreen({super.key, required this.isEdit});

  @override
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;
  bool _showWarning = false;
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;

  // 이름 서버 전송
  Future<void> _sendNameToServer(String name) async {
    const String apiUrl = ''; // TODO: 서버 주소 입력

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name}),
      );

      if (response.statusCode == 200) {
        print("✅ 이름 저장 성공");
      } else {
        print("❗ 서버 오류: ${response.body}");
      }
    } catch (e) {
      print("❗ 네트워크 오류: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_checkInput);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_checkInput);
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _checkInput() {
    setState(() {
      if (_controller.text.trim().length > 5) {
        _showWarning = true;
        _isButtonEnabled = false;
        _animationController.forward(from: 0);
      } else {
        _showWarning = false;
        _isButtonEnabled = _controller.text.trim().isNotEmpty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EBD9),
      appBar: AppBar(
        title: const Text(
          '이름 정보',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontFamily: 'DungGeunMo',
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProgressBar(progress: 0.2),
              const SizedBox(height: 30),
              const Text(
                '이름을 입력해주세요.',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DungGeunMo',
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                '※ 5글자 이내로 작성하세요.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'DungGeunMo',
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),

              Center(
                child: Image.asset(
                  'assets/images/emoti_character.png',
                  width: 230,
                ),
              ),
              const SizedBox(height: 20),

              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_showWarning ? _shakeAnimation.value : 0, 0),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextField(
                          autofocus: true,
                          style: const TextStyle(fontSize: 17, fontFamily: 'DungGeunMo'),
                          textAlign: TextAlign.center,
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: '이곳에 작성하세요.',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: _showWarning ? Colors.red : Colors.grey,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: _showWarning ? Colors.red : const Color(0xFF5A5F3C),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              AnimatedOpacity(
                opacity: _showWarning ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Center(
                    child: Text(
                      '5글자 이내로 작성할 수 있어요!',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DungGeunMo',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              Center(
                child: SizedBox(
                  width: 180,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () {
                            final name = _controller.text.trim();
                            final userProvider = Provider.of<UserProvider>(context, listen: false);

                            userProvider.updateNickname(name);
                            _sendNameToServer(name);

                            if (widget.isEdit) {
                              Navigator.pop(context);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GenderInputScreen(),
                                ),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A5F3C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.isEdit ? '완료' : '다음',
                      style: const TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
