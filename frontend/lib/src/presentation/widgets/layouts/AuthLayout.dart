import 'package:flutter/material.dart';
import 'package:myspots/src/services/models.dart' as model;
import 'package:myspots/src/presentation/widgets/typography/BodyText.dart';
import 'package:provider/provider.dart';

class AuthLayout extends StatelessWidget {
  final List<Widget> children;
  final Color backgroundColor;

  const AuthLayout({
    Key? key,
    required this.children,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Consumer<model.AppState>(
            builder: (context, appState, child) {
              if (appState.isLoading) {
                return const CircularProgressIndicator();
              }
              return SizedBox(
                width: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...children,
                    appState.erroMessage.isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: BodyText(
                              text: appState.erroMessage,
                              textColor: Colors.red,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
