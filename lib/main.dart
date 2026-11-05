
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/auth/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartSpentApp());
}

class SmartSpentApp extends StatelessWidget {
  const SmartSpentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Spent',

      // Global Dark Navy & Purple Theme
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // Initial Auth Screen
      home: const LoginPage(),
    );
  }
}
