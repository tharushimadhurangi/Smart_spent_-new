
import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'pages/onboarding/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartSpentApp());
}

class SmartSpentApp extends StatelessWidget {
  const SmartSpentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App Configuration
      debugShowCheckedModeBanner: false,
      title: 'SmartSpend',

      // Global Theme
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // Initial Screen
      home: const SplashScreen(),
    );
  }
}
