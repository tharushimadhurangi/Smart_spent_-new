import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/incomes_tab.dart';
import 'tabs/expenses_tab.dart';
import 'screens/transaction_form_sheet.dart';
import 'models/category_model.dart';
import 'wideget/custom_bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

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

      const IncomesTab(),

      const ExpensesTab(),

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

  void _onAddTransactionPressed() {
    TransactionType defaultType = TransactionType.expense;
    if (selectedIndex == 1) {
      defaultType = TransactionType.income;
    }

    TransactionFormSheet.show(
      context,
      defaultType: defaultType,
    );
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTransactionPressed,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        tooltip: 'Add Transaction',
        shape: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.primaryGradient,
          ),
          child: const Icon(Icons.add_rounded, size: 28),
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
