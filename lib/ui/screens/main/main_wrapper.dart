import 'package:cinemawall/ui/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import '../feed/movie_feed_screen.dart';
import '../../widgets/glass_bottom_nav.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  // Daftar Halaman
  final List<Widget> _pages = [
    const MovieFeedScreen(),        // Halaman 0: Feed Film
    const SearchScreen(),
    const Center(child: Text("Watchlist Page", style: TextStyle(color: Colors.white))), // Halaman 2: Dummy dulu
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // LAYER 1: Halaman Konten (Full Screen)
          _pages[_currentIndex],

          // LAYER 2: Navbar Melayang (Paling Bawah)
          Positioned(
            bottom: 20, // Jarak dari lantai layar
            left: 20,
            right: 20,
            child: GlassBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}