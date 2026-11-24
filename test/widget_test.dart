import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_spent_new/home_page.dart';
import 'package:smart_spent_new/providers/transaction_provider.dart';
import 'package:smart_spent_new/screens/add_income_screen.dart';
import 'package:smart_spent_new/screens/add_expense_screen.dart';
import 'package:smart_spent_new/tabs/incomes_tab.dart';
import 'package:smart_spent_new/tabs/expenses_tab.dart';
import 'package:smart_spent_new/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('SmartSpent app loads home dashboard and tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => TransactionProvider(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const HomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify key Dashboard widgets
    expect(find.text('Available Balance'), findsOneWidget);
    expect(find.text('Total Income'), findsOneWidget);
    expect(find.text('Total Expenses'), findsOneWidget);
    expect(find.text('Recent Transactions'), findsOneWidget);
  });

  testWidgets('AddIncomeScreen renders all fields matching the new UI', (WidgetTester tester) async {
    final provider = TransactionProvider();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: provider),
        ],
        child: const MaterialApp(
          home: AddIncomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('Add Income'), findsOneWidget);
    expect(find.text('Enter your income details'), findsOneWidget);

    // Verify Card Labels
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Amount'), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Payment Account / Method'), findsOneWidget);
    expect(find.text('Date'), findsOneWidget);

    // Verify Badges and Default values
    expect(find.text('T'), findsOneWidget);
    expect(find.text('\$'), findsOneWidget);
    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('Bank Transfer'), findsOneWidget);
    expect(find.text('Save Income'), findsOneWidget);

    // Enter details and submit
    await tester.enterText(find.byType(TextFormField).at(0), 'Freelance Bonus');
    await tester.enterText(find.byType(TextFormField).at(1), '45000');
    await tester.ensureVisible(find.text('Save Income'));
    await tester.tap(find.text('Save Income'));
    await tester.pumpAndSettle();

    expect(provider.incomeTransactions.any((t) => t.title == 'Freelance Bonus'), isTrue);
  });

  testWidgets('IncomesTab renders Income Management UI matching user design', (WidgetTester tester) async {
    final provider = TransactionProvider();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: provider),
        ],
        child: const MaterialApp(
          home: IncomesTab(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Header
    expect(find.text('Add Income'), findsOneWidget);

    // Verify Total Income Card
    expect(find.text('Total Income'), findsOneWidget);
    expect(find.text('from last month'), findsOneWidget);

    // Verify Tap Add Income opens AddIncomeScreen
    await tester.tap(find.text('Add Income'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your income details'), findsOneWidget);
  });

  testWidgets('AddExpenseScreen renders all fields matching the new UI', (WidgetTester tester) async {
    final provider = TransactionProvider();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: provider),
        ],
        child: const MaterialApp(
          home: AddExpenseScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('Add Expense'), findsOneWidget);
    expect(find.text('Enter your expense details'), findsOneWidget);

    // Verify Card Labels
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Amount'), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Payment Account / Method'), findsOneWidget);
    expect(find.text('Date'), findsOneWidget);

    // Verify Default values
    expect(find.text('Food & Dining'), findsOneWidget);
    expect(find.text('Credit Card'), findsOneWidget);
    expect(find.text('Save Expense'), findsOneWidget);

    // Enter details and submit
    await tester.enterText(find.byType(TextFormField).at(0), 'Lunch Buffet');
    await tester.enterText(find.byType(TextFormField).at(1), '3500');
    await tester.ensureVisible(find.text('Save Expense'));
    await tester.tap(find.text('Save Expense'));
    await tester.pumpAndSettle();

    expect(provider.expenseTransactions.any((t) => t.title == 'Lunch Buffet'), isTrue);
  });

  testWidgets('ExpensesTab renders Expense Management UI matching user design', (WidgetTester tester) async {
    final provider = TransactionProvider();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: provider),
        ],
        child: const MaterialApp(
          home: ExpensesTab(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Header
    expect(find.text('Add Expense'), findsOneWidget);

    // Verify Total Expense Card
    expect(find.text('Total Expenses'), findsOneWidget);
    expect(find.text('from last month'), findsOneWidget);

    // Verify Tap Add Expense opens AddExpenseScreen
    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your expense details'), findsOneWidget);
  });
}
