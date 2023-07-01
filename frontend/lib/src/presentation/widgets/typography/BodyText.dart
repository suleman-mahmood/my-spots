import 'package:flutter/material.dart';

class BodyText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color textColor;

  const BodyText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.center,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: textColor,
      ),
    );
  }
}
