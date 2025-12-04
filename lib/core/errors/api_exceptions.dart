class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

// Error kalau tidak ada internet
class NetworkException extends ApiException {
  NetworkException() : super("Koneksi internet bermasalah. Periksa wifi/data Anda.");
}

// Error kalau server TMDB lagi down (Kode 500)
class ServerException extends ApiException {
  ServerException() : super("Maaf, server sedang sibuk. Coba lagi nanti.");
}

// Error kalau data tidak ditemukan (Kode 404)
class NotFoundException extends ApiException {
  NotFoundException() : super("Data tidak ditemukan.");
}