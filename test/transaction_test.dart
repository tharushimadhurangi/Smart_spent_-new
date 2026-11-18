import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_spent_new/models/transaction_model.dart';
import 'package:smart_spent_new/models/category_model.dart';
import 'package:smart_spent_new/providers/transaction_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Transaction Calculation & Management Tests', () {
    test('Calculates Total Income, Total Expense, and Available Balance correctly', () async {
      final provider = TransactionProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      final calculatedIncome = provider.totalIncome;
      final calculatedExpense = provider.totalExpenses;
      final calculatedBalance = provider.availableBalance;

      expect(calculatedBalance, equals(calculatedIncome - calculatedExpense));
      expect(calculatedIncome, greaterThan(0));
      expect(calculatedExpense, greaterThan(0));
    });

    test('Add Income increases Total Income and Available Balance', () async {
      final provider = TransactionProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      final initialIncome = provider.totalIncome;
      final initialBalance = provider.availableBalance;

      final newIncome = TransactionItem(
        id: 'test_inc_1',
        title: 'Project Bonus',
        amount: 15000.0,
        type: TransactionType.income,
        categoryId: 'salary',
        date: DateTime.now(),
      );

      await provider.addTransaction(newIncome);

      expect(provider.totalIncome, equals(initialIncome + 15000.0));
      expect(provider.availableBalance, equals(initialBalance + 15000.0));
      expect(provider.incomeTransactions.any((t) => t.id == 'test_inc_1'), isTrue);
    });

    test('Add Expense increases Total Expense and decreases Available Balance', () async {
      final provider = TransactionProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      final initialExpense = provider.totalExpenses;
      final initialBalance = provider.availableBalance;

      final newExpense = TransactionItem(
        id: 'test_exp_1',
        title: 'Restaurant Dinner',
        amount: 3500.0,
        type: TransactionType.expense,
        categoryId: 'food',
        date: DateTime.now(),
      );

      await provider.addTransaction(newExpense);

      expect(provider.totalExpenses, equals(initialExpense + 3500.0));
      expect(provider.availableBalance, equals(initialBalance - 3500.0));
      expect(provider.expenseTransactions.any((t) => t.id == 'test_exp_1'), isTrue);
    });

    test('Edit Transaction updates amount and title correctly', () async {
      final provider = TransactionProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      final original = provider.transactions.first;
      final updated = original.copyWith(
        title: 'Updated Title Test',
        amount: 9999.0,
      );

      await provider.updateTransaction(updated);

      final fetched = provider.getById(original.id);
      expect(fetched?.title, equals('Updated Title Test'));
      expect(fetched?.amount, equals(9999.0));
    });

    test('Delete Transaction removes item and updates calculations', () async {
      final provider = TransactionProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      final itemToDelete = provider.transactions.first;
      final initialCount = provider.transactions.length;

      await provider.deleteTransaction(itemToDelete.id);

      expect(provider.transactions.length, equals(initialCount - 1));
      expect(provider.getById(itemToDelete.id), isNull);
    });

    test('Categories resolve properly for Income and Expense', () {
      final incomeCat = TransactionCategory.getById('salary');
      expect(incomeCat.type, equals(TransactionType.income));
      expect(incomeCat.name, equals('Salary'));

      final expenseCat = TransactionCategory.getById('shopping');
      expect(expenseCat.type, equals(TransactionType.expense));
      expect(expenseCat.name, equals('Shopping'));
    });

    test('Firestore document serialization links transaction to user and stores all required fields', () {
      final now = DateTime(2026, 11, 18, 10, 30);
      final transaction = TransactionItem(
        id: 'doc_tx_123',
        userId: 'user_prabu_456',
        title: 'Salary November',
        description: 'Monthly Corporate Salary for November',
        amount: 85000.0,
        type: TransactionType.income,
        categoryId: 'salary',
        date: now,
        paymentMethod: 'Bank Account',
      );

      final firestoreData = transaction.toFirestore();

      expect(firestoreData['id'], equals('doc_tx_123'));
      expect(firestoreData['userId'], equals('user_prabu_456'));
      expect(firestoreData['amount'], equals(85000.0));
      expect(firestoreData['category'], equals('Salary'));
      expect(firestoreData['description'], equals('Monthly Corporate Salary for November'));
      expect(firestoreData['date'], isA<Timestamp>());
      expect((firestoreData['date'] as Timestamp).toDate(), equals(now));
      expect(firestoreData['type'], equals('income'));

      // Test deserialization from Firestore
      final reconstituted = TransactionItem.fromFirestore(firestoreData, 'doc_tx_123');
      expect(reconstituted.id, equals('doc_tx_123'));
      expect(reconstituted.userId, equals('user_prabu_456'));
      expect(reconstituted.amount, equals(85000.0));
      expect(reconstituted.description, equals('Monthly Corporate Salary for November'));
      expect(reconstituted.isIncome, isTrue);
    });
  });
}
