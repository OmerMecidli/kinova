import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinova/features/movies/domain/entities/movie.dart';

import '../../data/repositories/favorite_repository.dart';

class FavoritesState {
  final List<Movie> favorites;
  FavoritesState(this.favorites);
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoriteRepository _repository;

  FavoritesCubit(this._repository) : super(FavoritesState([])) {
    // Cubit yaranan kimi yaddaşdakı filmləri çəkirik
    loadFavorites();
  }

  void loadFavorites() {
    emit(FavoritesState(_repository.getFavorites()));
  }

  Future<void> toggleFavorite(Movie movie) async {
    await _repository.toggleFavorite(movie);
    loadFavorites(); // Əməliyyatdan sonra siyahını yeniləyirik
  }

  // Müəyyən bir filmin siyahıda olub-olmadığını yoxlayır
  bool isFavorite(int movieId) {
    return state.favorites.any((movie) => movie.id == movieId);
  }
}