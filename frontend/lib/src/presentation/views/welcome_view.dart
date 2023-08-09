import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:myspots/src/config/router/app_router.dart';
import 'package:myspots/src/presentation/widgets/buttons/PrimaryButton.dart';
import 'package:myspots/src/presentation/widgets/buttons/SecondaryButton.dart';
import 'package:myspots/src/presentation/widgets/layouts/AuthLayout.dart';
import 'package:myspots/src/presentation/widgets/typography/BodyText.dart';
import 'package:myspots/src/config/themes/theme.dart';

@RoutePage()
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

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
                  fontSize: 56,
                )),
            Text(
              ' Spot',
              style: TextStyle(
                color: secondaryColor1,
                fontWeight: FontWeight.w900,
                fontSize: 56,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        PrimaryButton(
          buttonText: "Login",
          onPressed: () => {context.router.push(LoginRoute())},
        ),
        const SizedBox(
          height: 16,
        ),
        SecondaryButton(
          buttonText: "Create new account",
          onPressed: () => {context.router.push(SignupRoute())},
        ),
        const SizedBox(
          height: 8,
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
