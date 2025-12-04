class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  // Factory Method: Ini mesin konversinya (JSON -> Object)
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0, // Jika null, isi 0
      title: json['title'] ?? 'No Title',
      overview: json['overview'] ?? 'No overview available.',
      // Kadang poster bisa null, kita handle di UI nanti atau beri string kosong
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      // Konversi aman ke Double (karena API kadang kirim Integer)
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] ?? 'Unknown',
    );
  }

  // Method: Ubah Object jadi JSON (Berguna kalau mau simpan ke Firebase nanti)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
    };
  }
}