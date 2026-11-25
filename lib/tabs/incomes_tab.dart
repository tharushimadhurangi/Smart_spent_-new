import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../wideget/transaction_detail_sheet.dart';
import '../screens/add_income_screen.dart';
import '../screens/edit_transaction_screen.dart';

class IncomesTab extends StatefulWidget {
  final VoidCallback? onNavigateBack;

  const IncomesTab({
    super.key,
    this.onNavigateBack,
  });

  @override
  State<IncomesTab> createState() => _IncomesTabState();
}

class _IncomesTabState extends State<IncomesTab> {
  bool _isIncomeVisible = true;

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final month = months[dt.month - 1];
    final day = dt.day.toString().padLeft(2, '0');
    return '$month $day, ${dt.year}';
  }

  String _formatLKR(double amount) {
    final parts = amount.toStringAsFixed(0).split('.');
    final intPart = parts[0];
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formatted = intPart.replaceAllMapped(reg, (Match m) => '${m[1]},');
    return 'LKR $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09031A),
      body: Stack(
        children: [
          // Background organic purple waves
          Positioned.fill(
            child: CustomPaint(
              painter: _IncomeBackgroundWavesPainter(),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Consumer<TransactionProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final incomes = provider.incomeTransactions;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TOP HEADER BAR
                      _buildTopHeader(),

                      const SizedBox(height: 18),

                      // TOTAL INCOME SUMMARY CARD
                      _buildTotalIncomeCard(provider),

                      const SizedBox(height: 22),

                      // INCOME ENTRIES SECTION
                      _buildEntriesSectionHeader(incomes.length),

                      const SizedBox(height: 12),

                      // ENTRIES LIST OR EMPTY STATE
                      if (incomes.isEmpty)
                        _buildEmptyState()
                      else
                        ...incomes.map((item) => _buildIncomeEntryCard(item)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 1. TOP HEADER BAR
  Widget _buildTopHeader() {
    return Row(
      children: [
        // Circular Back Button
        GestureDetector(
          onTap: () {
            if (widget.onNavigateBack != null) {
              widget.onNavigateBack!();
            } else {
              Navigator.maybePop(context);
            }
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF28154F).withValues(alpha: 0.8),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF581C87).withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Title and Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Income\nManagement',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Track and optimize your\nrevenue streams',
                style: TextStyle(
                  color: Color(0xFFA5A0CA),
                  fontSize: 11.5,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),

        // + Add Income Pill Button
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddIncomeScreen(),
              ),
            );
          },
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD946EF).withValues(alpha: 0.4),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add, color: Colors.white, size: 20),
                SizedBox(width: 4),
                Text(
                  'Add Income',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 2. TOTAL INCOME SUMMARY CARD WITH 3D WALLET & STATS
  Widget _buildTotalIncomeCard(TransactionProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF240D4E),
            Color(0xFF190838),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF7C3AED).withValues(alpha: 0.55),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6D28D9).withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: Label, Amount, Growth
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Income + Eye Toggle
                Row(
                  children: [
                    const Text(
                      'Total Income',
                      style: TextStyle(
                        color: Color(0xFFB0A8D9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isIncomeVisible = !_isIncomeVisible;
                        });
                      },
                      child: Icon(
                        _isIncomeVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFFB0A8D9),
                        size: 18,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Amount
                Text(
                  _isIncomeVisible
                      ? _formatLKR(provider.totalIncome)
                      : '••••••••',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),

                const SizedBox(height: 8),

                // Growth pill / subtitle
                Row(
                  children: const [
                    Icon(
                      Icons.arrow_upward_rounded,
                      color: Color(0xFF10B981),
                      size: 14,
                    ),
                    SizedBox(width: 3),
                    Text(
                      '+12.5%',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'from last month',
                      style: TextStyle(
                        color: Color(0xFFA5A0CA),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right side: 3D Mini Wallet & Coins Graphic
          _buildCardMiniWallet(),
        ],
      ),
    );
  }

  Widget _buildCardMiniWallet() {
    return SizedBox(
      width: 104,
      height: 84,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Soft purple glow aura
          Positioned(
            top: 15,
            child: Container(
              width: 70,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                    blurRadius: 25,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),

          // Bar Chart Columns (behind wallet on the right)
          Positioned(
            top: 16,
            right: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 6,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 3),
                Container(
                  width: 6,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),

          // Upward Arrow (pointing top-right behind wallet)
          Positioned(
            top: 6,
            right: 8,
            child: Transform.rotate(
              angle: -0.2,
              child: const Icon(
                Icons.north_east_rounded,
                color: Color(0xFFC084FC),
                size: 22,
              ),
            ),
          ),

          // Main 3D Purple/Blue Wallet Body
          Positioned(
            top: 12,
            left: 8,
            child: Container(
              width: 68,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7C3AED),
                    Color(0xFF6D28D9),
                    Color(0xFF5B21B6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFA78BFA).withValues(alpha: 0.7),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4C1D95).withValues(alpha: 0.6),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Flap and Snap
                  Positioned(
                    right: 0,
                    top: 15,
                    child: Container(
                      width: 20,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6D28D9),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 3),
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFDE047),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Left Coin (₹)
          Positioned(
            bottom: 6,
            right: 28,
            child: _buildMiniCoin(20, '₹'),
          ),

          // Right Coin (₹)
          Positioned(
            bottom: 12,
            right: 12,
            child: _buildMiniCoin(24, '₹'),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCoin(double size, String symbol) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.3),
          radius: 0.9,
          colors: [
            Color(0xFFFEF08A),
            Color(0xFFFBBF24),
            Color(0xFFF59E0B),
            Color(0xFFD97706),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFFEF9C3),
          width: 0.8,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        symbol,
        style: TextStyle(
          color: const Color(0xFF92400E),
          fontSize: size * 0.46,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  // 5. INCOME ENTRIES SECTION HEADER
  Widget _buildEntriesSectionHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.format_list_bulleted_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Income Entries ($count)',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Text(
          'Tap to inspect or edit',
          style: TextStyle(
            color: Color(0xFFA5A0CA),
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }

  // 6. INDIVIDUAL INCOME ENTRY CARD
  Widget _buildIncomeEntryCard(TransactionItem item) {
    final cat = item.category;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF190B35).withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4C1D95).withValues(alpha: 0.45),
          width: 1.1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => TransactionDetailSheet.show(context, item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Left Category Icon Badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cat.color,
                        cat.color.withValues(alpha: 0.75),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: cat.color.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(cat.icon, color: Colors.white, size: 22),
                ),

                const SizedBox(width: 14),

                // Title and Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: Color(0xFFA5A0CA),
                            size: 13,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${_formatDate(item.date)} • Income',
                            style: const TextStyle(
                              color: Color(0xFFA5A0CA),
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Amount
                Text(
                  '+ ${_formatLKR(item.amount)}',
                  style: const TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 4),

                // More Options Menu
                IconButton(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Color(0xFFA5A0CA),
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EditTransactionScreen(transaction: item),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 56,
              color: const Color(0xFFA5A0CA).withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            const Text(
              'No Income Records Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Tap "+ Add Income" above to register a new income source.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFA5A0CA),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncomeBackgroundWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Top-left ambient purple wave
    final paint1 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF3B0764), Color(0xFF240642), Colors.transparent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
          Rect.fromLTWH(0, 0, size.width * 0.85, size.height * 0.35));

    final path1 = Path();
    path1.moveTo(0, 0);
    path1.lineTo(size.width * 0.75, 0);
    path1.cubicTo(
      size.width * 0.6,
      size.height * 0.1,
      size.width * 0.1,
      size.height * 0.14,
      0,
      size.height * 0.22,
    );
    path1.close();
    canvas.drawPath(path1, paint1);

    // Top-right ambient wave
    final paint2 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF2E0854), Colors.transparent],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(Rect.fromLTWH(
          size.width * 0.4, 0, size.width * 0.6, size.height * 0.2));

    final path2 = Path();
    path2.moveTo(size.width * 0.45, 0);
    path2.lineTo(size.width, 0);
    path2.lineTo(size.width, size.height * 0.15);
    path2.cubicTo(
      size.width * 0.8,
      size.height * 0.1,
      size.width * 0.65,
      size.height * 0.04,
      size.width * 0.45,
      0,
    );
    canvas.drawPath(path2, paint2);

    // Bottom organic wave
    final paint3 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF2C0A52), Color(0xFF16032B)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
          Rect.fromLTWH(0, size.height * 0.82, size.width, size.height * 0.18));

    final path3 = Path();
    path3.moveTo(0, size.height * 0.88);
    path3.cubicTo(
      size.width * 0.3,
      size.height * 0.83,
      size.width * 0.65,
      size.height * 0.92,
      size.width,
      size.height * 0.86,
    );
    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    path3.close();
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
