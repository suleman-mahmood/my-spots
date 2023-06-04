import 'package:flutter/material.dart';
import 'package:myspots/theme.dart';

class CommentInput extends StatelessWidget {
  final String labelText;
  final Widget prefixIcon;
  final bool obscureText;

  final void Function(String) onChanged;
  final void Function() onSubmit;
  final String? Function(String?)? validator;

  const CommentInput({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    required this.onChanged,
    required this.onSubmit,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        prefixIconColor: secondaryColor1,
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: onSubmit,
        ),
        suffixIconColor: secondaryColor1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: secondaryColor1, width: 2),
        ),
      ),
    );
  }
}
