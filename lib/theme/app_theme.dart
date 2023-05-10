import 'package:flutter/material.dart';
import 'package:todo/theme/theme.dart';

class AppTheme {
  static ThemeData theme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.redColor,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.redColor,
    ),
  );
}