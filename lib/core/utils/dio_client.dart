import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/api_constants.dart';

class DioClient {
  // Singleton pattern (agar cuma ada 1 instance Dio di aplikasi)
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  
  late Dio _dio;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10), // Batas waktu connect 10 detik
        receiveTimeout: const Duration(seconds: 10),
        queryParameters: {
          'api_key': ApiConstants.apiKey, // OTOMATIS pasang API Key disini
          'language': 'en-US', // Default bahasa Inggris
        },
      ),
    );

    // Pasang Logger (Biar kelihatan di terminal)
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  // Getter biar bisa dipanggil dari luar
  Dio get dio => _dio;
}