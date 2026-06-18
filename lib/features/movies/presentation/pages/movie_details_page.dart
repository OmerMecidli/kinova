import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinova/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:kinova/features/movies/presentation/cubit/movie_extras_cubit.dart';
import 'package:kinova/features/movies/presentation/cubit/ratings_cubit.dart';
import 'package:kinova/features/movies/presentation/widgets/trailer_player.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/movie.dart';
import '../cubit/similar_movies_cubit.dart';
import '../widgets/movie_card.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;
  final String? heroTag; // BURA DƏYİŞDİ: parametr əlavə edildi

  const MovieDetailsPage({super.key, required this.movie, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final imageUrl = movie.posterPath != null
        ? '${ApiConstants.imageBaseUrl}${movie.posterPath}'
        : null;

    // BURA DƏYİŞDİ: unikal tag-i hazırlayırıq
    final uniqueTag = heroTag ?? movie.id.toString();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<MovieExtrasCubit>()..loadExtras(movie.id),
        ),
        BlocProvider(
          create: (context) => 
              getIt<SimilarMoviesCubit>()..loadSimilarMovies(movie.id),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.6,
              pinned: true,
              backgroundColor: AppColors.background,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // ignore: deprecated_member_use
                    Share.share('https://www.themoviedb.org/movie/${movie.id}');
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: imageUrl != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          // BURA DƏYİŞDİ: Hero tag-i əvəzlədik
                          Hero(
                            tag: uniqueTag,
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [
                                  AppColors.background,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(color: AppColors.surface),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Text(
                          '98% uyğundur',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          movie.releaseDate.split('-').first,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.textSecondary),
                          ),
                          child: Text(
                            '⭐ ${movie.voteAverage.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Oynat düyməsi
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow, color: Colors.black, size: 28),
                      label: const Text(
                        'Oynat',
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // İkon düymələr sırası (+ Siyahım, Rate, Share)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BlocBuilder<FavoritesCubit, FavoritesState>(
                          builder: (context, state) {
                            final isFav = context.read<FavoritesCubit>().isFavorite(movie.id);
                            return InkWell(
                              onTap: () => context.read<FavoritesCubit>().toggleFavorite(movie),
                              child: Column(
                                children: [
                                  Icon(isFav ? Icons.check : Icons.add, color: Colors.white, size: 30),
                                  const SizedBox(height: 4),
                                  const Text('Siyahım', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            );
                          },
                        ),
                        BlocBuilder<RatingsCubit, RatingsState>(
                          builder: (context, ratingsState) {
                            final currentRating = context.read<RatingsCubit>().getRating(movie.id);
                            return InkWell(
                              onTap: () {
                                _showRatingBottomSheet(context, currentRating);
                              },
                              child: Column(
                                children: [
                                  Icon(currentRating != null ? Icons.star : Icons.thumb_up_alt_outlined, color: Colors.white, size: 30),
                                  const SizedBox(height: 4),
                                  Text(currentRating != null ? currentRating.toStringAsFixed(1) : 'Qiymətləndir', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            );
                          },
                        ),
                        InkWell(
                          onTap: () {
                            // ignore: deprecated_member_use
                            Share.share('https://www.themoviedb.org/movie/${movie.id}');
                          },
                          child: const Column(
                            children: [
                              Icon(Icons.share, color: Colors.white, size: 30),
                              SizedBox(height: 4),
                              Text('Paylaş', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Text(
                      movie.overview.isNotEmpty
                          ? movie.overview
                          : 'Məzmun tapılmadı.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 60),
                    BlocBuilder<MovieExtrasCubit, MovieExtrasState>(
                      builder: (context, state) {
                        if (state is ExtrasLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }

                        if (state is ExtrasLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. YouTube Treyleri
                              if (state.trailerKey != null) ...[
                                const Text(
                                  'Treyler',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TrailerPlayer(trailerKey: state.trailerKey!),
                                const SizedBox(height: 24),
                              ],

                              // 2. Aktyorlar (Cast) Siyahısı
                              if (state.cast.isNotEmpty) ...[
                                const Text(
                                  'Aktyorlar',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 124,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.cast.length,
                                    itemBuilder: (context, index) {
                                      final actor = state.cast[index];
                                      final profilePath = actor['profile_path'];

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 16.0,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            context.push('/actor', extra: actor['id']);
                                          },
                                          child: Column(
                                            children: [
                                            CircleAvatar(
                                              radius: 40,
                                              backgroundColor:
                                                  AppColors.surface,
                                              backgroundImage:
                                                  profilePath != null
                                                  ? NetworkImage(
                                                      '${ApiConstants.imageBaseUrl}$profilePath',
                                                    )
                                                  : null,
                                              child: profilePath == null
                                                  ? const Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                    )
                                                  : null,
                                            ),
                                            const SizedBox(height: 8),
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                actor['name'],
                                                style: const TextStyle(
                                                  color:
                                                      AppColors.textSecondary,
                                                  fontSize: 12,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  ),
                                ),
                              ],
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Oxşar Filmlər',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<SimilarMoviesCubit, SimilarMoviesState>(
                      builder: (context, state) {
                        if (state is SimilarMoviesLoading) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                        } else if (state is SimilarMoviesLoaded) {
                          if (state.movies.isEmpty) {
                            return const Text('Oxşar film tapılmadı.', style: TextStyle(color: Colors.white70));
                          }
                          return SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.movies.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: SizedBox(
                                    width: 140,
                                    child: MovieCard(
                                      movie: state.movies[index],
                                      heroTag: 'similar_${movie.id}_${state.movies[index].id}',
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingBottomSheet(BuildContext parentContext, double? initialRating) {
    double currentSliderValue = initialRating ?? 5.0;
    
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return SafeArea(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Bu filmi necə qiymətləndirirsiniz?', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < (currentSliderValue / 2).round() ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 40,
                        );
                      }),
                    ),
                    Slider(
                      value: currentSliderValue,
                      min: 1.0,
                      max: 10.0,
                      divisions: 9,
                      activeColor: AppColors.primary,
                      label: currentSliderValue.toStringAsFixed(1),
                      onChanged: (val) {
                        setModalState(() {
                          currentSliderValue = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        parentContext.read<RatingsCubit>().rateMovie(movie.id, currentSliderValue);
                        Navigator.pop(bottomSheetContext);
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          const SnackBar(content: Text('Qiymətləndirilməniz yadda saxlanıldı!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(200, 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Təsdiqlə', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
