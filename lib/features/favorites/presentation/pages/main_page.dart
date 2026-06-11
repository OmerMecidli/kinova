import 'package:flutter/material.dart';
import 'package:kinova/features/search/presentation/pages/search_page.dart';
import '../../../../core/theme/app_colors.dart';
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
        backgroundColor: AppColors.background, // Qara fon
        selectedItemColor: Colors.white, // Seçilmiş tabın rəngi
        unselectedItemColor: AppColors.textSecondary, // Seçilməmişlərin rəngi
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Taba klikləyəndə indeksi dəyişirik
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Ana Səhifə',
          ),
          BottomNavigationBarItem( // Yeni Tab
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Axtarış',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            activeIcon: Icon(Icons.video_library),
            label: 'Siyahım',
          ),
        ],
      ),
    );
  }
}