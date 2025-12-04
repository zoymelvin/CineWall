import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/tmdb_service.dart';

class MovieProvider extends ChangeNotifier {
  final TmdbService _tmdbService = TmdbService();

  // State (Data yang akan berubah-ubah)
  List<Movie> _movies = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1; // Mulai dari halaman 1

  // Getter (Agar UI bisa baca data, tapi tidak bisa ubah sembarangan)
  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fungsi Utama: Ambil Data Film
  Future<void> fetchMovies({bool isRefresh = false}) async {
    // Jika sedang refresh (tarik layat ke bawah), reset semua data
    if (isRefresh) {
      _currentPage = 1;
      _movies = [];
      _errorMessage = null;
    }

    // Cegah request dobel (Kalau lagi loading, jangan request lagi)
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners(); // Kabari UI: "Sedang Loading..."

    try {
      // Panggil Service (Dio)
      final newMovies = await _tmdbService.getPopularMovies(page: _currentPage);
      
      // Tambahkan film baru ke list yang sudah ada (Append)
      _movies.addAll(newMovies);
      
      // Siapkan halaman berikutnya untuk request selanjutnya
      _currentPage++; 
      _errorMessage = null;

    } catch (e) {
      // Jika error, simpan pesannya biar bisa ditampilkan di UI
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Kabari UI: "Selesai Loading / Error"
    }
  }
}