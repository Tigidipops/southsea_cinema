import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

void main() {
  group('MovieRepository unit tests', () {
    test('getMovies returns three movies', () {
      final movieRepository = MovieRepository();
      final List<Movie> movies = movieRepository.getMovies();

      expect(movies.length, 3);
    });

    test(
        'getMovies contains valid Resident Evil, Deadpool, and Interstellar movies',
        () {
      final MovieRepository repository = MovieRepository();
      final List<Movie> movies = repository.getMovies();

      final Movie residentEvil = movies[0];
      expect(residentEvil.id, 'resident');
      expect(residentEvil.title, 'Resident Evil');
      expect(residentEvil.synopsis,
          'Raccoon city, zombies and a delivery mission');
      expect(residentEvil.ageRating, '15');
      expect(residentEvil.runtime, '1h 50m');
      expect(residentEvil.screeningTime, "Friday 2 Oct 2026, 16:00 - 17:50");
      expect(residentEvil.ticketPrice, 10.0);
      expect(residentEvil.imagePath, isNotEmpty);

      final Movie deadpool = movies[1];
      expect(deadpool.id, 'deadpool');
      expect(deadpool.title, 'Deadpool');
      expect(deadpool.synopsis,
          'The merc with a mouth becomes immortal in a bizarre experiment where he was left for dead.');
      expect(deadpool.ageRating, '15');
      expect(deadpool.runtime, '1h 48m');
      expect(deadpool.screeningTime, "Saturday 3 Oct 2026, 18:00 - 19:48");
      expect(deadpool.ticketPrice, 10.0);
      expect(deadpool.imagePath, isNotEmpty);

      final Movie interstellar = movies[2];
      expect(interstellar.id, 'interstellar');
      expect(interstellar.title, 'Interstellar');
      expect(interstellar.synopsis,
          'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.');
      expect(interstellar.ageRating, '12A');
      expect(interstellar.runtime, '2h 49m');
      expect(interstellar.screeningTime, "Saturday 3 Oct 2026, 18:00 - 20:49");
      expect(interstellar.ticketPrice, 10.0);
      expect(interstellar.imagePath, isNotEmpty);
    });

    test('getMovieById returns matching movie when id exists', () {
      final MovieRepository repository = MovieRepository();
      final Movie? movie = repository.getMovieById('resident');

      expect(movie, isNotNull);
      expect(movie?.title, 'Resident Evil');
      expect(movie?.synopsis, 'Raccoon city, zombies and a delivery mission');
      expect(movie?.ageRating, '15');
      expect(movie?.runtime, '1h 50m');
      expect(movie?.screeningTime, "Friday 2 Oct 2026, 16:00 - 17:50");
      expect(movie?.ticketPrice, 10.0);
      expect(movie?.imagePath, isNotEmpty);
    });

    test('getMovieById returns null when id does not exist', () {
      final MovieRepository repository = MovieRepository();
      final Movie? movie = repository.getMovieById('non-existent');

      expect(movie, isNull);
    });
  });
}
