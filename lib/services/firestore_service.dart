import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  // 1. TAMBAH
  Future<void> addToWatchlist(Movie movie) async {
    final uid = _userId;
    if (uid == null) return;

    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('watchlist')
          .doc(movie.id.toString())
          .set(movie.toJson());
    } catch (e) {
      throw e;
    }
  }

  // 2. HAPUS
  Future<void> removeFromWatchlist(String movieId) async {
    final uid = _userId;
    if (uid == null) return;

    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('watchlist')
          .doc(movieId)
          .delete();
    } catch (e) {
      throw e;
    }
  }

  // 3. AMBIL DATA 
  Stream<List<Movie>> getWatchlistStream({String? targetUserId}) {
    final uid = targetUserId ?? _userId;

    if (uid == null) {
      return const Stream.empty(); 
    }

    return _db
        .collection('users')
        .doc(uid)
        .collection('watchlist')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Movie.fromJson(doc.data());
          }).toList();
        });
  }
}