import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/basket_view.dart';

const Movie testMovie1 = Movie(
  id: 'resident',
  title: 'Resident Evil',
  synopsis: 'Raccoon city, zombies and a delivery mission',
  ageRating: '15',
  runtime: '1h 50m',
  screeningTime: "Friday 2 Oct 2026, 16:00 - 17:50",
  ticketPrice: 10.0,
  imagePath: 'assets/images/resident_evil.jpeg',
);
void main() {
  setUp(() {
    BasketRepository.instance.clear();
  });

  testWidgets('BasketScreen displays empty message when basket has no items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BasketView()));

    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('Checkout'), findsNothing);
  });

  testWidgets(
    'BasketScreen renders items and removes item when delete pressed',
    (WidgetTester tester) async {
      const BasketItem item = BasketItem(
        movie: testMovie1,
        quantity: 2,
      );
      BasketRepository.instance.addItem(item);

      await tester.pumpWidget(const MaterialApp(home: BasketView()));

      expect(find.text('MY ORDER'), findsOneWidget);
      expect(find.text('2 Tickets'), findsOneWidget);
      expect(find.text('£20.00'), findsWidgets);
      expect(find.text('BUY TICKETS'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(find.text('Your basket is empty'), findsOneWidget);
    },
  );
}
