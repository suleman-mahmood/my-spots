import 'package:flutter/material.dart';
import 'package:myspots/src/config/themes/theme.dart';

class MainHeading extends StatelessWidget {
  final String text;

  const MainHeading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: secondaryColor1,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
