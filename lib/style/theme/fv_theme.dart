import 'package:flutter/material.dart';

import '../colors/fv_colors.dart';
import '../typography/fv_text_styles.dart';

class FvTheme {

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: FvTextStyles.displayLarge,
      displayMedium: FvTextStyles.displayMedium,
      displaySmall: FvTextStyles.displaySmall,
      headlineLarge: FvTextStyles.headlineLarge,
      headlineMedium: FvTextStyles.headlineMedium,
      headlineSmall: FvTextStyles.headlineSmall,
      titleLarge: FvTextStyles.titleLarge,
      titleMedium: FvTextStyles.titleMedium,
      titleSmall: FvTextStyles.titleSmall,
      bodyLarge: FvTextStyles.bodyLargeBold,
      bodyMedium: FvTextStyles.bodyLargeMedium,
      bodySmall: FvTextStyles.bodyLargeRegular,
      labelLarge: FvTextStyles.labelLarge,
      labelMedium: FvTextStyles.labelMedium,
      labelSmall: FvTextStyles.labelSmall,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: FvColors.blue.color,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: FvColors.blue.color,
      brightness: Brightness.dark,
      textTheme: _textTheme,
      useMaterial3: true,
    );
  }
}