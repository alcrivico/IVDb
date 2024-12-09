import 'package:flutter/material.dart';

class TextFieldBox extends StatelessWidget {
  const TextFieldBox(String s,
      {super.key,
      required this.label,
      required this.controller,
      this.hint = '',
      this.obscureText = false,
      this.color = const Color(0xff1971c2)});

  final String hint;
  final String label;
  final bool obscureText;
  final Color color;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    OutlineInputBorder outlineBorder = OutlineInputBorder(
        borderSide: BorderSide(color: color, width: size.height * 0.005),
        borderRadius: const BorderRadius.all(Radius.circular(20)));

    InputDecoration inputDecoration = InputDecoration(
      enabledBorder: outlineBorder,
      border: outlineBorder,
      focusedBorder: outlineBorder,
      hintText: hint,
      hintStyle: TextStyle(
          color: color,
          fontSize: 20,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.bold),
      labelText: label,
      labelStyle: TextStyle(
          color: color,
          fontSize: 20,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.bold),
    );

    return TextFormField(
        controller: controller,
        decoration: inputDecoration,
        obscureText: obscureText,
        onTapOutside: (event) {
          if (controller.text.isEmpty) {
            FocusScope.of(context).requestFocus(FocusNode());
          }
        });
  }
}
