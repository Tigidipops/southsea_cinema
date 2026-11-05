import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';

const Movie testMovie1 = Movie(
  id: 'resident',
  title: 'Resident Evil',
  synopsis: 'Raccoon city, zombies and a delivery mission',
  ageRating: '15',
  runtime: '1h 50m',
  screeningTime: "Friday 2 Oct 2026, 16:00 - 17:50",
  ticketPrice: 8.0,
  imagePath: 'assets/images/resident_evil.jpeg',
);

const Movie testMovie2 = Movie(
  id: 'deadpool',
  title: 'Deadpool',
  synopsis:
      'The merc with a mouth becomes immortal in a bizarre experiment where he was left for dead.',
  ageRating: '15',
  runtime: '1h 48m',
  screeningTime: "Saturday 3 Oct 2026, 18:00 - 19:48",
  ticketPrice: 10.0,
  imagePath: 'assets/images/deadpool.jpeg',
);

void main() {
  setUp(() {
    BasketRepository.instance.clear();
  });

  group('BasketRepository tests', () {
    test('starts with empty basket and zero totals', () {
      final BasketRepository cart = BasketRepository.instance;
      expect(cart.getItems().length, 0);
      expect(cart.getTotalItems(), 0);
      expect(cart.totalItemCount, 0);
      expect(cart.getSubtotal(), 0.0);
      expect(cart.getServiceCharge(), 0.0);
      expect(cart.getTotalDue(), 0.0);
    });

    test('adds items and calculates subtotal and service charge correctly', () {
      final BasketRepository cart = BasketRepository.instance;
      const BasketItem item1 = BasketItem(
        movie: testMovie1,
        quantity: 2,
      );
      const BasketItem item2 = BasketItem(
        movie: testMovie2,
        quantity: 1,
      );

      cart.addItem(item1);
      cart.addItem(item2);

      expect(cart.getItems().length, 2);
      expect(cart.getTotalItems(), 3);
      expect(cart.totalItemCount, 3);
      expect(cart.getSubtotal(), 26.0);
      expect(cart.getServiceCharge(), 4.00);
      expect(cart.getTotalDue(), 30.0);
    });

    test('removes items correctly', () {
      final BasketRepository basket = BasketRepository.instance;
      const BasketItem item = BasketItem(
        movie: testMovie1,
        quantity: 1,
      );
      basket.addItem(item);
      expect(basket.getItems().length, 1);

      basket.removeItem(0);
      expect(basket.getItems().length, 0);
      expect(basket.getTotalDue(), 0.0);

      basket.addItem(item);
      expect(basket.getItems().length, 1);
      basket.clear();

      expect(basket.getItems().length, 0);
      expect(basket.getTotalDue(), 0.0);
    });
  });
}
