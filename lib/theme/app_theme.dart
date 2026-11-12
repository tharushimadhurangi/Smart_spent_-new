
import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF071226);
  static const card = Color(0xFF101D35);
  static const input = Color(0xFF0D1B33);
  static const border = Color(0xFF294577);

  static const primary = Color(0xFF702BFF);
  static const secondary = Color(0xFFB52CFA);

  static const text = Color(0xFFFFFFFF);
  static const mutedText = Color(0xFFB9C9E8);

  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
}

class AppTheme {
  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  static void toggleTheme() {
    themeMode.value = themeMode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      AppColors.primary,
      AppColors.secondary,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      fontFamily: 'Roboto',

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.card,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: AppColors.text,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),

      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.input,
        hintStyle: const TextStyle(color: AppColors.mutedText),
        prefixIconColor: AppColors.mutedText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.secondary,
            width: 1.5,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.card,
        indicatorColor: Color(0xFF352064),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),

      iconTheme: const IconThemeData(
        color: AppColors.mutedText,
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: AppColors.text),
        bodyMedium: TextStyle(color: AppColors.mutedText),
      ),
    );
  }

  static ThemeData get lightTheme {
    const lightBackground = Color(0xFFF5F6FC);
    const lightCard = Colors.white;
    const lightText = Color(0xFF172033);
    const lightMuted = Color(0xFF65708A);
    const lightBorder = Color(0xFFE1E5F0);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: AppColors.primary,
      fontFamily: 'Roboto',

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: lightCard,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: lightText,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: lightText,
        elevation: 0,
      ),

      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: lightBorder),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0F2F8),
        hintStyle: const TextStyle(color: lightMuted),
        prefixIconColor: lightMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.secondary,
            width: 1.5,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: lightCard,
        indicatorColor: Color(0xFFE9DFFF),
      ),

      dividerTheme: const DividerThemeData(
        color: lightBorder,
        thickness: 1,
      ),

      iconTheme: const IconThemeData(color: lightMuted),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: lightText,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: lightText,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: lightText,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: lightText),
        bodyMedium: TextStyle(color: lightMuted),
      ),
    );
  }
}
