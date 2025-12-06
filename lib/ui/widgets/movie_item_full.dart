import 'package:cinemawall/ui/screens/detail/movie_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/api_constants.dart';
import '../../models/movie_model.dart';

class MovieItemFull extends StatelessWidget {
  final Movie movie;

  const MovieItemFull({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final imageUrl = movie.posterPath.isNotEmpty
        ? '${ApiConstants.imageOriginalUrl}${movie.posterPath}'
        : 'https://via.placeholder.com/500x750?text=No+Image';

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
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[900]),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
          ),

          Positioned(
            left: 20,
            right: 100,
            bottom: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: GoogleFonts.poppins(
                    fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      movie.releaseDate.split('-')[0], // Tahun
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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

          Positioned(
            right: 10,
            bottom: 140,
            child: Column(
              children: [
                _buildCircleButton(Icons.info_outline, "Info", () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)),
                  );
                }),
                const SizedBox(height: 20),
                
                _LoveButton(movie: movie), 
                // -------------------------------------------
                
                const SizedBox(height: 20),
                _buildCircleButton(Icons.share, "Share", () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black45,
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

class _LoveButton extends StatelessWidget {
  final Movie movie;
  const _LoveButton({required this.movie});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Icon(Icons.favorite_border, color: Colors.grey);
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .doc(movie.id.toString());

    return StreamBuilder<DocumentSnapshot>(
      stream: docRef.snapshots(), 
      builder: (context, snapshot) {
        
        // Cek apakah data ada di database?
        bool isSaved = false;
        if (snapshot.hasData && snapshot.data!.exists) {
          isSaved = true;
        }

        return GestureDetector(
          onTap: () async {
            if (isSaved) {
              await docRef.delete();
            } else {
              await docRef.set({
                'id': movie.id,
                'title': movie.title,
                'poster_path': movie.posterPath,
                'overview': movie.overview,
                'release_date': movie.releaseDate,
                'vote_average': movie.voteAverage,
                'backdrop_path': movie.backdropPath,
              });
            }
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  color: isSaved ? Colors.red : Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 4),
              Text(isSaved ? "Saved" : "Save", style: const TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
        );
      },
    );
  }
}