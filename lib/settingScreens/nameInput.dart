import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'firstIntro.dart';
import 'genderInput.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;
  bool _showWarning = false;
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;

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
        _animationController.forward(from: 0); // ��鸮�� �ִϸ��̼� ����
      } else {
        _showWarning = false;
        _isButtonEnabled = _controller.text.trim().isNotEmpty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E7C0),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
    'assets/images/character_1.png',
    width: 230,
  ),
),
const SizedBox(height: 20),


            ///
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_showWarning ? _shakeAnimation.value : 0, 0),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextField(
                        style:
                            const TextStyle(fontSize: 17, fontFamily: 'DungGeunMo'),
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

            //
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

            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Center(
                child: SizedBox(
                  width: 180,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () {
                            navigateWithAnimation(context, const GenderInputScreen());
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A5F3C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '다음',
                      style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}