import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  group('Movie model tests', () {
    test('creates a Movie instance with given properties', () {
      const movie = Movie(
        id: '1',
        title: 'Fight Club',
        synopsis:
            'The first rule of Fight Club is: You do not talk about Fight Club.',
        ageRating: '15',
        runtime: '2h 19m',
        screeningTime: '19:00',
        ticketPrice: 9.50,
        imagePath: 'assets/images/fight_club.jpeg',
      );

      expect(movie.id, '1');
      expect(movie.title, 'Fight Club');
      expect(movie.synopsis,
          'The first rule of Fight Club is: You do not talk about Fight Club.');
      expect(movie.ageRating, '15');
      expect(movie.runtime, '2h 19m');
      expect(movie.screeningTime, '19:00');
      expect(movie.ticketPrice, 9.50);
      expect(movie.imagePath, 'assets/images/fight_club.jpeg');
    });

    test(
        'formattedPrice returns the price formatted as a string with a pound sign and two decimal places',
        () {
      const movie = Movie(
        id: '1',
        title: 'Fight Club',
        synopsis:
            'The first rule of Fight Club is: You do not talk about Fight Club.',
        ageRating: '15',
        runtime: '2h 19m',
        screeningTime: '19:00',
        ticketPrice: 9.50,
        imagePath: 'assets/images/fight_club.jpeg',
      );
      expect(movie.formattedPrice, '£9.50');

      const movieTwo = Movie(
        id: '1',
        title: 'Fight Club',
        synopsis:
            'The first rule of Fight Club is: You do not talk about Fight Club.',
        ageRating: '15',
        runtime: '2h 19m',
        screeningTime: '19:00',
        ticketPrice: 10,
        imagePath: 'assets/images/fight_club.jpeg',
      );
      expect(movieTwo.formattedPrice, '£10.00');
    });
  });
}
