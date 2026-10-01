import 'package:flutter/material.dart';

class Movie extends StatelessWidget {
  const Movie(this.title, this.description, this.rating, this.date, this.time, this.endTime, {super.key});

  final String title;
  final String description;
  final String rating;
  final String date;
  final String time;
  final String endTime;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Text(
            '$title ($rating)\n',
            style: TextStyle(fontSize: 26),
          ),
          Text(
            'SouthSea Cinema Room\n\n'
            '$date, $time - ends at $endTime\n\n\n'
            '$description \n'
            'Please note that Discounts / Membership Benefits will be applied once you have selected your tickets\n\n'
            'Select Quantites (Up to 5 in total)',
            style: TextStyle(fontSize: 18),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Choose Quantity'),
          ),
        ],
      ),
    );
  }
  
}

