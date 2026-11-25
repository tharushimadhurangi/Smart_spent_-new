import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';

class TransactionStorage {
  static const String _keyTransactions = 'smartspent_transactions_v3';
  static const String _keyInitialized = 'smartspent_data_initialized_v3';

  static Future<List<TransactionItem>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyTransactions);

    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonStr) as List<dynamic>;
        return decoded
            .map((item) =>
                TransactionItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        // Fallback to initial seeds
      }
    }

    // First run or empty: Seed with default data matching the design
    final initialSeeds = _getInitialSeeds();
    await saveTransactions(initialSeeds);
    await prefs.setBool(_keyInitialized, true);
    return initialSeeds;
  }

  static Future<void> saveTransactions(List<TransactionItem> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((item) => item.toJson()).toList();
    await prefs.setString(_keyTransactions, jsonEncode(jsonList));
  }

  static List<TransactionItem> _getInitialSeeds() {
    return [
      TransactionItem(
        id: 'tx_seed_1',
        title: 'Salary',
        amount: 50000.00,
        type: TransactionType.income,
        categoryId: 'salary',
        date: DateTime(2026, 11, 5, 9, 30),
        paymentMethod: 'Bank Account',
        notes: 'Monthly company salary deposit',
      ),
      TransactionItem(
        id: 'tx_seed_2',
        title: 'Food & Dining',
        amount: 1200.00,
        type: TransactionType.expense,
        categoryId: 'food',
        date: DateTime(2026, 11, 4, 13, 15),
        paymentMethod: 'Cash',
        notes: 'Lunch at Cafe',
      ),
      TransactionItem(
        id: 'tx_seed_3',
        title: 'Shopping',
        amount: 2500.00,
        type: TransactionType.expense,
        categoryId: 'shopping',
        date: DateTime(2026, 11, 3, 17, 45),
        paymentMethod: 'Credit Card',
        notes: 'Clothing and weekend essentials',
      ),
      TransactionItem(
        id: 'tx_seed_4',
        title: 'Freelance Project',
        amount: 35000.00,
        type: TransactionType.income,
        categoryId: 'freelance',
        date: DateTime(2026, 11, 1, 11, 0),
        paymentMethod: 'Bank Account',
        notes: 'UI/UX Mobile App milestone payout',
      ),
      TransactionItem(
        id: 'tx_seed_5',
        title: 'Investment Dividends',
        amount: 72950.00,
        type: TransactionType.income,
        categoryId: 'investments',
        date: DateTime(2026, 10, 31, 10, 0),
        paymentMethod: 'Bank Account',
        notes: 'Quarterly CSE portfolio return',
      ),
      TransactionItem(
        id: 'tx_seed_6',
        title: 'Bills & Utilities',
        amount: 28800.00,
        type: TransactionType.expense,
        categoryId: 'bills',
        date: DateTime(2026, 10, 30, 14, 0),
        paymentMethod: 'Bank Account',
        notes: 'Home fiber, electricity, and water bill',
      ),
    ];
  }
}
