import 'package:flutter/material.dart';

class VideogamesFilterBox extends StatelessWidget {
  const VideogamesFilterBox(
      {super.key,
      required this.filter,
      required this.onPressed,
      required this.isSelected});

  final String filter;

  final bool isSelected;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff1971c2) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xff1971c2),
            width: 2,
          ),
        ),
        child: Text(
          filter,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xff1971c2),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito',
          ),
        ),
      ),
    );
  }
}
