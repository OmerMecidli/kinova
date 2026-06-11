import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../movies/presentation/widgets/movie_card.dart';
import '../cubit/search_cubit.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Başlığın yerinə Axtarış Barı qoyuruq
        title: TextField(
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Filmləri axtarın...',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
          onChanged: (query) {
            // Hər hərf dəyişəndə Cubit-ə xəbər veririk (Debounce arxada öz işini görəcək)
            context.read<SearchCubit>().searchMovies(query);
          },
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const Center(
              child: Text(
                'Axtarmaq istədiyiniz filmin adını daxil edin.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            );
          } 
          
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } 
          
          if (state is SearchError) {
            return Center(child: Text(state.message, style: const TextStyle(color: AppColors.textPrimary)));
          } 
          
          if (state is SearchLoaded) {
            if (state.movies.isEmpty) {
              return const Center(
                child: Text('Heç bir nəticə tapılmadı.', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                return MovieCard(movie: state.movies[index]);
              },
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}