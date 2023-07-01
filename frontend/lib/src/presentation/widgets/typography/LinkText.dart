import 'package:flutter/material.dart';

class LinkText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color textColor;
  final VoidCallback onPressed;

  static void _defaultCallback() {}

  const LinkText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.center,
    this.textColor = Colors.black,
    this.onPressed = _defaultCallback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(color: textColor),
      ),
      onTap: onPressed,
    );
  }
}
