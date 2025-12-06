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

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      // Pakai 'as num?' biar aman kalau datanya Int atau Double
      id: (json['id'] as num?)?.toInt() ?? 0, 
      
      title: json['title']?.toString() ?? 'No Title',
      
      overview: json['overview']?.toString() ?? '',
      
      posterPath: json['poster_path']?.toString() ?? '',
      
      backdropPath: json['backdrop_path']?.toString() ?? '',
      
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      
      releaseDate: json['release_date']?.toString() ?? 'Unknown',
    );
  }
  
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