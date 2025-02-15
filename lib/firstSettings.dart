import 'package:flutter/material.dart';
import 'homeScreen.dart';

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
        const begin = Offset(1.0, 0.0); // 오른쪽에서 등장
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

// 1️⃣ 첫 번째 화면
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SecondScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEFF2DD),
        body: const Center(
          child: Text(
            '반갑습니다.',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// 2️⃣ 두 번째 화면
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NameInputScreen()),
        );
      },
      child: const Scaffold(
        backgroundColor: Color(0xFFEFF2DD),
        body: Center(
          child: Text(
            '상담 전,\n사용자 정보를 작성해주세요.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// 3️⃣ 세 번째 화면 (이름 입력)
class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;

  void _checkInput() {
    setState(() {
      _isButtonEnabled = _controller.text.trim().isNotEmpty && _controller.text.length <= 5;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_checkInput);
  }

  @override
  void dispose() {
    _controller.removeListener(_checkInput);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF2DD),
      appBar: AppBar(
        title: const Text('이름 정보'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProgressBar(progress: 0.25), // 🔥 Progress Bar (50%)
            const SizedBox(height: 20),
            const Text(
              '이름을 입력해주세요.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              '※ 5글자 이내로 작성하세요.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '이 곳에 작성하세요.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isButtonEnabled
      ? () {
          navigateWithAnimation(context, const GenderSelectionScreen()); // 애니메이션 적용 🚀
        }
      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}

// 4️⃣ 네 번째 화면 (성별 선택)
class GenderSelectionScreen extends StatelessWidget {
  const GenderSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF2DD),
      appBar: AppBar(
        title: const Text('세부 정보'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressBar(progress: 0.5), // 🔥 Progress Bar (100%)
            SizedBox(height: 20),
            Text(
              '성별을 선택 해주세요.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              '※ 더 정확한 상담이 가능해져요.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            Spacer(),

            SizedBox(height: 30),
            GenderButton(label: '남성'),

            SizedBox(height: 10),
            GenderButton(label: '여성'),

            SizedBox(height: 10),
            GenderButton(label: '기타'),
          ],
        ),
      ),
    );
  }
}

// ✅ 공통 Progress Bar 위젯
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

    _controller.forward(); // 처음 로딩 시 애니메이션 실행
  }

  @override
  void didUpdateWidget(covariant ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _controller.animateTo(widget.progress); // 새로운 값으로 애니메이션 실행
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
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          );
        },
      ),
    );
  }
}


// 5️⃣ 고민 선택 화면
class ConcernSelectionScreen extends StatefulWidget {
  const ConcernSelectionScreen({super.key});

  @override
  _ConcernSelectionScreenState createState() => _ConcernSelectionScreenState();
}

class _ConcernSelectionScreenState extends State<ConcernSelectionScreen> {
  final List<String> _concerns = [
    '좁은 인간 관계', '이유 불명 우울함', '연인 관계', '질병', 
    '가족 관계', '빠지지 않는 살', '친구와의 다툼', '떠오르는 흑역사',
    '학교 성적', '취업 및 진로', '급격하게 늘어난 잠', '딱히 없음'
  ];
  final Set<String> _selectedConcerns = {};

  void _toggleConcern(String concern) {
    setState(() {
      if (concern == '딱히 없음') {
        _selectedConcerns.clear();
        _selectedConcerns.add(concern);
      } else {
        _selectedConcerns.remove('딱히 없음');

        if (_selectedConcerns.contains(concern)) {
          _selectedConcerns.remove(concern);
        } else {
          if (_selectedConcerns.length < 5) {
            _selectedConcerns.add(concern);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF2DD),
      appBar: AppBar(
        title: const Text('세부 정보'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProgressBar(progress: 0.8), // ✅ Progress Bar (100%)
            const SizedBox(height: 20),
            const Text(
              '최근 고민되는 일이 있나요?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              '※ 사용자에 관한 데이터가 많을수록 AI의 상담 수준이 높아져요!',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _concerns.map((concern) {
                final isSelected = _selectedConcerns.contains(concern);
                return GestureDetector(
                  onTap: () => _toggleConcern(concern),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.green[200],
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
                    ),
                    child: Text(
                      concern,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.green[800] : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedConcerns.isNotEmpty
                  ? () {
                      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}

// 성별 버튼 위젯
class GenderButton extends StatelessWidget {
  final String label;

  const GenderButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label 선택됨')),
        );
        // 고민 선택 화면으로 이동 🚀
        navigateWithAnimation(context, const ConcernSelectionScreen()); // 애니메이션 적용 🚀
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[400],
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(label),
    );
  }
}