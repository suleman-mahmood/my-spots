import 'package:flutter/material.dart';
import 'package:myspots/theme.dart';

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  CategoryButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              primary: Colors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              minimumSize: Size(80.0, 80.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: secondaryColor1, size: 50),
              ],
            ),
          ),
          SizedBox(height: 5),
          Text(text),
        ],
      ),
    );
  }
}
