import 'package:flutter/material.dart';
import '../../widgets/glass_bottom_nav.dart';
import '../feed/movie_feed_screen.dart';
import '../search/search_screen.dart';
import '../watchlist/watchlist_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  // DAFTAR HALAMAN (Pages)
  final List<Widget> _pages = [
    const MovieFeedScreen(),  
    const SearchScreen(),     
    const WatchlistScreen(),  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),

          Positioned(
            bottom: 20,
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