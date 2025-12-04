import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/tmdb_service.dart';

class SearchProvider extends ChangeNotifier {
  final TmdbService _tmdbService = TmdbService();

  List<Movie> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Movie> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fungsi untuk reset hasil (misal saat keluar halaman)
  void clearSearch() {
    _searchResults = [];
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      clearSearch();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Panggil Service baru tadi
      _searchResults = await _tmdbService.searchMovies(query);
      
      if (_searchResults.isEmpty) {
        _errorMessage = "Tidak ada film ditemukan.";
      }
    } catch (e) {
      _errorMessage = "Gagal mencari film.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}