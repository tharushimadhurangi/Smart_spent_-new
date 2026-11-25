import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';
import 'pages/auth/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading while checking authentication
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Authentication error
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Authentication error'),
            ),
          );
        }

        // If user is logged in
        if (snapshot.hasData) {
          return const HomePage();
        }

        // If user is not logged in
        return const LoginPage();
      },
    );
  }
}
