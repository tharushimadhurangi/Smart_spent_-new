import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'theme/app_theme.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/incomes_tab.dart';
import 'tabs/expenses_tab.dart';
import 'wideget/custom_bottom_nav.dart';
import 'tabs/reports_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool isLoggingOut = false;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      DashboardTab(
        onNavigateTab: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      IncomesTab(
        onNavigateBack: () {
          setState(() {
            selectedIndex = 0;
          });
        },
      ),
      ExpensesTab(
        onNavigateBack: () {
          setState(() {
            selectedIndex = 0;
          });
        },
      ),
      const ReportsTab(),
      const PlaceholderTab(
        title: 'Bills',
        icon: Icons.receipt_long_rounded,
      ),
      const PlaceholderTab(
        title: 'Goals',
        icon: Icons.flag_outlined,
      ),
      const PlaceholderTab(
        title: 'Warranty',
        icon: Icons.verified_outlined,
      ),
    ];
  }

  // Firebase Logout Function
  Future<void> logout() async {
    if (isLoggingOut) return;

    setState(() {
      isLoggingOut = true;
    });

    try {
      await FirebaseAuth.instance.signOut();

      // AuthGate automatically displays LoginPage.
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Logout failed. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Logout Button Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isLoggingOut)
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  else
                    IconButton(
                      tooltip: 'Logout',
                      onPressed: logout,
                      icon: Icon(
                        Icons.logout_rounded,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                ],
              ),
            ),

            // Existing Pages
            Expanded(
              child: IndexedStack(
                index: selectedIndex,
                children: pages,
              ),
            ),
          ],
        ),
      ),

      // Existing Bottom Navigation
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: selectedIndex,
        onItemSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

// Placeholder Pages
class PlaceholderTab extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderTab({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 85,
              width: 85,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(
                  alpha: 0.12,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon,
                size: 42,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$title Page',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
