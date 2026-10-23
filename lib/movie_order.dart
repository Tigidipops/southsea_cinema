import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieOrder extends StatefulWidget {
  final Movie movie;

  const MovieOrder({super.key, required this.movie});

  @override
  State<MovieOrder> createState() {
    return _MovieState();
  }
}

class _MovieState extends State<MovieOrder> {
  int ticketAmount = 1;
  String bookingString = "";

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      layout: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        color: cinemaSurface,
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${widget.movie.title} (${widget.movie.ageRating})',
                  style: TextStyle(fontSize: 32),
                ),
                Image.asset(
                  widget.movie.imagePath,
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                Text(
                    'SouthSea Cinema Room\n'
                    '${widget.movie.screeningTime}\n\n'
                    '${widget.movie.synopsis} \n'
                    'Please note that Discounts / Membership Benefits will be applied once you have selected your tickets\n',
                    style: cinemaMovieDescriptionStyle),
                Row(spacing: 14, children: [
                  Text('Tickets (${widget.movie.formattedPrice} each)',
                      style: TextStyle(fontSize: 19)),
                  DropdownMenu<int>(
                    requestFocusOnTap: false,
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: cinemaSurface,
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                    ),
                    textStyle: TextStyle(color: cinemaFontWhite),
                    initialSelection: 1,
                    onSelected: (int? value) {
                      if (value != null) {
                        setState(() {
                          ticketAmount = value;
                        });
                      }
                    },
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: 1, label: '1 Ticket'),
                      DropdownMenuEntry(value: 2, label: '2 Tickets'),
                      DropdownMenuEntry(value: 3, label: '3 Tickets'),
                      DropdownMenuEntry(value: 4, label: '4 Tickets'),
                      DropdownMenuEntry(value: 5, label: '5 Tickets')
                    ],
                  ),
                ]),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _addToOrder,
                  style: ElevatedButton.styleFrom(
                      shape: LinearBorder(),
                      iconSize: 10,
                      textStyle: cinemaMovieDescriptionStyle,
                      foregroundColor: cinemaFontWhite,
                      backgroundColor: cinemaBrand),
                  child: const Text('ADD TO ORDER'),
                ),
                Text(bookingString)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addToOrder() {
    setState(() => bookingString = "Added $ticketAmount tickets to Order.");
  }
}
