import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/views/settings_view.dart';

void main() {
  testWidgets('SettingsView displays form fields and switches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsView()));

    expect(find.text('My Settings'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Save Settings'), findsOneWidget);
  });

  testWidgets('Toggling switch and saving settings updates state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsView()));

    final Finder addressField =
        find.widgetWithText(TextField, 'Delivery address');
    final Finder emailField = find.widgetWithText(TextField, 'Email address');
    final Finder patronNumberField =
        find.widgetWithText(TextField, 'Patron Number');

    await tester.enterText(addressField, '10 Elm Road, Portsmouth');
    await tester.enterText(emailField, 'alex@example.com');
    await tester.enterText(patronNumberField, '12345');

    final Finder switchFinder = find.byType(Switch);
    expect(tester.widget<Switch>(switchFinder).value, isFalse);
    await tester.tap(switchFinder);
    await tester.pump();
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    await tester.tap(find.text('Save Settings'));
    await tester.pump();

    expect(find.text('Settings saved.'), findsOneWidget);
  });
}
