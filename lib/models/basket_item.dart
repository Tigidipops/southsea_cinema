import 'package:southsea_cinema/models/movie.dart';

class BasketItem {
  final Movie movie;
  final int quantity;

  const BasketItem({required this.movie, this.quantity = 1});

  double get lineTotal => movie.ticketPrice * quantity;
}
