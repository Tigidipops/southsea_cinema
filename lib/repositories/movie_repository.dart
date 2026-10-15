import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
    return [
      const Movie(
        id: 'resident',
        title: 'Resident Evil',
        synopsis: 'Raccoon city, zombies and a delivery mission',
        ageRating: '15',
        runtime: '1h 50m',
        screeningTime: "Friday 2 Oct 2026, 16:00 - 17:50",
        ticketPrice: 10.0,
        imagePath: 'assets/images/resident_evil.jpeg',
      ),
      const Movie(
        id: 'deadpool',
        title: 'Deadpool',
        synopsis:
            'The merc with a mouth becomes immortal in a bizarre experiment where he was left for dead.',
        ageRating: '15',
        runtime: '1h 48m',
        screeningTime: "Saturday 3 Oct 2026, 18:00 - 19:48",
        ticketPrice: 10.0,
        imagePath: 'assets/images/deadpool.jpeg',
      ),
      const Movie(
        id: 'interstellar',
        title: 'Interstellar',
        synopsis:
            'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
        ageRating: '12A',
        runtime: '2h 49m',
        screeningTime: "Saturday 3 Oct 2026, 18:00 - 20:49",
        ticketPrice: 10.0,
        imagePath: 'assets/images/interstellar.jpeg',
      ),
    ];
  }

  Movie? getMovieById(String id) {
    for (final movie in getMovies()) {
      if (movie.id == id) {
        return movie;
      }
    }
    return null;
  }
}
