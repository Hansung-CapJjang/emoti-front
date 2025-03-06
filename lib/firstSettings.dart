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
    return Scaffold(
      backgroundColor: const Color(0xFFE3E7C0), // 배경색
      body: Column(
        children: [
          const SizedBox(height: 130), // 글씨 중앙 정렬
          const Expanded(
            child: Center(
              child: Text(
                '반갑습니다.',
                style: TextStyle(
                  fontSize: 27,
                  fontFamily: 'DungGeunMo',
                  color: Color(0xFF5A5F3C), // 글씨 색상
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 120), // 버튼을 더 위로 이동
            child: SizedBox(
              width: 180, // 버튼 크기
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  navigateWithAnimation(context, const SecondScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A5F3C), // 버튼 색상
                  foregroundColor: Colors.white, // 글자색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 둥근 버튼
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

// 2️⃣ 두 번째 화면
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E7C0), // 배경색
      body: Column(
        children: [
          const SizedBox(height: 130), // 글씨 중앙 정렬
          const Expanded(
            child: Center(
              child: Text(
                '상담 전,\n사용자님의 정보를\n입력해주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'DungGeunMo',
                  color: Color(0xFF5A5F3C), // 글씨 색상
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 120), // 버튼을 더 위로 이동
            child: SizedBox(
              width: 180, // 버튼 크기
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  navigateWithAnimation(context, const NameInputScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A5F3C), // 버튼 색상
                  foregroundColor: Colors.white, // 글자색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 둥근 버튼
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
      backgroundColor: const Color(0xFFE3E7C0), // 배경색
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
            const ProgressBar(progress: 0.25), // 🔥 Progress Bar (25%)
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
            const SizedBox(height: 100), // 입력 필드 아래로 이동
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6, // 입력 필드 가로 크기 조정
                child: TextField(
                  style: const TextStyle(fontSize: 17, fontFamily: 'DungGeunMo'),
                  textAlign: TextAlign.center,
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: '이곳에 작성하세요.',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF5A5F3C), width: 2), // 초록색 테두리
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 100), // 버튼을 더 위로 이동
              child: Center(
                child: SizedBox(
                  width: 180, // 버튼 크기 조정
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () {
                            navigateWithAnimation(context, const GenderSelectionScreen());
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A5F3C), // 버튼 색상 (올리브색)
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // 둥근 버튼
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


// 4️⃣ 네 번째 화면 (성별 선택)
class GenderSelectionScreen extends StatelessWidget {
  const GenderSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E7C0), // 배경색
      appBar: AppBar(
        title: const Text('세부 정보', style: TextStyle(fontWeight: FontWeight.normal,
    fontFamily: 'DungGeunMo',
                color: Colors.black87,),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressBar(progress: 0.5), // 🔥 Progress Bar (100%)
            SizedBox(height: 30),
            Text(
              '성별을 선택 해주세요.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
    fontFamily: 'DungGeunMo',
                color: Colors.black87,),
            ),
            SizedBox(height: 15),
            Text(
              '※ 더 정확한 상담이 가능해져요.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal,
    fontFamily: 'DungGeunMo',
                color: Colors.black87),
            ),

            Spacer(flex:10),

            SizedBox(height: 30),
            GenderButton(label: '남성'),

            SizedBox(height: 15),
            GenderButton(label: '여성'),

            SizedBox(height: 15),
            GenderButton(label: '기타'),

            Spacer(flex:1),
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
            backgroundColor: const Color.fromARGB(255, 116, 123, 77), // 버튼 색상
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
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
    '좁은 인간 관계', '이유 불명 우울함', '연인 관계', '건강', '가족 관계', '자기개발에 대한 부담',
    '학교 성적', '빠지지 않는 살', '친구와의 다툼', '떠오르는 흑역사', '미래에 대한 불안',
    '취업 및 진로', '급격하게 늘어난 잠', '경제적 어려움', '대인 관계', '직장 내 인간 관계', '딱히 없음'
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
          if (_selectedConcerns.length < 3) {
            _selectedConcerns.add(concern);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E7C0), // 배경색
      appBar: AppBar(
        title: const Text('세부 정보', style: TextStyle(
    fontFamily: 'DungGeunMo',
                color: Colors.black87),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
  crossAxisAlignment: CrossAxisAlignment.start, // 텍스트는 왼쪽 정렬
  children: [
    const ProgressBar(progress: 0.8),
    const SizedBox(height: 30),
    const Text(
      '최근 고민되는 일이 있나요?',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
      fontFamily: 'DungGeunMo',
      color: Colors.black87),
    ),
    const SizedBox(height: 15),
    const Text(
      '※ 사용자에 관한 데이터가 많을수록\n  AI의 상담 수준이 높아져요!\n※ 3개까지 선택할 수 있어요.',
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal,
      fontFamily: 'DungGeunMo',
      color: Colors.black87),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color.fromARGB(255, 134, 109, 51) : const Color(0xFFD6D9AC),
              borderRadius: BorderRadius.circular(10),
              border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
            ),
            child: Text(
              concern,
              style: TextStyle(
                fontFamily: 'DungGeunMo',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    ),
    const Spacer(flex: 10),
    Align(
      alignment: Alignment.center, // 버튼만 가운데 정렬
      child: SizedBox(
        width: 180, // 버튼 크기
        height: 50,
        child: ElevatedButton(
          onPressed: _selectedConcerns.isNotEmpty
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('다음 화면으로 이동')),
                  );
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
    const Spacer(flex: 6),
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
        // 성별 선택되면 정보 저장
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label 선택됨')),
        );
        // 고민 선택 화면으로 이동
        navigateWithAnimation(context, const ConcernSelectionScreen()); // 애니메이션 적용
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 167, 177, 115), // 버튼 색상 (올리브색)
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.normal,
    fontFamily: 'DungGeunMo',),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // 둥근 버튼
                      ),
      ),
      child: Text(label),
    );
  }
}
