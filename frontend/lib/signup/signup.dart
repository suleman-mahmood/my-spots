import 'package:flutter/material.dart';
import 'package:myspots/shared/buttons/PrimaryButton.dart';
import 'package:myspots/shared/inputs/TextInput.dart';
import 'package:myspots/shared/layouts/AuthLayout.dart';
import 'package:myspots/shared/typography/BodyText.dart';
import 'package:myspots/shared/typography/LinkText.dart';
import 'package:myspots/shared/typography/MainHeading.dart';
import 'package:myspots/theme.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      children: [
        const MainHeading(text: 'Hello!'),
        const MainHeading(text: 'Please Sign Up to continue'),
        const SizedBox(height: 20),
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TextInput(
                labelText: 'Name',
                prefixIcon: Icon(Icons.account_circle_outlined),
              ),
              const SizedBox(height: 10),
              const TextInput(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 10),
              const TextInput(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outlined),
              ),
              const SizedBox(height: 10),
              PrimaryButton(buttonText: 'Sign Up', onPressed: () => {}),
              // onPressed: () {
              // if (_formKey.currentState.validate()) {
              //   _formKey.currentState.save();
              //   // TODO: submit the form data
              // }
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
              onTap: () {
                // TODO: handle Facebook login
              },
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
              onTap: () {
                // TODO: handle Google login
              },
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
