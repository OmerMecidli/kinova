import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinova/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:kinova/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:kinova/features/movies/presentation/cubit/movie_extras_cubit.dart';
import 'package:kinova/features/movies/presentation/widgets/trailer_player.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/movie.dart';

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

    return BlocProvider(
      create: (context) =>
          MovieExtrasCubit(context.read<MovieRepositoryImpl>())
            ..loadExtras(movie.id),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.6,
              pinned: true,
              backgroundColor: AppColors.background,
              iconTheme: const IconThemeData(color: Colors.white),
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

                    BlocBuilder<FavoritesCubit, FavoritesState>(
                      builder: (context, state) {
                        final isFav = context.read<FavoritesCubit>().isFavorite(
                          movie.id,
                        );

                        return ElevatedButton.icon(
                          onPressed: () => context
                              .read<FavoritesCubit>()
                              .toggleFavorite(movie),
                          icon: Icon(
                            isFav ? Icons.check : Icons.add,
                            color: Colors.white,
                            size: 28,
                          ),
                          label: Text(
                            isFav ? 'Siyahıdadır' : 'Mənim Siyahım',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFav
                                ? Colors.green.withValues(alpha: .2)
                                : AppColors.surface,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(
                                color: isFav
                                    ? Colors.green
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        );
                      },
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
}
