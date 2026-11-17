import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../providers/transaction_provider.dart';
import '../screens/transaction_history_screen.dart';
import '../screens/edit_transaction_screen.dart';

class DashboardTab extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const DashboardTab({
    super.key,
    this.onNavigateTab,
  });

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF070B19);

    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Consumer<TransactionProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final recentList = provider.recentTransactions(5);

            return Stack(
              children: [
                // Ambient Purple Glow in Background (Top Right & Bottom Left)
                Positioned(
                  top: -80,
                  right: -80,
                  child: IgnorePointer(
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF702BFF).withValues(alpha: 0.35),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  left: -60,
                  child: IgnorePointer(
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFB52CFA).withValues(alpha: 0.25),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Main Scrollable Content
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header (SmartSpent Logo, Notification with Badge '2', Avatar)
                      _buildHeader(context),

                      const SizedBox(height: 18),

                      // Greeting: "Hey Samudhi 👋" / "Keep going! You're on track."
                      _buildGreeting(),

                      const SizedBox(height: 18),

                      // 1. AVAILABLE BALANCE CARD - AT THE TOP & PROMINENTLY BIGGER!
                      _buildBigAvailableBalanceCard(provider),

                      const SizedBox(height: 16),

                      // 2. TOTAL INCOME & TOTAL EXPENSES CARDS - DIRECTLY BELOW AVAILABLE BALANCE
                      Row(
                        children: [
                          Expanded(
                            child: _buildIncomeCard(provider),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildExpenseCard(provider),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // 3. RECENT TRANSACTIONS HEADER with Lightning Bolt '⚡' and 'See All →'
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.bolt_rounded,
                                color: Color(0xFFB52CFA),
                                size: 22,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Recent Transactions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TransactionHistoryScreen(),
                                ),
                              );
                            },
                            child: const Row(
                              children: [
                                Text(
                                  'See All',
                                  style: TextStyle(
                                    color: Color(0xFFD946EF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Color(0xFFD946EF),
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // 4. RECENT TRANSACTIONS CONTAINER (Glassmorphic panel with dividers)
                      _buildRecentTransactionsPanel(context, recentList),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Header Widget
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Wallet Icon
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF702BFF), Color(0xFFB52CFA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 23,
          ),
        ),

        const SizedBox(width: 10),

        // SmartSpent Title & Subtitle
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Smart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Spent',
                    style: TextStyle(
                      color: Color(0xFFD946EF),
                      fontSize: 18.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Manage • Save • Grow',
              style: TextStyle(
                color: Color(0xFF8E9BB5),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const Spacer(),

        // Notification Bell with badge '2'
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF131A38).withValues(alpha: 0.6),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF283460), width: 1),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 10),

        // User Avatar with circular gradient
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFB52CFA)],
            ),
            border: Border.all(color: const Color(0xFFD946EF), width: 1.5),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  // Greeting Widget
  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Hey Samudhi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(width: 6),
            Text(
              '👋',
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
        const SizedBox(height: 3),
        // Subtle purple curved underline decoration
        Container(
          width: 75,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFFB52CFA),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Keep going! You're on track.",
          style: TextStyle(
            color: Color(0xFF8E9BB5),
            fontSize: 13.5,
          ),
        ),
      ],
    );
  }

  // 1. PROMINENT BIG AVAILABLE BALANCE CARD (AT TOP)
  Widget _buildBigAvailableBalanceCard(TransactionProvider provider) {
    final balance = provider.availableBalance;
    final isPositive = balance >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF131138),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.6),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF702BFF).withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFFB52CFA).withValues(alpha: 0.15),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Glowing 3D-styled Wallet Icon
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF8B5CF6),
                      Color(0xFF6B21A8),
                      Color(0xFF4C1D95),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFC084FC).withValues(alpha: 0.6),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),

              const SizedBox(width: 15),

              // Balance Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Available Balance" + Eye Icon
                    Row(
                      children: [
                        const Text(
                          'Available Balance',
                          style: TextStyle(
                            color: Color(0xFFB9C9E8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 7),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isBalanceVisible = !_isBalanceVisible;
                            });
                          },
                          child: Icon(
                            _isBalanceVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 16,
                            color: const Color(0xFFB9C9E8),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // BIG BOLD BALANCE AMOUNT
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _isBalanceVisible
                            ? TransactionItem.formatCurrency(balance, showDecimals: true)
                            : '••••••••',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Percentage Growth Pill
                    Row(
                      children: [
                        Icon(
                          isPositive
                              ? Icons.north_east_rounded
                              : Icons.south_east_rounded,
                          size: 14,
                          color: isPositive
                              ? const Color(0xFF34D399)
                              : const Color(0xFFF87171),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isPositive
                              ? '+12.5% from last month'
                              : '-4.2% from last month',
                          style: TextStyle(
                            color: isPositive
                                ? const Color(0xFF34D399)
                                : const Color(0xFFF87171),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Upward Trend Arrow + Bar Chart columns (on right)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.north_east_rounded,
                    color: Color(0xFFC084FC),
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBarColumn(14, const Color(0xFF6B21A8)),
                      const SizedBox(width: 3),
                      _buildBarColumn(20, const Color(0xFF8B5CF6)),
                      const SizedBox(width: 3),
                      _buildBarColumn(28, const Color(0xFFB52CFA)),
                      const SizedBox(width: 3),
                      _buildBarColumn(34, const Color(0xFFE879F9)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarColumn(double height, Color color) {
    return Container(
      width: 5,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  // 2. TOTAL INCOME CARD (Glassmorphism with glowing cyan/green wave)
  Widget _buildIncomeCard(TransactionProvider provider) {
    return Container(
      height: 106,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1B2F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF06B6D4).withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Glowing neon wave painter at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 38,
              child: CustomPaint(
                painter: NeonWavePainter(
                  color: const Color(0xFF10B981),
                  glowColor: const Color(0xFF06B6D4),
                ),
              ),
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
              child: Row(
                children: [
                  // Circular Upward Arrow Icon
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Title and Amount
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total Income',
                          style: TextStyle(
                            color: Color(0xFF8E9BB5),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 3),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            TransactionItem.formatCurrency(provider.totalIncome, showDecimals: true),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. TOTAL EXPENSES CARD (Glassmorphism with glowing pink wave)
  Widget _buildExpenseCard(TransactionProvider provider) {
    return Container(
      height: 106,
      decoration: BoxDecoration(
        color: const Color(0xFF1F122B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF43F5E).withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF43F5E).withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Glowing neon wave painter at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 38,
              child: CustomPaint(
                painter: NeonWavePainter(
                  color: const Color(0xFFF43F5E),
                  glowColor: const Color(0xFFEC4899),
                ),
              ),
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
              child: Row(
                children: [
                  // Circular Downward Arrow Icon
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF43F5E).withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Title and Amount
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total Expenses',
                          style: TextStyle(
                            color: Color(0xFF8E9BB5),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 3),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            TransactionItem.formatCurrency(provider.totalExpenses, showDecimals: true),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. RECENT TRANSACTIONS GLASS PANEL (with internal dividers)
  Widget _buildRecentTransactionsPanel(
    BuildContext context,
    List<TransactionItem> recentList,
  ) {
    if (recentList.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF131A38),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF283460)),
        ),
        child: const Center(
          child: Text(
            'No transactions recorded yet',
            style: TextStyle(color: Color(0xFF8E9BB5), fontSize: 14),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131A38).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF6B21A8).withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(recentList.length, (index) {
          final tx = recentList[index];
          final cat = tx.category;
          final isIncome = tx.type == TransactionType.income;
          final amountColor = isIncome
              ? const Color(0xFF34D399) // Mint green
              : const Color(0xFFFB7185); // Coral pink

          final isLast = index == recentList.length - 1;

          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.vertical(
                    top: index == 0 ? const Radius.circular(22) : Radius.zero,
                    bottom: isLast ? const Radius.circular(22) : Radius.zero,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditTransactionScreen(transaction: tx),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        // Circular Category Icon with vibrant border & background
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: cat.color.withValues(alpha: 0.22),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: cat.color.withValues(alpha: 0.5),
                              width: 1.2,
                            ),
                          ),
                          child: Icon(
                            cat.icon,
                            color: cat.color,
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 14),

                        // Title & Date • Type
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                tx.fullDateSubtitle,
                                style: const TextStyle(
                                  color: Color(0xFF8E9BB5),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Amount
                        Text(
                          tx.formattedAmount,
                          style: TextStyle(
                            color: amountColor,
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Divider between items (except after the last item)
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 0.8,
                  indent: 16,
                  endIndent: 16,
                  color: Color(0xFF222B52),
                ),
            ],
          );
        }),
      ),
    );
  }
}

// Custom Painter for Neon Glowing Bottom Wave in Income and Expense cards
class NeonWavePainter extends CustomPainter {
  final Color color;
  final Color glowColor;

  NeonWavePainter({
    required this.color,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.7);

    // Smooth wave path across width
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.55,
      size.height * 0.9,
      size.width * 0.78,
      size.height * 0.45,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.2,
      size.width,
      size.height * 0.35,
    );

    // Glow stroke
    final glowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawPath(path, glowPaint);

    // Solid stroke
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
