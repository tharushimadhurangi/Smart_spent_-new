
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'tabs/dashboard_tab.dart';

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
      title: 'Expenses',
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
      title: 'Warranties',
      icon: Icons.verified_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: AppColors.card,
        indicatorColor:
            AppColors.primary.withValues(alpha: 0.25),
        elevation: 0,
        labelBehavior:
            NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up_rounded),
            label: 'Income',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_down_rounded),
            label: 'Expense',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Bills',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag_outlined),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.verified_outlined),
            label: 'Warranty',
          ),
        ],
      ),
    );
  }
}

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 55,
              color: AppColors.primary,
            ),
            const SizedBox(height: 15),
            Text(
              '$title Page',
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming Soon',
              style: TextStyle(
                color: AppColors.mutedText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
