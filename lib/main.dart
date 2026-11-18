import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'home_page.dart';
import 'providers/transaction_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartSpentApp());
}

class SmartSpentApp extends StatelessWidget {
  const SmartSpentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: AppTheme.themeMode,
        builder: (context, currentMode, _) {
          return MaterialApp(
            // App Configuration
            debugShowCheckedModeBanner: false,
            title: 'SmartSpend',

            // Global Theme with dynamic mode toggle
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: currentMode,

            // Home Screen: Dashboard & Transaction Management
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
