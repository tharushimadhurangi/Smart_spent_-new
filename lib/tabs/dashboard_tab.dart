
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 32),

          const Text(
            'Hey Samudhi 👋',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 29,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            "Keep going! You're on track.",
            style: TextStyle(
              color: Color(0xFF79BCEB),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 30),

          _buildBalanceCard(context),

          const SizedBox(height: 22),

          // INCOME AND EXPENSE SUMMARY
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Total Income',
                  amount: 'LKR 85,000.00',
                  icon: Icons.arrow_upward_rounded,
                  iconColor: const Color(0xFF00D5A0),
                  gradientColors: const [
                    Color(0xFF123F51),
                    Color(0xFF075B59),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Total Expenses',
                  amount: 'LKR 32,500.00',
                  icon: Icons.arrow_downward_rounded,
                  iconColor: const Color(0xFFFF4F9A),
                  gradientColors: const [
                    Color(0xFF49234F),
                    Color(0xFF70254F),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // RECENT TRANSACTIONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          _buildTransaction(
            icon: Icons.shopping_bag_outlined,
            title: 'Shopping',
            date: 'Today',
            amount: '- LKR 5,000.00',
            color: AppColors.error,
          ),

          _buildTransaction(
            icon: Icons.restaurant_outlined,
            title: 'Food & Dining',
            date: 'Yesterday',
            amount: '- LKR 2,500.00',
            color: AppColors.error,
          ),

          _buildTransaction(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Monthly Salary',
            date: '10 Nov 2026',
            amount: '+ LKR 85,000.00',
            color: AppColors.success,
          ),

          const SizedBox(height: 22),

          _buildWeeklyCard(),
        ],
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),

        const SizedBox(width: 10),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Smart ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'Spend',
                      style: TextStyle(
                        color: Color(0xFFCB75FF),
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Manage • Save • Grow',
                style: TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),

        // NOTIFICATION
        IconButton(
          constraints: const BoxConstraints(
            minWidth: 38,
            minHeight: 42,
          ),
          padding: EdgeInsets.zero,
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.text,
            size: 24,
          ),
        ),

        // BRIGHTNESS
        IconButton(
          constraints: const BoxConstraints(
            minWidth: 38,
            minHeight: 42,
          ),
          padding: EdgeInsets.zero,
          onPressed: () {},
          icon: const Icon(
            Icons.brightness_6_rounded,
            color: AppColors.text,
            size: 23,
          ),
        ),

        // PROFILE
        const CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primary,
          child: Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ],
    );
  }

  // AVAILABLE BALANCE CARD
  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF302A9B),
            Color(0xFF5724BD),
            Color(0xFF8B27D9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF9D69FF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
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
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'LKR 125,450.00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.trending_up_rounded,
                color: Color(0xFFD9A3FF),
                size: 30,
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Row(
            children: [
              Icon(
                Icons.north_east_rounded,
                color: Color(0xFF00E5A0),
                size: 21,
              ),
              SizedBox(width: 7),
              Text(
                '+12.5%',
                style: TextStyle(
                  color: Color(0xFF00E5A0),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5),
              Text(
                'from last month',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ADD INCOME AND ADD EXPENSE BUTTONS
          Row(
            children: [
              // GREEN ADD INCOME
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add Income selected'),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 19,
                  ),
                  label: const Text(
                    'Add Income',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // RED ADD EXPENSE
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add Expense selected'),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.white,
                    size: 19,
                  ),
                  label: const Text(
                    'Add Expense',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // SUMMARY CARDS
  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color iconColor,
    required List<Color> gradientColors,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 155),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TRANSACTION ITEM
  Widget _buildTransaction({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: AppColors.secondary,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 11,
                  ),
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
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WEEKLY SPENDING CARD
  Widget _buildWeeklyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.insights_rounded,
                color: AppColors.secondary,
                size: 25,
              ),
              SizedBox(width: 10),
              Text(
                'Weekly Spend Pace',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'You are doing great! Keep tracking your expenses.',
            style: TextStyle(
              color: AppColors.mutedText,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
