import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashView extends StatelessWidget {
  const SplashView({super.key});

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
