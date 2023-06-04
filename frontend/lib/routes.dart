import 'package:myspots/create-reel/create-reels.dart';
import 'package:myspots/home/home.dart';
import 'package:myspots/login/login.dart';
import 'package:myspots/profile/profile.dart';
import 'package:myspots/saved/saved.dart';
import 'package:myspots/search-reels/search-reels.dart';
import 'package:myspots/signup/signup.dart';
import 'package:myspots/splash/splash.dart';
import 'package:myspots/view-reels/view-reels.dart';
import 'package:myspots/welcome/welcome.dart';

var appRoutes = {
  '/': (context) => WelcomeScreen(),
  '/home': (context) => HomeScreen(),
  '/login': (context) => LoginScreen(),
  '/signup': (context) => SignUpScreen(),
  '/splash': (context) => SplashScreen(),
  '/welcome': (context) => WelcomeScreen(),
  '/view-reels': (context) => ViewReelsScreen(),
  '/create-reel': (context) => CreateReelScreen(),
  '/search-reels': (context) => SearchScreen(),
  '/profile': (context) => ProfileScreen(),
  '/saved-reels': (context) => SavedScreen(),
};
