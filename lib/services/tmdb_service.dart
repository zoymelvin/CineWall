import 'package:dio/dio.dart';
import '../core/utils/dio_client.dart';
import '../core/errors/api_exceptions.dart';
import '../models/movie_model.dart';

class TmdbService {
  final Dio _dio = DioClient().dio;

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );

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
    if (query.isEmpty) return []; 

    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {
          'query': query,
          'include_adult': false,
        },
      );

      final List results = response.data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw e; 
    }
  }
}