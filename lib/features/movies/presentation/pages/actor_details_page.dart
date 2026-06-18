import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinova/core/theme/app_colors.dart';
import 'package:kinova/features/movies/presentation/cubit/actor_details_cubit.dart';
import 'package:kinova/features/movies/presentation/widgets/movie_card.dart';
import '../../../../core/di/injection.dart';

class ActorDetailsPage extends StatelessWidget {
  final int actorId;

  const ActorDetailsPage({super.key, required this.actorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ActorDetailsCubit>()..loadActorDetails(actorId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<ActorDetailsCubit, ActorDetailsState>(
          builder: (context, state) {
            if (state is ActorDetailsLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            } else if (state is ActorDetailsError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
            } else if (state is ActorDetailsLoaded) {
              final actor = state.actor;
              final movies = state.movies;
              final imageUrl = actor.profilePath != null ? 'https://image.tmdb.org/t/p/w500${actor.profilePath}' : null;
              
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Arxa plan və Profil şəkli Hero hissəsi
                    Stack(
                      children: [
                        if (imageUrl != null)
                          Container(
                            height: 350,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                color: AppColors.background.withValues(alpha: 0.5),
                              ),
                            ),
                          )
                        else
                          Container(
                            height: 350,
                            width: double.infinity,
                            color: Colors.grey.shade900,
                          ),
                        // Qradient
                        Container(
                          height: 350,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [AppColors.background, Colors.transparent],
                            ),
                          ),
                        ),
                        // Profil şəkli və Ad
                        Positioned(
                          bottom: 0,
                          left: 16,
                          right: 16,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10)],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: imageUrl != null
                                    ? Image.network(imageUrl, width: 120, height: 180, fit: BoxFit.cover)
                                    : Container(width: 120, height: 180, color: Colors.grey.shade800, child: const Icon(Icons.person, size: 50, color: Colors.white)),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      actor.name,
                                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    const SizedBox(height: 8),
                                    if (actor.birthday != null)
                                      Text('Doğum: ${actor.birthday}', style: TextStyle(color: Colors.grey.shade300, fontSize: 14)),
                                    if (actor.placeOfBirth != null)
                                      Text('Yer: ${actor.placeOfBirth}', style: TextStyle(color: Colors.grey.shade300, fontSize: 14)),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Bioqrafiya
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Bioqrafiya', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              actor.biography.isNotEmpty ? actor.biography : 'Məlumat tapılmadı.',
                              style: const TextStyle(color: Colors.white70, height: 1.6, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Filmoqrafiya
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Filmoqrafiya', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200, // Netflix stili yığcam kartlar
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: SizedBox(
                              width: 130,
                              child: MovieCard(
                                movie: movies[index],
                                heroTag: 'actor_movie_${movies[index].id}',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
