import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              textBaseline: TextBaseline.alphabetic,
              children: [

                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: cinemaBrandDark,
                  ),
                ),

                const SizedBox(width: 12),

                Text(
                  '(${movie.ageRating})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: cinemaFontMuted,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Image.asset(
                  movie.imagePath,
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                
                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    movie.synopsis,
                    style: const TextStyle(color: cinemaFontWhite),
                  ),
                ),
                const SizedBox(height: 16),
              ]
            ),

            const SizedBox(height: 8),

            Text(
              'BOOK TICKETS',
              style: const TextStyle(
              color: cinemaFontWhite,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${movie.screeningTime}',
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Text('Movie Order Page for ${movie.title}');
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: LinearBorder(),
                      iconSize: 10,
                      textStyle: cinemaMovieDescriptionStyle,
                      foregroundColor: cinemaFontWhite,
                      backgroundColor: cinemaBrand),
                  child: const Text('BOOK NOW'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
