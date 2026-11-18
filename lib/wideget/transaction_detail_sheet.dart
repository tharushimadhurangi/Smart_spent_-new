import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../providers/transaction_provider.dart';
import '../screens/transaction_form_sheet.dart';
import '../theme/app_theme.dart';

class TransactionDetailSheet extends StatelessWidget {
  final TransactionItem transaction;

  const TransactionDetailSheet({
    super.key,
    required this.transaction,
  });

  static Future<void> show(BuildContext context, TransactionItem transaction) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TransactionDetailSheet(transaction: transaction),
    );
  }

  void _confirmDelete(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF101D35) : Colors.white;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final mutedColor = isDark ? AppColors.mutedText : const Color(0xFF65708A);

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Transaction?',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to remove "${transaction.title}" of ${transaction.formattedAmount}?',
          style: TextStyle(color: mutedColor, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text('Cancel', style: TextStyle(color: mutedColor)),
          ),
          ElevatedButton(
            onPressed: () {
              final provider =
                  Provider.of<TransactionProvider>(context, listen: false);
              final itemToDelete = transaction;
              final originalIndex = provider.transactions.indexWhere(
                (t) => t.id == itemToDelete.id,
              );

              // Close dialog and detail sheet
              Navigator.pop(dialogCtx);
              Navigator.pop(context);

              // Delete from provider
              provider.deleteTransaction(itemToDelete.id);

              // Show Undo SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted "${itemToDelete.title}"'),
                  backgroundColor: AppColors.card,
                  action: SnackBarAction(
                    label: 'UNDO',
                    textColor: AppColors.secondary,
                    onPressed: () {
                      provider.restoreTransaction(itemToDelete, originalIndex);
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              minimumSize: const Size(90, 42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF101D35) : Colors.white;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final mutedColor = isDark ? AppColors.mutedText : const Color(0xFF65708A);
    final borderColor = isDark ? AppColors.border : const Color(0xFFE1E5F0);

    final category = transaction.category;
    final isIncome = transaction.type == TransactionType.income;
    final statusColor = isIncome ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            height: 4,
            width: 45,
            decoration: BoxDecoration(
              color: mutedColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 18),

          // Header with Type Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      isIncome
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      size: 14,
                      color: statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isIncome ? 'Income' : 'Expense',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded, color: mutedColor),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Amount
          Text(
            transaction.formattedAmount,
            style: TextStyle(
              color: statusColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            transaction.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 24),

          // Details List
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D1B33) : const Color(0xFFF0F2F8),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  icon: category.icon,
                  iconColor: category.color,
                  label: 'Category',
                  value: category.name,
                  textColor: textColor,
                  mutedColor: mutedColor,
                ),
                Divider(color: borderColor, height: 22),
                _buildDetailRow(
                  icon: Icons.calendar_today_rounded,
                  iconColor: AppColors.primary,
                  label: 'Date',
                  value: transaction.formattedDate,
                  textColor: textColor,
                  mutedColor: mutedColor,
                ),
                Divider(color: borderColor, height: 22),
                _buildDetailRow(
                  icon: Icons.access_time_rounded,
                  iconColor: AppColors.secondary,
                  label: 'Time',
                  value: transaction.formattedTime,
                  textColor: textColor,
                  mutedColor: mutedColor,
                ),
                Divider(color: borderColor, height: 22),
                _buildDetailRow(
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: const Color(0xFF06B6D4),
                  label: 'Payment Method',
                  value: transaction.paymentMethod,
                  textColor: textColor,
                  mutedColor: mutedColor,
                ),
                if (transaction.notes != null &&
                    transaction.notes!.trim().isNotEmpty) ...[
                  Divider(color: borderColor, height: 22),
                  _buildDetailRow(
                    icon: Icons.notes_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    label: 'Notes',
                    value: transaction.notes!,
                    textColor: textColor,
                    mutedColor: mutedColor,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Actions: Edit & Delete
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Close detail sheet
                    TransactionFormSheet.show(
                      context,
                      existingTransaction: transaction,
                    );
                  },
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textColor,
                    side: BorderSide(color: borderColor),
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color textColor,
    required Color mutedColor,
  }) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: iconColor, size: 17),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(color: mutedColor, fontSize: 13),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
        ),
      ],
    );
  }
}
