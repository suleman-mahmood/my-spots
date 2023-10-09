import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myspots/src/config/router/app_router.dart';
import 'package:myspots/src/services/auth.dart';
import 'package:myspots/src/presentation/widgets/buttons/PrimaryButton.dart';
import 'package:myspots/src/presentation/widgets/inputs/TextInput.dart';
import 'package:myspots/src/presentation/widgets/layouts/AuthLayout.dart';
import 'package:myspots/src/presentation/widgets/typography/BodyText.dart';
import 'package:myspots/src/presentation/widgets/typography/LinkText.dart';
import 'package:myspots/src/presentation/widgets/typography/MainHeading.dart';
import 'package:myspots/src/config/themes/theme.dart';
import 'package:provider/provider.dart';
import 'package:myspots/src/services/models.dart' as model;

@RoutePage()
class LoginView extends StatelessWidget {
  LoginView({Key? key});

  String email = 'sulemanmahmood99@gmail.com';
  String password = '12341234';

  final _loginFormKey = GlobalKey<FormState>();

  Future<void> _submit(BuildContext context) async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }

    context.read<model.AppState>().removeErrorMessage();
    context.read<model.AppState>().startLoading();

    try {
      await AuthService().signInWithEmailAndPassword(
        email,
        password,
        context,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      context.read<model.AppState>().setErrorMessage(e.message ?? '');
      context.read<model.AppState>().stopLoading();
      return;
    }

    context.read<model.AppState>().stopLoading();

    context.router.push(DashboardRoute());
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

    context.router.push(DashboardRoute());
  }

  void _handleFacebookSignin(BuildContext context) async {
    throw UnimplementedError();
  }

  void _handlePasswordReset(BuildContext context) async {
    context.read<model.AppState>().removeErrorMessage();

    context.read<model.AppState>().startLoading();
    try {
      await AuthService().sendPasswordResetEmail(email);
    } on FirebaseAuthException catch (e) {
      print(e);
      context.read<model.AppState>().stopLoading();
      context.read<model.AppState>().setErrorMessage(e.message ?? '');
      Navigator.pop(context);
      return;
    }
    context.read<model.AppState>().stopLoading();
    Navigator.pop(context);
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
                MainHeading(text: 'Forgot your password?'),
                const SizedBox(height: 10),
                const BodyText(
                  text: 'Enter your email and we will send a link to reset your password',
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
                PrimaryButton(
                  buttonText: 'Reset',
                  onPressed: () => _handlePasswordReset(context),
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
        MainHeading(text: 'Welcome Back!'),
        MainHeading(text: 'Please login to continue'),
        const SizedBox(height: 20),
        Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                elevation: 3,
                child: TextInput(
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
              ),
              const SizedBox(height: 10),
              Material(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                elevation: 3,
                child: TextInput(
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
              ),
              const SizedBox(height: 10),
              LinkText(
                text: 'Forgot password?',
                textAlign: TextAlign.right,
                onPressed: () => _showForgotPasswordSheet(context),
              ),
              const SizedBox(height: 10),
              Material(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                elevation: 3,
                child: PrimaryButton(
                  buttonText: 'Login',
                  onPressed: () => _submit(context),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // const BodyText(text: 'Continue with'),
        // const SizedBox(height: 10),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
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
        // GestureDetector(
        //   onTap: () => _handleGoogleSignin(context),
        //   child: Container(
        //     padding: EdgeInsets.all(10),
        //     decoration: BoxDecoration(
        //       color: Colors.red,
        //       borderRadius: BorderRadius.circular(30),
        //     ),
        //     child: Row(
        //       children: const [
        //         Icon(
        //           Icons.g_mobiledata,
        //           color: Colors.white,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        //   ],
        // ),
        const SizedBox(height: 56),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            const BodyText(
              text: 'Don\'t have an account? ',
            ),
            LinkText(
              text: 'Sign Up',
              textColor: secondaryColor1,
              onPressed: () => {
                context.router.push(SignupRoute()),
              },
            ),
          ],
        ),
      ],
    );
  }
}
