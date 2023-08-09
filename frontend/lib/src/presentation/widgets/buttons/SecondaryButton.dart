import 'package:flutter/material.dart';
import 'package:myspots/src/config/themes/theme.dart';

class SecondaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const SecondaryButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(12),
        backgroundColor: Colors.white, // background color of the button
        foregroundColor: secondaryColor1, // font color of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        textScaleFactor: 1.5,
      ),
    );
  }
}
