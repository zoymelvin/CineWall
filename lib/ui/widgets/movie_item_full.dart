import 'package:cinemawall/ui/screens/detail/movie_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/api_constants.dart';
import '../../models/movie_model.dart';

class MovieItemFull extends StatelessWidget {
  final Movie movie;

  const MovieItemFull({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    // Gabungkan Base URL dengan path poster
    final imageUrl = movie.posterPath.isNotEmpty
        ? '${ApiConstants.imageOriginalUrl}${movie.posterPath}'
        : 'https://via.placeholder.com/500x750?text=No+Image';

    // 1. BUNGKUS DENGAN GESTURE DETECTOR
    // Agar saat user klik di mana saja pada gambar, pindah ke halaman detail
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: movie),
          ),
        );
      },
      child: Stack(
        children: [
          // LAYER 1: Gambar Poster Fullscreen
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover, // Gambar memenuhi layar
              placeholder: (context, url) => Container(
                color: const Color(0xFF121212),
                child: const Center(child: CircularProgressIndicator(color: Colors.red)),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),

          // LAYER 2: Gradient Overlay (Agar teks terbaca)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,        // Bawah: Hitam Pekat
                    Colors.black54,      // Tengah Bawah: Agak Gelap
                    Colors.transparent,  // Tengah: Transparan
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
          ),

          // LAYER 3: Informasi Film (Kiri Bawah)
          Positioned(
            left: 20,
            right: 100, // Jarak kanan lebar agar tidak menabrak tombol aksi
            bottom: 140, // Jarak bawah tinggi agar tidak tertutup Navbar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Film
                Text(
                  movie.title,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                
                // Rating & Tahun
                Row(
                  children: [
                    // Badge Rating
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5C518), // Kuning IMDb
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.black),
                          const SizedBox(width: 4),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Tahun Rilis
                    Text(
                      movie.releaseDate.split('-')[0], 
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                
                // Sinopsis Singkat
                Text(
                  movie.overview,
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // LAYER 4: Tombol Aksi (Kanan Bawah - Floating)
          Positioned(
            right: 10,
            bottom: 140, // Sejajar dengan teks
            child: Column(
              children: [
                // Tombol Info (Opsional, fungsinya sama dengan tap gambar)
                _buildActionButton(Icons.info_outline, "Info", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                
                // Tombol Watchlist/Love
                _buildActionButton(Icons.favorite_border, "Save", () {
                  // Nanti kita isi logic Firebase disini
                  print("Simpan ke Firebase");
                }),
                const SizedBox(height: 20),
                
                // Tombol Share
                _buildActionButton(Icons.share, "Share", () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget kecil untuk bikin tombol di kanan
  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black45, // Background transparan gelap
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }
}