import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_spent_new/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('SmartSpent app loads home dashboard and tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartSpentApp());
    await tester.pumpAndSettle();

    // Verify Dashboard Title and Available Balance header
    expect(find.text('SmartSpent'), findsWidgets);
    expect(find.text('Available Balance'), findsOneWidget);
    expect(find.text('Total Income'), findsOneWidget);
    expect(find.text('Total Expenses'), findsOneWidget);
    expect(find.text('Recent Transactions'), findsOneWidget);
  });
}
