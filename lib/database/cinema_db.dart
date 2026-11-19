import 'package:path/path.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:sqflite/sqflite.dart';

class CinemaDatabase {
  CinemaDatabase._internal();
  static final CinemaDatabase instance = CinemaDatabase._internal();
  static Database? _database;

  void setDatabase(Database? db) {
    _database = db;
  }
}
