import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myspots/services/auth.dart';
import 'package:myspots/shared/buttons/PrimaryButton.dart';
import 'package:myspots/shared/inputs/TextInput.dart';
import 'package:myspots/shared/layouts/AuthLayout.dart';
import 'package:myspots/shared/typography/BodyText.dart';
import 'package:myspots/shared/typography/LinkText.dart';
import 'package:myspots/shared/typography/MainHeading.dart';
import 'package:myspots/theme.dart';
import 'package:provider/provider.dart';

import 'package:myspots/services/models.dart' as model;

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  String fullName = '';
  String email = '';
  String password = '';

  final _signInFormKey = GlobalKey<FormState>();

  void _submit(BuildContext context) async {
    if (!_signInFormKey.currentState!.validate()) {
      return;
    }

    context.read<model.AppState>().removeErrorMessage();
    context.read<model.AppState>().startLoading();
    try {
      await AuthService().signUpWithEmailPassword(
        email,
        password,
        fullName,
        context,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      context.read<model.AppState>().setErrorMessage(e.message ?? '');
      context.read<model.AppState>().stopLoading();
      return;
    }

    context.read<model.AppState>().stopLoading();

    Navigator.pushNamed(context, '/home');
  }

  Future<void> _handleGoogleSignin(BuildContext context) async {
    context.read<model.AppState>().removeErrorMessage();

    try {
      await AuthService().signInWithGoogle(context);
    } on FirebaseAuthException catch (e) {
      print(e);
      context.read<model.AppState>().setErrorMessage(e.message ?? '');
      return;
    }

    Navigator.pushNamed(context, '/home');
  }

  void _handleFacebookSignin(BuildContext context) async {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      children: [
        const MainHeading(text: 'Hello!'),
        const MainHeading(text: 'Please Sign Up to continue'),
        const SizedBox(height: 20),
        Form(
          key: _signInFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextInput(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.account_circle_outlined),
                onChanged: (v) => fullName = v,
                validator: (nameValue) {
                  if (nameValue == null) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextInput(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                onChanged: (v) => email = v,
                validator: (emailValue) {
                  if (emailValue == null) {
                    return "Please enter your email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextInput(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outlined),
                onChanged: (v) => password = v,
                validator: (passwordValue) {
                  if (passwordValue == null) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                buttonText: 'Sign Up',
                onPressed: () => _submit(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const BodyText(text: 'Continue with'),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // GestureDetector(
            //   onTap: () => _handleFacebookSignin(context),
            //   child: Container(
            //     padding: EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //       color: Colors.blue,
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //     child: Row(
            //       children: const [
            //         Icon(
            //           Icons.facebook,
            //           color: Colors.white,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 20),
            GestureDetector(
              onTap: () => _handleGoogleSignin(context),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.g_mobiledata,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            const BodyText(
              text: 'Have an account? ',
            ),
            LinkText(
              text: 'Login',
              textColor: secondaryColor1,
              onPressed: () => {
                Navigator.pushNamed(context, '/login'),
              },
            ),
          ],
        ),
      ],
    );
  }
}
