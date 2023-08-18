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
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).viewPadding;
    double height3 = height - padding.top - kToolbarHeight;
    double height4 = height3 / 5;
    double width_screen = MediaQuery.of(context).size.width;
    // print(width);
    // print(height4);

    // double quarterHeight = screenHeight * 0.00025;
    // print(quarterHeight);

    return AuthLayout(
      backgroundColor: const Color(0xFF132B32),
      children: [
        // Image.asset(
        //   "assets/images/logo.png",
        //   wid  th: 200,
        //   height: 200,
        // ),
        SizedBox(height: height4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('My',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: width_screen / 8,
                )),
            Text(
              ' Spot',
              style: TextStyle(
                color: Color(0xFF88B930),
                fontWeight: FontWeight.w900,
                fontSize: width_screen / 8,
              ),
            ),
          ],
        ),
        SizedBox(
          height: height4 / 4,
        ),
        PrimaryButton(
          buttonText: "Login",
          onPressed: () => {context.router.push(LoginRoute())},
        ),
        SizedBox(
          height: height4 / 9,
        ),
        SecondaryButton(
          buttonText: "Create new account",
          onPressed: () => {context.router.push(SignupRoute())},
        ),
        SizedBox(
          height: height4 / 8,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            BodyText(
              text: 'By signing up you agree to the ',
              textColor: Colors.white,
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
