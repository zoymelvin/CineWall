import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/movie_provider.dart';
import '../../widgets/movie_item_full.dart';

class MovieFeedScreen extends StatefulWidget {
  const MovieFeedScreen({super.key});

  @override
  State<MovieFeedScreen> createState() => _MovieFeedScreenState();
}

class _MovieFeedScreenState extends State<MovieFeedScreen> {
  // Controller untuk PageView
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Panggil data pertama kali saat aplikasi dibuka
    // Kita pakai addPostFrameCallback agar aman dipanggil di initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchMovies();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dasar hitam
      
      // Consumer mendengarkan perubahan data di MovieProvider
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          
          // 1. Jika Data Kosong & Sedang Loading Awal -> Tampilkan Loading Tengah
          if (provider.movies.isEmpty && provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          }

          // 2. Jika Error -> Tampilkan Pesan Error
          if (provider.errorMessage != null && provider.movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text(provider.errorMessage!, style: const TextStyle(color: Colors.white)),
                  ElevatedButton(
                    onPressed: () => provider.fetchMovies(isRefresh: true),
                    child: const Text("Coba Lagi"),
                  )
                ],
              ),
            );
          }

          // 3. Jika Data Ada -> Tampilkan PAGEVIEW (Vertical Cinema)
          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical, // RAHASIA TIKTOK STYLE
            itemCount: provider.movies.length,
            
            // Logic Infinite Scroll ada disini:
            onPageChanged: (index) {
              // Jika user sudah sampai di 3 item terakhir...
              if (index >= provider.movies.length - 3) {
                // ...Panggil provider untuk ambil halaman berikutnya
                provider.fetchMovies();
              }
            },
            
            itemBuilder: (context, index) {
              final movie = provider.movies[index];
              return MovieItemFull(movie: movie);
            },
          );
        },
      ),
    );
  }
}