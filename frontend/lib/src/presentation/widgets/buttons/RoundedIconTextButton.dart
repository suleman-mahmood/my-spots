import 'dart:async';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  RoundedIconButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).viewPadding;
    double height3 = height - padding.top - kToolbarHeight;
    double height4 = height3 / 10;
    double width_screen = MediaQuery.of(context).size.width;
    print("Width screen: ");
    print(width_screen);
    final StreamController<ButtonState> _buttonStateController =
        StreamController<ButtonState>();

    return StreamBuilder<ButtonState>(
      stream: _buttonStateController.stream,
      initialData: ButtonState.idle,
      builder: (context, snapshot) {
        return Container(
          width: width_screen / 3,
          height: height4,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: ProgressButton.icon(
                iconedButtons: {
                  ButtonState.idle: IconedButton(
                    text: "Follow",
                    icon: Icon(
                      Icons.person_add_alt_outlined,
                      size: 24,
                      color: Colors.white,
                    ),
                    color: Color(0xFFD9D9D9).withOpacity(0.4),
                  ),
                  ButtonState.loading: IconedButton(
                    text: "Loading",
                    color: Colors.orangeAccent.withOpacity(0.3),
                  ),
                  ButtonState.fail: IconedButton(
                    text: "Failed",
                    icon: Icon(
                      Icons.person_2_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  ButtonState.success: IconedButton(
                    text: "Followed",
                    icon: Icon(
                      Icons.person_2_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    color: Color(0xFFD9D9D9).withOpacity(0.4),
                  ),
                },
                onPressed: () async {
                  if (snapshot.data == ButtonState.success) {
                    _buttonStateController.add(ButtonState.loading);
                    await Future.delayed(Duration(seconds: 1));
                    _buttonStateController.add(ButtonState.idle);
                    return;
                  }

                  _buttonStateController.add(ButtonState.loading);

                  await Future.delayed(Duration(seconds: 1));

                  try {
                    await onPressed;
                    _buttonStateController.add(ButtonState.success);
                  } catch (error) {
                    _buttonStateController.add(ButtonState.fail);
                  }
                },
                state: snapshot.data,
              ),
            ),
          ),
        );
      },
    );
  }
}
