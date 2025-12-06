import 'package:flutter/material.dart';
import '../../../services/tmdb_service.dart';
import '../../../models/movie_model.dart';
import '../../widgets/movie_item_full.dart';

class MovieFeedScreen extends StatefulWidget {
  const MovieFeedScreen({super.key});

  @override
  State<MovieFeedScreen> createState() => _MovieFeedScreenState();
}

class _MovieFeedScreenState extends State<MovieFeedScreen> {
  final TmdbService _tmdbService = TmdbService();
  final PageController _pageController = PageController();
  
  List<Movie> _movies = []; // Data film disimpan disini
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      
      final newMovies = await _tmdbService.getPopularMovies(page: _currentPage);
      
      setState(() {
        _movies.addAll(newMovies); 
        _currentPage++; 
        _isLoading = false; 
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_movies.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.red));
    }

    if (_movies.isEmpty && _errorMessage != null) {
      return Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.white)));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _movies.length,
        onPageChanged: (index) {

          if (index >= _movies.length - 2) {
            _fetchMovies();
          }
        },
        itemBuilder: (context, index) {
          return MovieItemFull(movie: _movies[index]);
        },
      ),
    );
  }
}