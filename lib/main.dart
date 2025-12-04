import 'package:cinemawall/ui/screens/feed/movie_feed_screen.dart';
import 'package:cinemawall/ui/screens/main/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/search_provider.dart';

// 1. IMPORT FILE OTOMATIS TADI
import 'firebase_options.dart'; 

import 'providers/movie_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. UBAH BAGIAN INI
  // Kita panggil options yang dibuat oleh FlutterFire CLI
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider: Tempat mendaftarkan semua "Otak" aplikasi
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        // Nanti AuthProvider dan WatchlistProvider ditambah disini
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: MaterialApp(
        title: 'CineWall',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Tema Gelap (Dark Mode) sesuai konsep Vertical Cinema
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          primaryColor: const Color(0xFFE50914), // Merah Netflix
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
          useMaterial3: true,
        ),
        // Untuk sementara kita arahkan ke Scaffold kosong dulu biar bisa di-Run
        home: const MainWrapper(),
      ),
    );
  }
}