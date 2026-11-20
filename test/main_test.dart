import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    rootBundle.clear();
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });
  group('Southsea Cinema App Widget Tests', () {
    testWidgets('Uses dark theme by default', (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      final MaterialApp app =
          tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.dark);
      expect(app.darkTheme?.brightness, Brightness.dark);
      expect(app.theme?.brightness, Brightness.light);
    });

    testWidgets('Loads the saved light theme', (WidgetTester tester) async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.withData(<String, Object>{
        prefThemeMode: ThemeMode.light.name,
      });

      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      final MaterialApp app =
          tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.light);
      final ThemeData theme = Theme.of(tester.element(find.byType(HomeView)));
      expect(theme.brightness, Brightness.light);
      expect(theme.scaffoldBackgroundColor, cinemaLightPalette.background);
    });

    testWidgets('Changing theme mode persists and rebuilds the app',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      final dynamic state = tester.state(find.byType(SouthseaCinemaApp));
      await state.setThemeMode(ThemeMode.light);
      await tester.pumpAndSettle();

      final MaterialApp app =
          tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.light);

      final SharedPreferencesAsync prefs = SharedPreferencesAsync();
      expect(await prefs.getString(prefThemeMode), ThemeMode.light.name);
    });

    testWidgets('Basic app loading test', (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();
      debugDumpApp();
      expect(find.text(appTitle), findsOneWidget);
      expect(find.byType(HomeView), findsOneWidget);
    });

    testWidgets('Display Movie cards and Booking buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      expect(find.text('Resident Evil'),
          findsOneWidget); // CHANGE to how titles appear on screen
      expect(find.text('Deadpool'), findsOneWidget);
      expect(find.text('BOOK NOW'), findsNWidgets(2));
      await tester.scrollUntilVisible(find.text('Interstellar'), 300);
      expect(find.text('Interstellar'), findsOneWidget);
      expect(find.text('BOOK NOW'), findsNWidgets(2));
    });

    testWidgets('Booking button navigates to Movie Order page',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      expect(find.byType(HomeView), findsOneWidget);
      expect(find.byType(MovieListing), findsNothing);

      await tester.tap(find.text('BOOK NOW').first);
      await tester.pumpAndSettle();

      expect(find.text('Resident Evil (15)'), findsOneWidget);
      await tester.ensureVisible(find.text('ADD TO ORDER'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ADD TO ORDER'));
      await tester.pumpAndSettle();
      expect(find.text('Added 1 tickets to Order.'), findsOneWidget);
    });
  });
}
