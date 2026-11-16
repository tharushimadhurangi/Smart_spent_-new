import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final background = Theme.of(context).scaffoldBackgroundColor;
    final cardColor =
        Theme.of(context).cardTheme.color ??
        Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final mutedColor = isDark ? AppColors.mutedText : const Color(0xFF65708A);
    final borderColor = isDark ? AppColors.border : const Color(0xFFE1E5F0);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, textColor, mutedColor, isDark),

              const SizedBox(height: 28),

              Text(
                'Hey Samudhi 👋',
                style: TextStyle(
                  color: textColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Keep going! You're on track.",
                style: TextStyle(color: mutedColor, fontSize: 14),
              ),

              const SizedBox(height: 24),

              _buildBalanceCard(context),

              const SizedBox(height: 25),

              Text(
                'Financial Overview',
                style: TextStyle(
                  color: textColor,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Total Income',
                      amount: 'LKR 85,000',
                      icon: Icons.trending_up_rounded,
                      color: AppColors.success,
                      cardColor: cardColor,
                      textColor: textColor,
                      mutedColor: mutedColor,
                      borderColor: borderColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Total Expenses',
                      amount: 'LKR 32,500',
                      icon: Icons.trending_down_rounded,
                      color: AppColors.error,
                      cardColor: cardColor,
                      textColor: textColor,
                      mutedColor: mutedColor,
                      borderColor: borderColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              _buildSectionTitle('Recent Transactions', textColor, 'See All'),

              const SizedBox(height: 14),

              _buildTransaction(
                title: 'Shopping',
                subtitle: 'Today • 10:30 AM',
                amount: '- LKR 5,000',
                icon: Icons.shopping_bag_outlined,
                color: AppColors.error,
                cardColor: cardColor,
                textColor: textColor,
                mutedColor: mutedColor,
                borderColor: borderColor,
              ),

              _buildTransaction(
                title: 'Food & Dining',
                subtitle: 'Yesterday • 02:15 PM',
                amount: '- LKR 2,500',
                icon: Icons.restaurant_outlined,
                color: AppColors.warning,
                cardColor: cardColor,
                textColor: textColor,
                mutedColor: mutedColor,
                borderColor: borderColor,
              ),

              _buildTransaction(
                title: 'Monthly Salary',
                subtitle: '10 Nov 2026 • 09:00 AM',
                amount: '+ LKR 85,000',
                icon: Icons.account_balance_wallet_outlined,
                color: AppColors.success,
                cardColor: cardColor,
                textColor: textColor,
                mutedColor: mutedColor,
                borderColor: borderColor,
              ),

              const SizedBox(height: 28),

              _buildWeeklySpendCard(
                cardColor,
                textColor,
                mutedColor,
                borderColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Color textColor,
    Color mutedColor,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SmartSpend',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Manage your money',
                style: TextStyle(color: mutedColor, fontSize: 11),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No new notifications')),
            );
          },
          icon: Icon(Icons.notifications_none_rounded, color: textColor),
        ),

        IconButton(
          tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          onPressed: AppTheme.toggleTheme,
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: textColor,
          ),
        ),

        CircleAvatar(
          radius: 19,
          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
          child: const Icon(Icons.person_rounded, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Available Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.white.withValues(alpha: 0.85),
                size: 23,
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'LKR 125,450.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 9),

          Row(
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: Color(0xFFB7FFDA),
                size: 17,
              ),
              const SizedBox(width: 5),
              Text(
                '+12.5% from last month',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _buildBalanceButton(
                  context,
                  'Add Income',
                  Icons.add_circle_outline_rounded,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBalanceButton(
                  context,
                  'Add Expense',
                  Icons.remove_circle_outline_rounded,
                  AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title screen coming soon')));
      },
      icon: Icon(icon, size: 18),
      label: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
        minimumSize: const Size(0, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
    required Color cardColor,
    required Color textColor,
    required Color mutedColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 37,
            width: 37,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 21),
          ),

          const SizedBox(height: 13),

          Text(title, style: TextStyle(color: mutedColor, fontSize: 12)),

          const SizedBox(height: 7),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            action,
            style: const TextStyle(color: AppColors.primary, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildTransaction({
    required String title,
    required String subtitle,
    required String amount,
    required IconData icon,
    required Color color,
    required Color cardColor,
    required Color textColor,
    required Color mutedColor,
    required Color borderColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            height: 43,
            width: 43,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 22),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(color: mutedColor, fontSize: 11),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          Flexible(
            child: Text(
              amount,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySpendCard(
    Color cardColor,
    Color textColor,
    Color mutedColor,
    Color borderColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Weekly Spend Pace',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.show_chart_rounded, color: AppColors.primary),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'You have used 65% of your weekly budget.',
            style: TextStyle(color: mutedColor, fontSize: 12),
          ),

          const SizedBox(height: 17),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              value: 0.65,
              minHeight: 9,
              backgroundColor: Color(0xFFE2D9F5),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LKR 13,000 spent',
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'LKR 20,000 budget',
                style: TextStyle(color: mutedColor, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
