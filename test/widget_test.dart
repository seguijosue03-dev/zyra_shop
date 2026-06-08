// Smoke test for ZyraShopApp.

import 'package:flutter_test/flutter_test.dart';
import 'package:zyra_shop/main.dart';

void main() {
  testWidgets('Smoke test - App starts and pumps without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ZyraShopApp());
    expect(find.byType(ZyraShopApp), findsOneWidget);
    // Advance virtual time step-by-step to trigger all delayed futures in the splash sequence
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();
  });
}

