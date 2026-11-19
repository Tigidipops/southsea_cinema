import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/basket_view.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
  setUp(() async {
    BasketRepository.instance.clear();
    sqfliteFfiInit();
    final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: CinemaDatabase.instance.createTables,
      ),
    );
    CinemaDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await CinemaDatabase.instance.close();
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

  Future<void> pumpBasket(WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const MaterialApp(home: BasketView()));
      await tester.pumpAndSettle();
    });
    await tester.pump();
  }

  testWidgets('Lists saved bookings with the highest number first', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      await CinemaDatabase.instance.insertBooking(
        const Booking(
          bookingNumber: 1001,
          summary: '2 Resident Evil tickets.',
          total: 20.00,
          date: '12/04/2026 18:10',
        ),
      );
      await CinemaDatabase.instance.insertBooking(
        const Booking(
          bookingNumber: 1002,
          summary: '3 Deadpool tickets.',
          total: 30.00,
          date: '18/04/2026 12:45',
        ),
      );
    });

    await pumpBasket(tester);

    expect(find.text('No bookings yet'), findsNothing);
    expect(find.text('Booking #1001'), findsOneWidget);
    expect(find.text('Booking #1002'), findsOneWidget);
    expect(find.text('3 Deadpool tickets.'), findsOneWidget);

    final double newerY = tester.getTopLeft(find.text('Booking #1002')).dy;
    final double olderY = tester.getTopLeft(find.text('Booking #1001')).dy;
    expect(newerY, lessThan(olderY));
  });
}
