import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUp(() async {
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

  Booking buildRecord(int bookingNumber, String summary, double total) {
    return Booking(
      bookingNumber: bookingNumber,
      summary: summary,
      total: total,
      date: '01/01/2026 20:45',
    );
  }

  test('insertBooking stores a booking and returns its ID', () async {
    final int id = await CinemaDatabase.instance.insertBooking(
      buildRecord(6532, 'Deadpool', 10.0),
    );
    expect(id, greaterThan(0));

    final List<Booking> bookings =
        await CinemaDatabase.instance.getAllBookings();
    expect(bookings.length, 1);
    expect(bookings[0].id, id);
    expect(bookings[0].summary, 'Deadpool');
    expect(bookings[0].total, 10.0);
  });

  test('getNextBookingNumber increments the current maximum', () async {
    expect(await CinemaDatabase.instance.getNextBookingNumber(), 1001);

    await CinemaDatabase.instance.insertBooking(
      buildRecord(1006, 'Order', 5.0),
    );
    expect(await CinemaDatabase.instance.getNextBookingNumber(), 1007);
  });

  test('getAllBookings returns newest booking number first', () async {
    await CinemaDatabase.instance.insertBooking(
      buildRecord(1001, 'First', 5.0),
    );
    await CinemaDatabase.instance.insertBooking(
      buildRecord(1003, 'Third', 15.0),
    );
    await CinemaDatabase.instance.insertBooking(
      buildRecord(1002, 'Second', 10.0),
    );

    final List<Booking> bookings =
        await CinemaDatabase.instance.getAllBookings();
    expect(bookings.length, 3);
    expect(bookings[0].bookingNumber, 1003);
    expect(bookings[1].bookingNumber, 1002);
    expect(bookings[2].bookingNumber, 1001);
  });
}
