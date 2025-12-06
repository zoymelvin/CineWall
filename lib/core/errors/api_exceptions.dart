class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException() : super("Koneksi internet bermasalah. Periksa wifi/data Anda.");
}

class ServerException extends ApiException {
  ServerException() : super("Maaf, server sedang sibuk. Coba lagi nanti.");
}

class NotFoundException extends ApiException {
  NotFoundException() : super("Data tidak ditemukan.");
}