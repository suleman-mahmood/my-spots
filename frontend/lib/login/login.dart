import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myspots/services/auth.dart';
import 'package:myspots/services/backend.dart';
import 'package:myspots/shared/buttons/PrimaryButton.dart';
import 'package:myspots/shared/inputs/TextInput.dart';
import 'package:myspots/shared/layouts/AuthLayout.dart';
import 'package:myspots/shared/typography/BodyText.dart';
import 'package:myspots/shared/typography/LinkText.dart';
import 'package:myspots/shared/typography/MainHeading.dart';
import 'package:myspots/theme.dart';

import 'package:myspots/services/models.dart' as model;

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  String email = '';
  String password = '';

  final _loginFormKey = GlobalKey<FormState>();

  Future<void> _submit(BuildContext context) async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }

    await AuthService().signInWithEmailAndPassword(
      email,
      password,
      context,
    );

    // Navigator.pushNamed(context, '/home');
  }

  Future<void> _handleGoogleSignin(BuildContext context) async {
    await AuthService().signInWithGoogle(context);

    Navigator.pushNamed(context, '/home');
  }

  void _handleFacebookSignin(BuildContext context) async {
    throw UnimplementedError();
  }

  void _showForgotPasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const MainHeading(text: 'Forgot your password?'),
                const SizedBox(height: 10),
                const BodyText(
                    text:
                        'Enter your email and we will send a link to reset your password'),
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
                PrimaryButton(
                  buttonText: 'Reset',
                  onPressed: () => {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      children: [
        const MainHeading(text: 'Welcome Back!'),
        const MainHeading(text: 'Please login to continue'),
        const SizedBox(height: 20),
        Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              LinkText(
                text: 'Forgot password?',
                textAlign: TextAlign.right,
                onPressed: () => {_showForgotPasswordSheet(context)},
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                buttonText: 'Login',
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
            GestureDetector(
              onTap: () => _handleFacebookSignin(context),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.facebook,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
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
              text: 'Dont have an account? ',
            ),
            LinkText(
              text: 'SignUp',
              textColor: secondaryColor1,
              onPressed: () => {
                Navigator.pushNamed(context, '/signup'),
              },
            ),
          ],
        ),
      ],
    );
  }
}
