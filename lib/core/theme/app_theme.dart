import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    textTheme:
        GoogleFonts.aBeeZeeTextTheme(),

    scaffoldBackgroundColor:
        AppColors.light,

    colorScheme: ColorScheme.light(
      primary: AppColors.pink,

      secondary: AppColors.blue,

      surface: AppColors.light,

      onPrimary: Colors.white,

      onSecondary: Colors.white,

      onSurface: AppColors.darkGray,
    ),
  );
}