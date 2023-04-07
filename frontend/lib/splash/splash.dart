import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.yellow,
        body: Center(
          child: Image.asset(
            "assets/images/logo.png",
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}
