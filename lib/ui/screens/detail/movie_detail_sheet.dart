import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/api_constants.dart';
import '../../../models/movie_model.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 500, 
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: '${ApiConstants.imageOriginalUrl}${movie.posterPath}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey[900]),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFF121212), 
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 50,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Besar
                  Text(
                    movie.title,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          movie.releaseDate.split('-')[0],
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Icon Bintang & Rating
                      const Icon(Icons.star, color: Color(0xFFF5C518), size: 18),
                      const SizedBox(width: 4),
                      Text(
                        "${movie.voteAverage.toStringAsFixed(1)} Rating",
                        style: GoogleFonts.poppins(
                            color: const Color(0xFFF5C518), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Wrap(
                    spacing: 10,
                    children: [
                      _buildGenreChip("Action"),
                      _buildGenreChip("Sci-Fi"),
                      _buildGenreChip("Thriller"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Storyline",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.overview,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[400],
                      fontSize: 15,
                      height: 1.8,
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreChip(String label) {
    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
      backgroundColor: Colors.white.withOpacity(0.1),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
    );
  }
}