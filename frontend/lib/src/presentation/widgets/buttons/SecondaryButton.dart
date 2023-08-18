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
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).viewPadding;
    double height3 = height - padding.top - kToolbarHeight;
    double height4 = height3 / 55;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(height4),
        backgroundColor: Colors.white, // background color of the button
        foregroundColor: Color(0xFF88B930),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
