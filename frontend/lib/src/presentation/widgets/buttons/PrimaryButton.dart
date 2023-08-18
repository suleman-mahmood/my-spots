import 'package:flutter/material.dart';
import 'package:myspots/src/config/themes/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const PrimaryButton({
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
    // print(height4);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(height4),
        backgroundColor: Color(0xFF88B930), // background color of the button
        foregroundColor: Colors.white, // font color of the button
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
