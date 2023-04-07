import 'package:flutter/material.dart';
import 'package:myspots/theme.dart';

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
        backgroundColor: Colors.white, // background color of the button
        foregroundColor: secondaryColor1, // font color of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }
}
