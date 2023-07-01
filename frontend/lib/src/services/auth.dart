import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myspots/src/services/backend.dart';
import 'package:myspots/src/services/exceptions.dart';
import 'package:provider/provider.dart';
import 'package:myspots/src/services/models.dart' as model;

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;
  final isUserLoggedIn =
      FirebaseAuth.instance.currentUser == null ? false : true;

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    await BackendService().createUser(model.User(
      email: googleUser?.email ?? '',
      fullName: googleUser?.displayName ?? '',
      avatarUrl:
          'https://static.vecteezy.com/system/resources/previews/005/055/137/original/cute-panda-mascot-cartoon-icon-kawaii-mascot-character-illustration-for-sticker-poster-animation-children-book-or-other-digital-and-print-product-vector.jpg',
    ));

    await _handleAuthSuccess(context, userCredential);

    return userCredential;
  }

  Future<UserCredential> signUpWithEmailPassword(
    String email,
    String password,
    String fullName,
    BuildContext context,
  ) async {
    final userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCredential.user?.sendEmailVerification();

    // Persist email and password to local storage
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString("rollNumber", rollNumber.getRollNumber);
    // await prefs.setString("password", password);

    print("Before create user call");
    await BackendService().createUser(model.User(
      email: email,
      fullName: fullName,
      avatarUrl:
          'https://static.vecteezy.com/system/resources/previews/005/055/137/original/cute-panda-mascot-cartoon-icon-kawaii-mascot-character-illustration-for-sticker-poster-animation-children-book-or-other-digital-and-print-product-vector.jpg',
    ));
    print("After successful create user call");

    await _handleAuthSuccess(context, userCredential);

    return userCredential;
  }

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    final userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user == null) {
      throw UserIsNull(
        "Can't find logged in user using firebase's authentication service",
      );
    }
    if (!userCredential.user!.emailVerified) {
      throw EmailUnverified("User has not verified his email");
    }

    await _handleAuthSuccess(context, userCredential);

    return userCredential;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> sendEmailVerification() async {
    await user?.sendEmailVerification();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> _handleAuthSuccess(
    BuildContext context,
    UserCredential userCredential,
  ) async {
    final token = await userCredential.user?.getIdToken() ?? '';
    final user = await BackendService().getUser(token);

    context.read<model.User>().setAccessToken(token);
    context.read<model.User>().updateUser(user);
  }
}
