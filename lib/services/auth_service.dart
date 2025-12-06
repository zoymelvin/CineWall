import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart'; 

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // 1. Fungsi Login
  Future<UserModel?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );

      return UserModel(
        id: cred.user!.uid, 
        email: cred.user!.email!, 
        name: "User" 
      );
    } catch (e) {
      throw e; // Lempar error biar ditangkap Provider
    }
  }

  // 2. Fungsi Register
  Future<UserModel?> register(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      return UserModel(
        id: cred.user!.uid, 
        email: cred.user!.email!, 
        name: "New User"
      );
    } catch (e) {
      throw e;
    }
  }

  // 3. Fungsi Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}