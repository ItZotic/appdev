import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smartspend/main.dart';

void main() {
  testWidgets('SmartSpend renders dashboard by default', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartSpendApp());

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
