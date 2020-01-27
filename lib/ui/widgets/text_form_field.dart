import 'package:flutter/material.dart';
import '../theme.dart';

// custon textfield used in registration and login page

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {this.icon,
      this.hint,
      this.obscure = false,
      this.validator,
      this.onChanged,
      this.controller});
  final Function onChanged;
  final Icon icon;
  final String hint;
  final bool obscure;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      autofocus: false,
      obscureText: obscure,
      style: buildTheme().textTheme.button,
      decoration: InputDecoration(
        hintStyle: buildTheme().textTheme.button,
        hintText: hint,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: const BorderRadius.all(
             Radius.circular(2),
          ),
        ),
        labelStyle: buildTheme().textTheme.button,
        filled: true,
        fillColor: const Color(0xF0111114).withOpacity(0.8),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
        ),
      ),
    );
  }
}
