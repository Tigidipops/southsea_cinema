import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/home_view.dart';

void main() {
  group('Southsea Cinema App Widget Tests', () {
    testWidgets('Basic app loading test', (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      debugDumpApp();
      expect(find.text('Welcome to Southsea Cinema & Arts Centre.'),
          findsOneWidget);
      expect(find.byType(HomeView), findsOneWidget);
    });

    testWidgets('Display Movie cards and Booking buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Movie Listing'));
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

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Movie Listing'));
      await tester.pumpAndSettle();

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
