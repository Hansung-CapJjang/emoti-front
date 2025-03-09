import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'firstIntro.dart';
import 'package:flutter_application_1/mainScreen.dart';
import 'package:flutter_application_1/homeScreen.dart';

class ConcernInputScreen extends StatefulWidget {
  const ConcernInputScreen({super.key});

  @override
  _ConcernInputScreenState createState() => _ConcernInputScreenState();
}

class _ConcernInputScreenState extends State<ConcernInputScreen> {
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
      backgroundColor: const Color(0xFFE3E7C0), // ����
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
  crossAxisAlignment: CrossAxisAlignment.start, // �ؽ�Ʈ�� ���� ����
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
              color: isSelected ? const Color.fromARGB(214, 255, 255, 255) : const Color(0xFFD6D9AC),
              // color: isSelected ? const Color.fromARGB(255, 134, 109, 51) : const Color(0xFFD6D9AC),
              borderRadius: BorderRadius.circular(10),
              border: isSelected ? Border.all(color: const Color(0xFFD6D9AC), width: 2) : null,
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
    const Spacer(flex: 10),
    Align(
      alignment: Alignment.center, 
      child: SizedBox(
        width: 180,
        height: 50,
        child: ElevatedButton(
          onPressed: _selectedConcerns.isNotEmpty
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('다음 화면으로 이동')),
                  );
                  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
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