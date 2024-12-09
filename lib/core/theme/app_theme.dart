import 'package:flutter/material.dart';

const Color _primaryColor = Color(0xFF6200EE);
const Color _secondaryColor = Color(0xFF03DAC6);

//List<Color> _colors = [_primaryColor, _secondaryColor];

class AppTheme {
  ThemeData theme() {
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.white);
  }
}
