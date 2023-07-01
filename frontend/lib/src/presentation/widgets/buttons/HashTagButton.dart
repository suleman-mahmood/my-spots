import 'package:flutter/material.dart';

class TranslucentGreyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  TranslucentGreyButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.grey.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
      child: Text('# ' + text),
    );
  }
}
