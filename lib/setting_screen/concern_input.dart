import 'dart:convert';
import 'package:flutter/material.dart';
import 'first_intro.dart';
import '/main_screen.dart';
import 'package:provider/provider.dart';
import '/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import '/main.dart';

class ConcernInputScreen extends StatefulWidget {
  final bool isEdit;

  ConcernInputScreen({super.key, required this.isEdit});

  @override
  _ConcernInputScreenState createState() => _ConcernInputScreenState();
}

class _ConcernInputScreenState extends State<ConcernInputScreen> with SingleTickerProviderStateMixin {
  final List<String> _concerns = [
    '좁은 인간 관계', '이유 불명 우울함', '연인 관계', '건강', '가족 관계', '자기개발에 대한 부담',
    '학교 성적', '빠지지 않는 살', '친구와의 다툼', '떠오르는 흑역사', '미래에 대한 불안',
    '취업 및 진로', '급격하게 늘어난 잠', '경제적 어려움', '대인 관계', '직장 내 인간 관계', '딱히 없음'
  ];
  final Set<String> _selectedConcerns = {};
  bool _isOverLimit = false;
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });
    _shakeAnimation = Tween<double>(begin: 0, end: 8).chain(CurveTween(curve: Curves.elasticIn)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleConcern(String concern) {
    setState(() {
      if (concern == '딱히 없음') {
        _selectedConcerns.clear();
        _selectedConcerns.add(concern);
        _isOverLimit = false; // "딱히 없음" 선택 시 초기화
      } else {
        _selectedConcerns.remove('딱히 없음');

        if (_selectedConcerns.contains(concern)) {
          _selectedConcerns.remove(concern);
          _isOverLimit = false; // 선택 해제하면 즉시 경고 해제
        } else {
          if (_selectedConcerns.length < 3) {
            _selectedConcerns.add(concern);
            _isOverLimit = false; // 3개 이하 선택 시 정상 동작
          } else {
            _isOverLimit = true; // 4개째 선택하려 하면 경고만 띄움
            _controller.forward(from: 0); // 흔들림 애니메이션
          }
        }
      }
    });
  }

  void _onNextPressed() async {
    Navigator.pop(context);
    if (_selectedConcerns.isNotEmpty) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (widget.isEdit) {
        userProvider.updateConcerns(_selectedConcerns.toList());

        final response = await http.put(
          Uri.parse('https://www.emoti.kr/users/update/concerns'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "id": Provider.of<UserProvider>(navigatorKey.currentContext!, listen: false).id,
            "concerns": _selectedConcerns.toList()
            }),
        );
        if (response.statusCode != 200) {
        }

        Navigator.pop(context);
      }
      else {
        userProvider.setConcerns(_selectedConcerns.toList());

        final userDto = {
          'id': userProvider.id,
          'nickname': userProvider.nickname,
          'gender': userProvider.gender,
          'concerns': userProvider.concerns,
          'pet': userProvider.pet,
          'stamp': userProvider.stamp,
          'level': userProvider.level,
        };

        await http.post(
          Uri.parse('https://www.emoti.kr/users'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userDto),
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EBD9),
      appBar: AppBar(
        title: const Text('세부 정보', style: TextStyle(
          fontFamily: 'DungGeunMo',color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
body: Padding(
  padding: const EdgeInsets.all(20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ProgressBar(progress: 0.8),
      const SizedBox(height: 30),
      const Text(
        '최근 고민되는 일이 있나요?',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'DungGeunMo',
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 15),
      const Text(
        '※ 사용자에 관한 데이터가 많을수록\n  AI의 상담 수준이 높아져요!\n※ 3개까지 선택할 수 있어요.',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          fontFamily: 'DungGeunMo',
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 20),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                        color: isSelected
                            ? const Color.fromARGB(214, 255, 255, 255)
                            : const Color(0xFFD6D9AC),
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(color: const Color(0xFFD6D9AC), width: 2)
                            : null,
                      ),
                      child: Text(
                        concern,
                        style: TextStyle(
                          fontFamily: 'DungGeunMo',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              if (_isOverLimit)
                Transform.translate(
                  offset: Offset(_shakeAnimation.value - 4, 0),
                  child: const Text(
                    '※ 3개만 선택 가능해요!',
                    style: TextStyle(
                      fontFamily: 'DungGeunMo',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 180,
          height: 50,
          child: ElevatedButton(
            onPressed: _selectedConcerns.isNotEmpty ? _onNextPressed : null,
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
      const SizedBox(height: 30),
    ],
  ),
),

    );
  }
}