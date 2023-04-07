import 'package:flutter/material.dart';
import 'package:myspots/shared/buttons/PrimaryButton.dart';
import 'package:myspots/shared/buttons/SecondaryButton.dart';
import 'package:myspots/shared/layouts/AuthLayout.dart';
import 'package:myspots/shared/typography/BodyText.dart';
import 'package:myspots/theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      backgroundColor: Colors.yellow,
      children: [
        Image.asset(
          "assets/images/logo.png",
          width: 200,
          height: 200,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('My',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 36,
                )),
            Text(
              ' Spot',
              style: TextStyle(
                color: secondaryColor1,
                fontWeight: FontWeight.w900,
                fontSize: 36,
              ),
            ),
          ],
        ),
        PrimaryButton(
          buttonText: "Login",
          onPressed: () => {Navigator.pushNamed(context, '/login')},
        ),
        SecondaryButton(
          buttonText: "Create new account",
          onPressed: () => {Navigator.pushNamed(context, '/signup')},
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            BodyText(
              text: 'By signing up you agree to the ',
            ),
            BodyText(
              text: 'Terms of use & privacy policy',
              textColor: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }
}
