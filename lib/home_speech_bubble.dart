import 'package:flutter/material.dart';

class SpeechBubblePainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;

  SpeechBubblePainter({required this.fillColor, this.borderColor = Colors.green});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // �׵θ� �β�

    final path = Path();
    const radius = 12.0; // ��ǳ�� �ձ� �𼭸� ������
    const tailHeight = 12.0; // ���� ����
    const tailWidth = 20.0; // ���� �ʺ�

    // ��ǳ�� ��� ���� �ձ� �κ�
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    
    // ������
    path.lineTo(size.width, size.height - tailHeight - radius);
    path.quadraticBezierTo(size.width, size.height - tailHeight, size.width - radius, size.height - tailHeight);
    
    // ��ǳ�� ���� (�ﰢ��)
    path.lineTo(size.width / 2 + tailWidth / 2, size.height - tailHeight);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 - tailWidth / 2, size.height - tailHeight);
    
    // ������
    path.lineTo(radius, size.height - tailHeight);
    path.quadraticBezierTo(0, size.height - tailHeight, 0, size.height - tailHeight - radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    // ���� ���� ä���
    canvas.drawPath(path, paint);

    // �׵θ� �׸���
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ��ǳ�� ����
class SpeechBubble extends StatelessWidget {
  final String text;
  final Color fillColor;
  final Color borderColor;

  const SpeechBubble({
    Key? key,
    required this.text,
    this.fillColor = Colors.white,
    this.borderColor = const Color.fromARGB(255, 48, 67, 34), // �⺻ �׵θ� ���� �ʷ�
  }) : super(key: key);

  @override
Widget build(BuildContext context) {
  return Container(
    constraints: const BoxConstraints(minWidth: 100, minHeight: 50), // �ּ� ũ�� ����
    child: CustomPaint(
      size: const Size(160, 60), // ��ǳ�� ũ�� ���������� ����
      painter: SpeechBubblePainter(fillColor: fillColor, borderColor: borderColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // ? vertical ���̱�
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'DungGeunMo',
          ),
        ),
      ),
    ),
  );
}
}