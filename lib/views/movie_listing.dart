import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/movie_order.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatefulWidget {
  const MovieListing({super.key, this.movie});

  final Movie? movie;

  @override
  State<MovieListing> createState() => _MovieListingState();
}

class _MovieListingState extends State<MovieListing> {
  static Movie? lastSelectedMovie;
  final MovieRepository movieRepository = MovieRepository();
  late final List<Movie> movies;
  Movie selectedMovie = MovieRepository().getMovies().first;

  @override
  void initState() {
    super.initState();
    movies = movieRepository.getMovies();
    selectedMovie = widget.movie ?? lastSelectedMovie ?? selectedMovie;
    lastSelectedMovie = selectedMovie;
  }

  @override
  Widget build(BuildContext context) {
    final MovieRepository movieRepository = MovieRepository();
    final List<Movie> movies = movieRepository.getMovies();

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: cinemaHeaderStyle),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      drawer: const NavDrawer(),
      body: MovieOrder(movie: selectedMovie),
    );
  }
}
