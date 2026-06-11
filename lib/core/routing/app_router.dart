import 'package:go_router/go_router.dart';
import 'package:kinova/features/favorites/presentation/pages/main_page.dart';
import '../../features/movies/domain/entities/movie.dart';
import '../../features/movies/presentation/pages/movie_details_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart'; // Əlavə etdik

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/', // Tətbiq burdan başlayır
    routes: [
      // 1. Splash Ekranı
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      // 2. Əsas Ekranımız (Alt menyulu səhifə)
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainPage(),
      ),
      // 3. Detallar
      // 3. Detallar
      GoRoute(
        path: '/details',
        builder: (context, state) {
          // BURA DƏYİŞDİ: Göndərdiyimiz Map-i tuturuq
          final data = state.extra as Map<String, dynamic>;
          final movie = data['movie'] as Movie;
          final heroTag = data['heroTag'] as String;
          
          return MovieDetailsPage(movie: movie, heroTag: heroTag);
        },
      ),
    ],
  );
}