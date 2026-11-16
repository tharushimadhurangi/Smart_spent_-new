
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'tabs/dashboard_tab.dart';
import 'wideget/custom_bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  late final List<Widget> pages = [
    const DashboardTab(),

    const PlaceholderTab(
      title: 'Income',
      icon: Icons.trending_up_rounded,
    ),

    const PlaceholderTab(
      title: 'Expense',
      icon: Icons.trending_down_rounded,
    ),

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
      ),

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

// Placeholder pages for upcoming sections

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
                color: AppColors.primary.withValues(alpha: 0.12),
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
