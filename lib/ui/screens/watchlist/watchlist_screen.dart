import 'package:cinemawall/core/constants/api_constants.dart';
import 'package:cinemawall/models/movie_model.dart';
import 'package:cinemawall/ui/widgets/movie_item_full.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Text("Silakan Login Terlebih Dahulu", style: TextStyle(color: Colors.white))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("My Watchlist", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')      
            .doc(user.uid)            
            .collection('watchlist')  
            .snapshots(),             
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.movie_filter, size: 60, color: Colors.white24),
                  const SizedBox(height: 10),
                  Text("Watchlist Kosong", style: GoogleFonts.poppins(color: Colors.white24)),
                  const SizedBox(height: 5),
                  // DEBUG: Tampilkan ID User biar ketahuan kalau salah akun
                  Text("User ID: ${user.uid}", style: const TextStyle(color: Colors.white12, fontSize: 10)), 
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final movie = Movie(
                id: (data['id'] as num?)?.toInt() ?? 0,
                title: data['title']?.toString() ?? 'No Title',
                overview: data['overview']?.toString() ?? '',
                posterPath: data['poster_path']?.toString() ?? '',
                backdropPath: data['backdrop_path']?.toString() ?? '',
                voteAverage: (data['vote_average'] as num?)?.toDouble() ?? 0.0,
                releaseDate: data['release_date']?.toString() ?? '',
              );

              return GestureDetector(
                onTap: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => MovieItemFull(movie: movie)),
                   );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: movie.posterPath.isNotEmpty
                      ? '${ApiConstants.imageOriginalUrl}${movie.posterPath}'
                      : 'https://via.placeholder.com/300',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey[900]),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}