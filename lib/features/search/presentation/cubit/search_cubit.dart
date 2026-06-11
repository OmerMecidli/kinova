import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/data/repositories/movie_repository_impl.dart';

// --- State Sinfi ---
abstract class SearchState {}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchLoaded extends SearchState {
  final List<Movie> movies;
  SearchLoaded(this.movies);
}
class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

// --- Cubit Sinfi ---
class SearchCubit extends Cubit<SearchState> {
  final MovieRepositoryImpl _repository;
  Timer? _debounce; // Gecikdirmə taymeri

  SearchCubit(this._repository) : super(SearchInitial());

  void searchMovies(String query) {
    // Əgər axtarış sahəsi boşdursa, ekrana ilkin vəziyyəti qaytarırıq
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    // Əvvəlki taymer hələ işləyirsə, onu ləğv edirik (Debounce)
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // 500ms gözləyirik. Əgər istifadəçi yeni hərf yazmasa, sorğunu göndəririk
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(SearchLoading());
      try {
        final movies = await _repository.searchMovies(query);
        emit(SearchLoaded(movies));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel(); // Cubit bağlananda taymeri təmizləyirik
    return super.close();
  }
}