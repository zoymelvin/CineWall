import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/api_constants.dart';
import '../../../providers/search_provider.dart';
import '../../widgets/movie_item_full.dart'; // Kita pinjam logic navigasinya

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 1. KOLOM PENCARIAN (Input Field)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Cari film (Avengers, Batman...)',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                // Fungsi dipanggil saat user tekan Enter/Search di keyboard
                onSubmitted: (query) {
                  context.read<SearchProvider>().search(query);
                },
                // Opsional: Search saat mengetik (debounce) bisa ditambahkan nanti
              ),
            ),

            // 2. HASIL PENCARIAN
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.red));
                  }

                  if (provider.errorMessage != null) {
                    return Center(child: Text(provider.errorMessage!, style: const TextStyle(color: Colors.white54)));
                  }

                  if (provider.searchResults.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.movie_creation_outlined, size: 60, color: Colors.white24),
                          const SizedBox(height: 10),
                          Text("Cari film favoritmu", style: GoogleFonts.poppins(color: Colors.white24)),
                        ],
                      ),
                    );
                  }

                  // Tampilan Grid Hasil
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 Kolom
                      childAspectRatio: 0.65, // Rasio Poster
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: provider.searchResults.length,
                    itemBuilder: (context, index) {
                      final movie = provider.searchResults[index];
                      // Kita pakai MovieItemFull TAPI versi Grid (Kita buat widget baru atau modif dikit)
                      // Biar cepat, kita buat tampilan Grid Item disini langsung
                      return GestureDetector(
                        onTap: () {
                          // Pake logika navigasi yang sama
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieItemFull(movie: movie).build(context), 
                              // Trik: Kita panggil build method MovieItemFull biar navigasinya jalan
                              // Atau sebaiknya import Screen Detail langsung:
                              // builder: (context) => MovieDetailScreen(movie: movie),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CachedNetworkImage(
                                  imageUrl: movie.posterPath.isNotEmpty 
                                      ? '${ApiConstants.imageOriginalUrl}${movie.posterPath}'
                                      : 'https://via.placeholder.com/300',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Judul kecil di bawah
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.black.withOpacity(0.7),
                                  child: Text(
                                    movie.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}