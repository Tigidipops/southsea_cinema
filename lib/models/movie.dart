class Movie {
  final String id;
  final String title;
  final String synopsis;
  final String ageRating;
  final String runtime;
  final String screeningTime;
  final double ticketPrice;
  final String imagePath;

  const Movie(
      {required this.id,
      required this.title,
      required this.synopsis,
      required this.ageRating,
      required this.runtime,
      required this.screeningTime,
      required this.ticketPrice,
      required this.imagePath});

  String get formattedPrice => '£${ticketPrice.toStringAsFixed(2)}';

  factory Movie.fromJson(Map<String, dynamic> json) {
    final String id = json['id'] as String;
    final String title = json['title'] as String;
    final String synopsis = json['synopsis'] as String;
    final String ageRating = json['ageRating'] as String;
    final String runtime = json['runtime'] as String;
    final String screeningTime = json['screeningTime'] as String;
    final num ticketPriceNumber = (json['ticketPrice'] as num);
    final double ticketPrice = ticketPriceNumber.toDouble();
    final String imagePath = json['imagePath'] as String;

    return Movie(
      id: id,
      title: title,
      synopsis: synopsis,
      ageRating: ageRating,
      runtime: runtime,
      screeningTime: screeningTime,
      ticketPrice: ticketPrice,
      imagePath: imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'title': title,
      'synopsis': synopsis,
      'ageRating': ageRating,
      'runtime': runtime,
      'screeningTime': screeningTime,
      'ticketPrice': ticketPrice,
      'imagePath': imagePath,
    };
    return data;
  }
}
