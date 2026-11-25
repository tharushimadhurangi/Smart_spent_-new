import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../providers/transaction_provider.dart';
import '../wideget/wallet_illustration.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  late String _selectedCategoryId;
  late DateTime _selectedDate;
  String _selectedPaymentMethod = 'Bank Transfer';

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Bank Transfer', 'icon': Icons.account_balance_rounded},
    {'name': 'Cash', 'icon': Icons.payments_outlined},
    {'name': 'Credit Card', 'icon': Icons.credit_card_rounded},
    {'name': 'Debit Card', 'icon': Icons.credit_score_rounded},
    {'name': 'Mobile Wallet', 'icon': Icons.phone_android_rounded},
    {'name': 'Savings Account', 'icon': Icons.savings_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = TransactionCategory.incomeCategories.first.id;
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFD946EF),
              onPrimary: Colors.white,
              surface: Color(0xFF1B0F38),
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1B0F38),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1B0F38),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: Color(0xFF6B21A8), width: 1.5),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Category',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...TransactionCategory.incomeCategories.map((cat) {
                final isSelected = cat.id == _selectedCategoryId;
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: cat.color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(cat.icon, color: cat.color, size: 22),
                  ),
                  title: Text(
                    cat.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded,
                          color: Color(0xFFD946EF))
                      : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  tileColor: isSelected
                      ? const Color(0xFF2E1B5B).withValues(alpha: 0.5)
                      : null,
                  onTap: () {
                    setState(() => _selectedCategoryId = cat.id);
                    Navigator.pop(ctx);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentMethodPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1B0F38),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: Color(0xFF6B21A8), width: 1.5),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Payment Account / Method',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ..._paymentMethods.map((pm) {
                final name = pm['name'] as String;
                final icon = pm['icon'] as IconData;
                final isSelected = name == _selectedPaymentMethod;
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFFC084FC), size: 22),
                  ),
                  title: Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded,
                          color: Color(0xFFD946EF))
                      : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  tileColor: isSelected
                      ? const Color(0xFF2E1B5B).withValues(alpha: 0.5)
                      : null,
                  onTap: () {
                    setState(() => _selectedPaymentMethod = name);
                    Navigator.pop(ctx);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _saveIncome() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final amount =
        double.tryParse(_amountController.text.trim().replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final newTx = TransactionItem(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      amount: amount,
      type: TransactionType.income,
      categoryId: _selectedCategoryId,
      date: _selectedDate,
      paymentMethod: _selectedPaymentMethod,
    );

    Provider.of<TransactionProvider>(context, listen: false)
        .addTransaction(newTx);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Income "$title" saved successfully!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  Widget _buildBadge({required Widget child}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _buildCard({
    required Widget badge,
    required String label,
    required Widget content,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E0E3D).withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFF6B21A8).withValues(alpha: 0.5),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF581C87).withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            badge,
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFFB0A8D9),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  content,
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing,
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = TransactionCategory.incomeCategories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => TransactionCategory.incomeCategories.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0C041E),
      body: Stack(
        children: [
          // Ambient organic wavy shapes in background
          Positioned.fill(
            child: CustomPaint(
              painter: _PurpleWavesBackgroundPainter(),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Action Bar (Back Button & Home Button)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF28154F).withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF581C87)
                                  .withValues(alpha: 0.5),
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

                      // Home Button
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .popUntil((route) => route.isFirst),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF28154F).withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF581C87)
                                  .withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.home_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form & Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 3D Wallet Illustration
                          const WalletIllustration(isIncome: true),

                          const SizedBox(height: 6),

                          // Title: Add Income
                          const Text(
                            'Add Income',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Subtitle: Enter your income details
                          const Text(
                            'Enter your income details',
                            style: TextStyle(
                              color: Color(0xFFA5A0CA),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // 1. Title Input Card
                          _buildCard(
                            badge: _buildBadge(
                              child: const Text(
                                'T',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            label: 'Title',
                            content: TextFormField(
                              controller: _titleController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              cursorColor: const Color(0xFFD946EF),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                hintText: 'e.g. Salary',
                                hintStyle: TextStyle(
                                  color: Color(0xFF756E9A),
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Please enter a title'
                                  : null,
                            ),
                          ),

                          // 2. Amount Input Card
                          _buildCard(
                            badge: _buildBadge(
                              child: const Text(
                                '\$',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            label: 'Amount',
                            content: TextFormField(
                              controller: _amountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              cursorColor: const Color(0xFFD946EF),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                hintText: 'Enter amount',
                                hintStyle: TextStyle(
                                  color: Color(0xFF756E9A),
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Please enter amount';
                                final val = double.tryParse(
                                    v.trim().replaceAll(',', ''));
                                if (val == null || val <= 0)
                                  return 'Enter a valid amount';
                                return null;
                              },
                            ),
                          ),

                          // 3. Category Picker Card
                          _buildCard(
                            onTap: _showCategoryPicker,
                            badge: _buildBadge(
                              child: const Icon(
                                Icons.grid_view_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            label: 'Category',
                            content: Text(
                              selectedCategory.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),

                          // 4. Payment Account / Method Card
                          _buildCard(
                            onTap: _showPaymentMethodPicker,
                            badge: _buildBadge(
                              child: const Icon(
                                Icons.credit_card_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            label: 'Payment Account / Method',
                            content: Text(
                              _selectedPaymentMethod,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),

                          // 5. Date Picker Card
                          _buildCard(
                            onTap: _pickDate,
                            badge: _buildBadge(
                              child: const Icon(
                                Icons.calendar_today_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            label: 'Date',
                            content: Text(
                              _formatDate(_selectedDate),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Save Income Button
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFA855F7),
                                  Color(0xFFD946EF),
                                  Color(0xFFEC4899),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD946EF)
                                      .withValues(alpha: 0.45),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _saveIncome,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save_rounded,
                                      color: Colors.white, size: 22),
                                  SizedBox(width: 8),
                                  Text(
                                    'Save Income',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PurpleWavesBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Top-left organic wave
    final paint1 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF3B0764), Color(0xFF240642), Colors.transparent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
          Rect.fromLTWH(0, 0, size.width * 0.85, size.height * 0.45));

    final path1 = Path();
    path1.moveTo(0, 0);
    path1.lineTo(size.width * 0.75, 0);
    path1.cubicTo(
      size.width * 0.6,
      size.height * 0.12,
      size.width * 0.1,
      size.height * 0.16,
      0,
      size.height * 0.28,
    );
    path1.close();
    canvas.drawPath(path1, paint1);

    // Top-right organic wave
    final paint2 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF2E0854), Colors.transparent],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(Rect.fromLTWH(
          size.width * 0.4, 0, size.width * 0.6, size.height * 0.25));

    final path2 = Path();
    path2.moveTo(size.width * 0.45, 0);
    path2.lineTo(size.width, 0);
    path2.lineTo(size.width, size.height * 0.18);
    path2.cubicTo(
      size.width * 0.8,
      size.height * 0.12,
      size.width * 0.65,
      size.height * 0.05,
      size.width * 0.45,
      0,
    );
    canvas.drawPath(path2, paint2);

    // Mid-left wave curve
    final paint3 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF2E0854), Colors.transparent],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(
          0, size.height * 0.25, size.width * 0.5, size.height * 0.35));

    final path3 = Path();
    path3.moveTo(0, size.height * 0.25);
    path3.cubicTo(
      size.width * 0.38,
      size.height * 0.32,
      size.width * 0.25,
      size.height * 0.48,
      0,
      size.height * 0.55,
    );
    path3.close();
    canvas.drawPath(path3, paint3);

    // Mid-right wave curve
    final paint4 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF28064B), Colors.transparent],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      ).createShader(Rect.fromLTWH(size.width * 0.5, size.height * 0.45,
          size.width * 0.5, size.height * 0.35));

    final path4 = Path();
    path4.moveTo(size.width, size.height * 0.45);
    path4.cubicTo(
      size.width * 0.65,
      size.height * 0.52,
      size.width * 0.75,
      size.height * 0.68,
      size.width,
      size.height * 0.75,
    );
    path4.close();
    canvas.drawPath(path4, paint4);

    // Bottom organic wave
    final paint5 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF2C0A52), Color(0xFF16032B)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
          Rect.fromLTWH(0, size.height * 0.8, size.width, size.height * 0.2));

    final path5 = Path();
    path5.moveTo(0, size.height * 0.88);
    path5.cubicTo(
      size.width * 0.3,
      size.height * 0.82,
      size.width * 0.65,
      size.height * 0.92,
      size.width,
      size.height * 0.85,
    );
    path5.lineTo(size.width, size.height);
    path5.lineTo(0, size.height);
    path5.close();
    canvas.drawPath(path5, paint5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
