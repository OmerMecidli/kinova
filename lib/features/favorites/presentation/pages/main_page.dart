import 'package:flutter/material.dart';
import 'package:kinova/features/search/presentation/pages/search_page.dart';
import '../../../favorites/presentation/pages/favorites_page.dart';
import '../../../movies/presentation/pages/movies_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; // Aktiv tabın indeksi

  // Alt menyuda göstəriləcək səhifələrin siyahısı
  final List<Widget> _pages = const [
    MoviesPage(),
    SearchPage(),
    FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack sayəsində tab dəyişəndə səhifələr sıfırlanmır, yaddaşda qalır
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black.withValues(alpha: 0.9), // Netflix-style translucent black
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade600,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home_outlined)),
            activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home)),
            label: 'Ana Səhifə',
          ),
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.search_outlined)),
            activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.search)),
            label: 'Axtarış',
          ),
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.video_library_outlined)),
            activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.video_library)),
            label: 'Siyahım',
          ),
        ],
      ),
    );
  }
}