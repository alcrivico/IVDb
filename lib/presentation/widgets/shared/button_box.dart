import 'package:flutter/material.dart';

class ButtonBox extends StatelessWidget {
  const ButtonBox(
      {super.key,
      required this.onPressed,
      this.color = const Color(0xff1971c2),
      this.borderRadius = const BorderRadius.all(Radius.circular(20)),
      this.text = 'Aceptar',
      this.textColor = const Color(0xffffffff),
      this.textSize = 20,
      this.textStyle = FontStyle.normal,
      this.elevation = 10,
      this.onHover});

  final Color color;
  final BorderRadius borderRadius;
  final String text;
  final Color textColor;
  final double textSize;
  final FontStyle textStyle;
  final VoidCallback onPressed;
  final VoidCallback? onHover;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        if (onHover != null) {
          onHover!();
        }
      },
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: textSize,
            color: textColor,
            fontStyle: FontStyle.normal,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
