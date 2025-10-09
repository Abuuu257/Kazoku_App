import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:kazoku_pet_store/main.dart';

void main() {
  testWidgets('App boots to Login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const KazokuApp());
    await tester.pumpAndSettle();

    // Ensure the Login screen title is visible
    expect(find.text('Kazoku Login'), findsOneWidget);

    // Theme toggle icon should exist (any of the three)
    final hasAnyToggleIcon = find.byIcon(Icons.light_mode).evaluate().isNotEmpty ||
        find.byIcon(Icons.dark_mode).evaluate().isNotEmpty ||
        find.byIcon(Icons.brightness_auto).evaluate().isNotEmpty;
    expect(hasAnyToggleIcon, isTrue);
  });
}
