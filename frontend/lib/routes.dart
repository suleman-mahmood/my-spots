import 'package:myspots/home/home.dart';
import 'package:myspots/login/login.dart';
import 'package:myspots/signup/signup.dart';
import 'package:myspots/splash/splash.dart';
import 'package:myspots/welcome/welcome.dart';

var appRoutes = {
  '/': (context) => WelcomeScreen(),
  '/home': (context) => HomeScreen(),
  '/login': (context) => LoginScreen(),
  '/signup': (context) => SignUpScreen(),
  '/splash': (context) => SplashScreen(),
  '/welcome': (context) => WelcomeScreen(),
};
