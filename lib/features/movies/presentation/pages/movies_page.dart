import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/movies_cubit.dart';
import '../widgets/movie_card.dart';
import '../../domain/entities/movie.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KINOVA', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is MoviesError) {
            return Center(child: Text(state.message, style: const TextStyle(color: AppColors.textPrimary)));
          } else if (state is MoviesLoaded) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // YENİLİK: Hər siyahı üçün uyğun pagination metodunu göndəririk
                  _buildMovieCategory(
                    'Gündəmin Trendləri', 
                    'popular', 
                    state.popularMovies, 
                    () => context.read<MoviesCubit>().loadMorePopular(),
                  ),
                  _buildMovieCategory(
                    'Ən Yüksək Reytinqlilər', 
                    'top', 
                    state.topRatedMovies, 
                    () => context.read<MoviesCubit>().loadMoreTopRated(),
                  ),
                  _buildMovieCategory(
                    'Tezliklə Ekranlarda', 
                    'upcoming', 
                    state.upcomingMovies, 
                    () => context.read<MoviesCubit>().loadMoreUpcoming(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // YENİLİK: onLoadMore fuksiyası əlavə edildi
  Widget _buildMovieCategory(String title, String tagPrefix, List<Movie> movies, VoidCallback onLoadMore) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          // YENİLİK: Scroll hərəkətlərini dinləmək üçün NotificationListener əlavə edildi
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              // İstifadəçi ekranın sağına (sonuna) çatmağa 200 piksel qalmış yeni datanı yükləməyə başlayır
              if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                onLoadMore();
              }
              return false; // Digər dinləyicilərin də işləməsi üçün false qaytarırıq
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SizedBox(
                    width: 140,
                    child: MovieCard(
                      movie: movies[index],
                      heroTag: '${tagPrefix}_${movies[index].id}',
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}