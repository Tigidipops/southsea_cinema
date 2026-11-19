import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/views/settings_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('SettingsScreen pre-fills saved settings on open', (
    WidgetTester tester,
  ) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(<String, Object>{
      prefAddress: 'Portsmouth Guildhall, PO1 2AJ',
      prefEmail: 'abdul.kadir@portsmouthcc.gov.uk',
      prefPatronNumber: 1456,
      prefNewsletter: true,
    });
    await tester.pumpWidget(const MaterialApp(home: SettingsView()));
    await tester.pumpAndSettle();

    expect(find.text('Portsmouth Guildhall, PO1 2AJ'), findsOneWidget);
    expect(find.text('abdul.kadir@portsmouthcc.gov.uk'), findsOneWidget);
    expect(find.text('1456'), findsOneWidget);
    final Switch switchWidget = tester.widget<Switch>(find.byType(Switch));
    expect(switchWidget.value, isTrue);
  });
  testWidgets('SettingsView displays form fields and switches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsView()));
    await tester.pumpAndSettle();

    expect(find.text('My Settings'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Save Settings'), findsOneWidget);
  });

  testWidgets('Toggling switch and saving settings updates state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsView()));
    await tester.pumpAndSettle();

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

    await tester.ensureVisible(find.text('Save Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Settings'));
    await tester.pumpAndSettle();
    await tester.pump();

    expect(find.text('Settings saved.'), findsOneWidget);

    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    expect(await prefs.getString(prefAddress), '10 Elm Road, Portsmouth');
    expect(
      await prefs.getString(prefEmail),
      'alex@example.com',
    );
    expect(await prefs.getInt(prefPatronNumber), 12345);
    expect(await prefs.getBool(prefNewsletter), isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MaterialApp(home: SettingsView()));
    await tester.pumpAndSettle();
    expect(find.text('10 Elm Road, Portsmouth'), findsOneWidget);
    expect(
      find.text('alex@example.com'),
      findsOneWidget,
    );
    expect(find.text('12345'), findsOneWidget);
    final Switch reopenedSwitch = tester.widget<Switch>(find.byType(Switch));
    expect(reopenedSwitch.value, isTrue);
  });
}
