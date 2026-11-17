import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../services/transaction_storage.dart';

enum TimePeriodFilter {
  allTime,
  today,
  thisWeek,
  thisMonth,
}

class TransactionProvider extends ChangeNotifier {
  List<TransactionItem> _transactions = [];
  bool _isLoading = true;
  double _weeklyBudget = 20000.00;

  TransactionProvider() {
    _loadFromStorage();
  }

  bool get isLoading => _isLoading;
  double get weeklyBudget => _weeklyBudget;

  List<TransactionItem> get transactions {
    // Return sorted newest first
    final list = List<TransactionItem>.from(_transactions);
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Future<void> _loadFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await TransactionStorage.loadTransactions();
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setWeeklyBudget(double budget) {
    _weeklyBudget = budget;
    notifyListeners();
  }

  // Calculations
  double get totalIncome {
    return _transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get availableBalance {
    return totalIncome - totalExpenses;
  }

  List<TransactionItem> get incomeTransactions {
    final list = _transactions.where((t) => t.isIncome).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  List<TransactionItem> get expenseTransactions {
    final list = _transactions.where((t) => t.isExpense).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  List<TransactionItem> recentTransactions([int limit = 5]) {
    final sorted = transactions;
    if (sorted.length <= limit) return sorted;
    return sorted.sublist(0, limit);
  }

  // Filter by Time Period
  List<TransactionItem> filterByPeriod(
    List<TransactionItem> items,
    TimePeriodFilter period,
  ) {
    if (period == TimePeriodFilter.allTime) return items;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (period) {
      case TimePeriodFilter.today:
        return items.where((t) {
          final txDate = DateTime(t.date.year, t.date.month, t.date.day);
          return txDate == today;
        }).toList();

      case TimePeriodFilter.thisWeek:
        // Week starts Monday
        final daysFromMonday = now.weekday - 1;
        final monday = today.subtract(Duration(days: daysFromMonday));
        return items.where((t) {
          return t.date.isAfter(monday.subtract(const Duration(seconds: 1)));
        }).toList();

      case TimePeriodFilter.thisMonth:
        final firstOfMonth = DateTime(now.year, now.month, 1);
        return items.where((t) {
          return t.date.isAfter(firstOfMonth.subtract(const Duration(seconds: 1)));
        }).toList();

      case TimePeriodFilter.allTime:
        return items;
    }
  }

  // Weekly expenses for budget pacing card
  double get currentWeekExpenses {
    final weekItems = filterByPeriod(expenseTransactions, TimePeriodFilter.thisWeek);
    return weekItems.fold(0.0, (sum, t) => sum + t.amount);
  }

  double get weeklySpendPercentage {
    if (_weeklyBudget <= 0) return 0.0;
    final ratio = currentWeekExpenses / _weeklyBudget;
    return ratio.clamp(0.0, 1.0);
  }

  // Category breakdown for expenses
  Map<String, double> get expenseBreakdownByCategory {
    final Map<String, double> map = {};
    for (final tx in expenseTransactions) {
      map[tx.categoryId] = (map[tx.categoryId] ?? 0.0) + tx.amount;
    }
    return map;
  }

  // Category breakdown for income
  Map<String, double> get incomeBreakdownByCategory {
    final Map<String, double> map = {};
    for (final tx in incomeTransactions) {
      map[tx.categoryId] = (map[tx.categoryId] ?? 0.0) + tx.amount;
    }
    return map;
  }

  // CRUD Operations
  Future<void> addTransaction(TransactionItem item) async {
    _transactions.insert(0, item);
    notifyListeners();
    await TransactionStorage.saveTransactions(_transactions);
  }

  Future<void> updateTransaction(TransactionItem item) async {
    final index = _transactions.indexWhere((t) => t.id == item.id);
    if (index != -1) {
      _transactions[index] = item;
      notifyListeners();
      await TransactionStorage.saveTransactions(_transactions);
    }
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
    await TransactionStorage.saveTransactions(_transactions);
  }

  Future<void> restoreTransaction(TransactionItem item, int originalIndex) async {
    if (originalIndex >= 0 && originalIndex <= _transactions.length) {
      _transactions.insert(originalIndex, item);
    } else {
      _transactions.add(item);
    }
    notifyListeners();
    await TransactionStorage.saveTransactions(_transactions);
  }

  TransactionItem? getById(String id) {
    try {
      return _transactions.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
