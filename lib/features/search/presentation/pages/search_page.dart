import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../movies/presentation/widgets/movie_card.dart';
import '../cubit/search_cubit.dart';
import '../../../movies/presentation/cubit/movies_cubit.dart' as kinova;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: 'Filmləri axtarın...',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _searchController.clear();
                context.read<SearchCubit>().searchMovies('');
              },
            ),
            filled: true,
            fillColor: Colors.grey.shade900,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
          onChanged: (query) {
            context.read<SearchCubit>().searchMovies(query);
          },
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.history.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Əvvəlki Axtarışlar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () => context.read<SearchCubit>().clearHistory(),
                          child: const Text('Təmizlə', style: TextStyle(color: AppColors.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: state.history.map((query) {
                        return InputChip(
                          label: Text(query, style: const TextStyle(color: Colors.white)),
                          backgroundColor: Colors.grey.shade900,
                          deleteIcon: const Icon(Icons.close, size: 18, color: Colors.grey),
                          onDeleted: () => context.read<SearchCubit>().removeHistoryItem(query),
                          onPressed: () {
                            _searchController.text = query;
                            // Set cursor to the end
                            _searchController.selection = TextSelection.fromPosition(TextPosition(offset: query.length));
                            context.read<SearchCubit>().searchMovies(query);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                  
                  const Text('Tövsiyə Edilənlər', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  // Tövsiyələr üçün MoviesCubit-dən istifadə edirik
                  BlocBuilder<kinova.MoviesCubit, kinova.MoviesState>(
                    builder: (context, moviesState) {
                      if (moviesState is kinova.MoviesLoaded) {
                        // İlk 6 popular filmi göstəririk
                        final recommended = moviesState.popularMovies.take(6).toList();
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: recommended.length,
                          itemBuilder: (context, index) {
                            return MovieCard(movie: recommended[index], heroTag: 'rec_${recommended[index].id}');
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            );
          } 
          
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } 
          
          if (state is SearchError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
          } 
          
          if (state is SearchLoaded) {
            if (state.movies.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sentiment_dissatisfied, size: 80, color: Colors.grey.shade800),
                    const SizedBox(height: 16),
                    Text('Heç bir nəticə tapılmadı.', style: TextStyle(color: Colors.grey.shade500, fontSize: 18)),
                  ],
                ),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(12.0),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                return MovieCard(movie: state.movies[index], heroTag: 'search_${state.movies[index].id}');
              },
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}