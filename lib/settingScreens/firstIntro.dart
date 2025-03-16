import 'package:flutter/material.dart';
import 'nameInput.dart';

void main() {
  runApp(const EmotiApp());
}

class EmotiApp extends StatelessWidget {
  const EmotiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
    );
  }
}

void navigateWithAnimation(BuildContext context, Widget nextScreen) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}

// 1
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E7C0), // ����
      body: Column(
        children: [
          const SizedBox(height: 130), // �۾� �߾� ����
          const Expanded(
            child: Center(
              child: Text(
                '반갑습니다.',
                style: TextStyle(
                  fontSize: 27,
                  fontFamily: 'DungGeunMo',
                  color: Color(0xFF5A5F3C), // �۾� ����
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 120), // ��ư�� �� ���� �̵�
            child: SizedBox(
              width: 180, // ��ư ũ��
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  navigateWithAnimation(context, const SecondScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A5F3C), // ��ư ����
                  foregroundColor: Colors.white, // ���ڻ�
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // �ձ� ��ư
                  ),
                ),
                child: const Text(
                  '다음',
                  style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 2
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E7C0), // ����
      body: Column(
        children: [
          const SizedBox(height: 130), // �۾� �߾� ����
          const Expanded(
            child: Center(
              child: Text(
                '상담 전,\n사용자님의 정보를\n입력해주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'DungGeunMo',
                  color: Color(0xFF5A5F3C), // �۾� ����
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 120), // ��ư�� �� ���� �̵�
            child: SizedBox(
              width: 180, // ��ư ũ��
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  navigateWithAnimation(context, const NameInputScreen(isEdit: false));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A5F3C), // ��ư ����
                  foregroundColor: Colors.white, // ���ڻ�
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // �ձ� ��ư
                  ),
                ),
                child: const Text(
                  '다음',
                  style: TextStyle(fontSize: 16, fontFamily: 'DungGeunMo'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Progress Bar
class ProgressBar extends StatefulWidget {
  final double progress; // 0.0 ~ 1.0

  const ProgressBar({super.key, required this.progress});

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.progress).animate(_controller);

    _controller.forward(); //
  }

  @override
  void didUpdateWidget(covariant ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _controller.animateTo(widget.progress); // 
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: _animation.value,
            minHeight: 8,
            backgroundColor: const Color.fromARGB(255, 116, 123, 77), // 
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          );
        },
      ),
    );
  }
}

