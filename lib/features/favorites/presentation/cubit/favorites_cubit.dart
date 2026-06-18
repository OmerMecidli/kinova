import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kinova/features/movies/domain/entities/movie.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/favorite_usecases.dart';

class FavoritesState {
  final List<Movie> favorites;
  FavoritesState(this.favorites);
}

@injectable
class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase _getFavorites;
  final ToggleFavoriteUseCase _toggleFavorite;

  FavoritesCubit(this._getFavorites, this._toggleFavorite) : super(FavoritesState([])) {
    loadFavorites();
  }

  void loadFavorites() {
    final result = _getFavorites(NoParams());
    result.fold(
      (failure) => emit(FavoritesState([])),
      (movies) => emit(FavoritesState(movies)),
    );
  }

  Future<void> toggleFavorite(Movie movie) async {
    await _toggleFavorite(ToggleFavoriteParams(movie: movie));
    loadFavorites();
  }

  bool isFavorite(int movieId) {
    return state.favorites.any((movie) => movie.id == movieId);
  }
}