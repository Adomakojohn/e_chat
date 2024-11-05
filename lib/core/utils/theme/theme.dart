import 'package:chat_app/core/utils/theme/text_theme.dart';
import 'package:flutter/material.dart';

class CAppTheme {
  CAppTheme._();
//light theme
  static final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: CTextTheme.lightTextTheme,
      cardTheme: _cardThemeLight);

  //dark theme
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF2c2d3a),
    textTheme: CTextTheme.darkTextTheme,
    cardTheme: _cardThemeDark,
  );

  static CardTheme get _cardThemeLight {
    return const CardTheme(
      color: Color.fromARGB(255, 157, 216, 244),
    );
  }

  // Card theme for dark theme
  static CardTheme get _cardThemeDark {
    return CardTheme(
      color: Colors.lightBlue[900],
    );
  }
}
