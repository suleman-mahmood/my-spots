import 'package:flutter/material.dart';
import 'package:myspots/theme.dart';

class TextInput extends StatelessWidget {
  final String labelText;
  final Widget prefixIcon;
  final bool obscureText;

  final void Function(String) onChanged;
  final String? Function(String?)? validator;

  const TextInput({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    required this.onChanged,
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
        // hintText: 'email dalo',
        // hintStyle: TextStyle(
        //   color: Colors.grey,
        //   fontStyle: FontStyle.italic,
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: secondaryColor1, width: 2),
        ),
      ),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter your email';
      //   }
      //   if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      //     return 'Please enter a valid email address';
      //   }
      //   return null;
      // },
      // onSaved: (value) {
      //   _email = value;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter your password';
      //   }
      //   if (value.length < 6) {
      //     return 'Password must be at least 6 characters';
      //   }
      //   return null;
      // },
      // onSaved: (value) {
      //   _password = value;
      // },
    );
  }
}
