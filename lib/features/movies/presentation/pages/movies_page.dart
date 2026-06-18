import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/movies_cubit.dart';
import '../cubit/genres_cubit.dart';
import '../widgets/movie_card.dart';
import '../../domain/entities/movie.dart';

import 'dart:math' as math;
import 'package:kinova/features/favorites/presentation/cubit/favorites_cubit.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  Movie? _featuredMovie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true, // Netflix stili üçün AppBar-ı bədənin üzərinə çıxarırıq
      appBar: AppBar(
        title: const Text(
          'KINOVA', 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: AppColors.primary,
            fontSize: 28,
            letterSpacing: 1.5,
          )
        ),
        backgroundColor: Colors.transparent, // Şəffaf arxa plan
        elevation: 0,
      ),
      body: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is MoviesError) {
            return Center(child: Text(state.message, style: const TextStyle(color: AppColors.textPrimary)));
          } else if (state is MoviesLoaded) {
            if (_featuredMovie == null && state.popularMovies.isNotEmpty) {
              final random = math.Random();
              // Məsələn ilk 10 film arasından təsadüfi birini seçirik ki, həm maraqlı, həm də reytinqli olsun
              int maxIndex = state.popularMovies.length > 10 ? 10 : state.popularMovies.length;
              _featuredMovie = state.popularMovies[random.nextInt(maxIndex)];
            }
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              // Padding yoxdur ki, şəkil ekranın lap yuxarısından başlasın
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Banner (Təsadüfi film)
                  if (_featuredMovie != null)
                    _buildHeroBanner(context, _featuredMovie!),
                  
                  const SizedBox(height: 16),
                  
                  // Janr Filtri
                  _buildGenreFilter(),
                  
                  const SizedBox(height: 16),

                  // Janra görə axtarış nəticəsi və ya normal kateqoriyalar
                  BlocBuilder<GenresCubit, GenresState>(
                    builder: (context, genreState) {
                      if (genreState is GenresLoaded && genreState.selectedGenreId != null && genreState.selectedGenreId != -1) {
                        if (genreState.moviesForGenre.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(color: AppColors.primary),
                            ),
                          );
                        }
                        return NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                              context.read<GenresCubit>().loadMoreMovies();
                            }
                            return false;
                          },
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(), // SingleChildScrollView içindədir deyə Never
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: genreState.moviesForGenre.length,
                            itemBuilder: (context, index) {
                              final movie = genreState.moviesForGenre[index];
                              return MovieCard(movie: movie, heroTag: 'genre_${movie.id}');
                            },
                          ),
                        );
                      }

                      // Normal Görünüş (Netflix Kategoriyaları)
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMovieCategory(
                            'Gündəmin Trendləri', 
                            'popular', 
                            state.popularMovies.skip(1).toList(), // İlk filmi Hero Banner-də göstərdik deyə skip edirik
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
                          const SizedBox(height: 40),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        context.push('/details', extra: {'movie': movie, 'heroTag': 'hero_${movie.id}'});
      },
      child: Stack(
        children: [
          // Arxa plan şəkli
          Container(
            height: 500,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('${ApiConstants.imageBaseUrl}${movie.posterPath}'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          // Qradient effekt
          Container(
            height: 500,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.background, // Aşağısı tam qara
                  Colors.transparent,   // Ortası şəffaf
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.center, 
              ),
            ),
          ),
          // Filmin adı və düymələr
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black, blurRadius: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Play Düyməsi
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push('/details', extra: {'movie': movie, 'heroTag': 'hero_${movie.id}'});
                      },
                      icon: const Icon(Icons.play_arrow, color: Colors.black, size: 28),
                      label: const Text('Oynat', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Siyahım Düyməsi
                    BlocBuilder<FavoritesCubit, FavoritesState>(
                      builder: (context, favState) {
                        bool isFavorite = favState.favorites.any((m) => m.id == movie.id);
                        return OutlinedButton.icon(
                          onPressed: () {
                            context.read<FavoritesCubit>().toggleFavorite(movie);
                          },
                          icon: Icon(isFavorite ? Icons.check : Icons.add, color: Colors.white),
                          label: const Text('Siyahım', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white, width: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            backgroundColor: Colors.black45,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreFilter() {
    return BlocBuilder<GenresCubit, GenresState>(
      builder: (context, state) {
        if (state is GenresLoaded) {
          return SizedBox(
            height: 40, // Daha kompakt
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: state.genres.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isSelected = state.selectedGenreId == null;
                  return _buildGenreChip(context, 'Hamısı', isSelected, -1);
                }
                final genre = state.genres[index - 1];
                final isSelected = state.selectedGenreId == genre.id;
                return _buildGenreChip(context, genre.name, isSelected, genre.id);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGenreChip(BuildContext context, String name, bool isSelected, int id) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: () {
          context.read<GenresCubit>().selectGenre(id);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? Colors.white : Colors.white30),
          ),
          alignment: Alignment.center,
          child: Text(
            name,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieCategory(String title, String tagPrefix, List<Movie> movies, VoidCallback onLoadMore) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), // Daha sıx boşluq
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(
          height: 180, // Netflix tipli horizontal kartlar bir az daha yığcam olur
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                onLoadMore();
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0), // Kartlar arası məsafə kiçikdir
                  child: SizedBox(
                    width: 120, // Daha enli deyil, standart Netflix kartı kimidir
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
