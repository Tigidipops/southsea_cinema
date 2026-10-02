import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';

class Movie extends StatefulWidget {
  const Movie(this.title, this.description, this.rating, this.date, this.time, this.endTime, {super.key});

  final String title;
  final String description;
  final String rating;
  final String date;
  final String time;
  final String endTime;

  @override
  State<Movie> createState() {
    // TODO: implement createElement
    return _MovieState();
  }
  
}

class _MovieState extends State<Movie> {
  int ticketAmount = 1;
  String bookingString = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Text(
              '${widget.title} (${widget.rating})\n',
              style: TextStyle(fontSize: 32),
            ),
            Text(
              'SouthSea Cinema Room\n\n'
              '${widget.date}, ${widget.time} - ends at ${widget.endTime}\n\n\n'
              '${widget.description} \n'
              'Please note that Discounts / Membership Benefits will be applied once you have selected your tickets\n\n'
              'Select Quantites (Up to 5 in total)\n\n',
              style: cinemaMovieDescriptionStyle
            ),
            Text(
              'Tickets\n',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              spacing: 14,
              children: [
                DropdownMenu<int>(
                  initialSelection: 0,
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
                Text(
                  'Adult (£7.50)',
                  style: TextStyle(fontSize: 19)
                )
              ]
            ),
            SizedBox(height: 30),
            ElevatedButton( 
              onPressed: _addToOrder,
              child: const Text('ADD TO ORDER'),
              style: ElevatedButton.styleFrom(
                shape: LinearBorder(),
                iconSize: 10,
                textStyle: cinemaMovieDescriptionStyle,
                foregroundColor: cinemaFontWhite,
                backgroundColor: cinemaBrand
              ),
            ),
            Text(
              bookingString
            )
          ],
        ),
      ),
    );
  }

  void _addToOrder() {
     setState(() => bookingString = "Added $ticketAmount tickets to Order.");
  }

}

