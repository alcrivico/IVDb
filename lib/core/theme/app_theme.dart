import 'package:flutter/material.dart';

//List<Color> _colors = [_primaryColor, _secondaryColor];

class AppTheme {
  ThemeData theme() {
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.white);
  }
}
