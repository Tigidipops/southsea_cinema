import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/booking.dart';

void main() {
  const Booking booking = Booking(
    bookingNumber: 6532,
    summary: 'Deadpool',
    total: 10.0,
    date: '01/01/2026 20:45',
  );

  test('New bookingss omit database ids and conver to map', () {
    expect(booking.id, isNull);
    expect(booking.toMap(), <String, Object?>{
      'booking_number': 6532,
      'summary': 'Deadpool',
      'total': 10.0,
      'date': '01/01/2026 20:45',
    });
  });

  test('A database map converts back into a booking', () {
    final Map<String, Object?> row = <String, Object?>{
      'id': 7,
      'booking_number': 2364,
      'summary': 'Wolverine',
      'total': 25.0,
      'date': '01/06/2026 21:45',
    };
    final Booking restored = Booking.fromMap(row);
    expect(restored.id, 7);
    expect(restored.bookingNumber, 2364);
    expect(restored.summary, 'Wolverine');
    expect(restored.total, 25.0);
    expect(restored.date, '01/06/2026 21:45');
    expect(restored.toMap(), row);
  });

  test('Whole number SQLite totals become doubles', () {
    final Map<String, Object?> row = booking.toMap();
    row['total'] = 25;
    final Booking restored = Booking.fromMap(row);
    expect(restored.total, 25.0);
    expect(restored.total, isA<double>());
  });
}
