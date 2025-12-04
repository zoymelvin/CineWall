import 'package:dio/dio.dart';
import '../core/utils/dio_client.dart';
import '../core/errors/api_exceptions.dart';
import '../models/movie_model.dart';

class TmdbService {
  final Dio _dio = DioClient().dio;

  // Fungsi ambil film popular dengan Pagination
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      // Request ke endpoint /movie/popular
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );

      // Cek hasil (Parsing JSON)
      final List results = response.data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();

    } on DioException catch (e) {
      // Tangkap Error Dio dan ubah jadi Error kita sendiri
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw NetworkException();
      } else if (e.response?.statusCode == 404) {
        throw NotFoundException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ApiException("Terjadi kesalahan tak terduga: $e");
    }
  }
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return []; // Jangan cari kalau kosong

    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {
          'query': query, // Kata kunci pencarian
          'include_adult': false, // Saring konten dewasa
        },
      );

      final List results = response.data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      // Kita pakai error handling yang sama
      throw e; 
    }
  }
}