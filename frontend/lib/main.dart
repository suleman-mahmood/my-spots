import 'package:flutter/material.dart';
import 'package:myspots/routes.dart';
import 'package:myspots/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Spots',
      theme: appTheme,
      routes: appRoutes,
    );
  }
}
