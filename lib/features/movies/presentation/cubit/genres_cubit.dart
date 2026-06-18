import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/genre.dart';
import '../../domain/usecases/genre_usecases.dart';
import '../../domain/entities/movie.dart';

abstract class GenresState {}

class GenresInitial extends GenresState {}
class GenresLoading extends GenresState {}
class GenresLoaded extends GenresState {
  final List<Genre> genres;
  final int? selectedGenreId;
  final List<Movie> moviesForGenre;

  GenresLoaded({
    required this.genres,
    this.selectedGenreId,
    required this.moviesForGenre,
  });

  GenresLoaded copyWith({
    List<Genre>? genres,
    int? selectedGenreId,
    List<Movie>? moviesForGenre,
  }) {
    return GenresLoaded(
      genres: genres ?? this.genres,
      selectedGenreId: selectedGenreId ?? this.selectedGenreId,
      moviesForGenre: moviesForGenre ?? this.moviesForGenre,
    );
  }
}
class GenresError extends GenresState {
  final String message;
  GenresError(this.message);
}

@injectable
class GenresCubit extends Cubit<GenresState> {
  final GetGenresUseCase _getGenres;
  final GetMoviesByGenreUseCase _getMoviesByGenre;
  
  int _page = 1;
  bool _isFetching = false;

  GenresCubit(this._getGenres, this._getMoviesByGenre) : super(GenresInitial());

  Future<void> loadGenres() async {
    emit(GenresLoading());
    final result = await _getGenres(NoParams());
    result.fold(
      (failure) => emit(GenresError(failure.message)),
      (genres) => emit(GenresLoaded(genres: genres, moviesForGenre: [])),
    );
  }

  Future<void> selectGenre(int genreId) async {
    if (state is! GenresLoaded) return;
    final currentState = state as GenresLoaded;
    
    emit(currentState.copyWith(selectedGenreId: genreId, moviesForGenre: [])); // Show loading state briefly if needed or just empty list
    
    _page = 1;
    final result = await _getMoviesByGenre(GenreMoviesParams(genreId: genreId, page: _page));
    
    result.fold(
      (failure) => emit(GenresError(failure.message)), // Or handle silently
      (movies) => emit(currentState.copyWith(selectedGenreId: genreId, moviesForGenre: movies)),
    );
  }

  Future<void> loadMoreMovies() async {
    if (_isFetching || state is! GenresLoaded) return;
    final currentState = state as GenresLoaded;
    if (currentState.selectedGenreId == null) return;

    _isFetching = true;
    _page++;
    
    final result = await _getMoviesByGenre(GenreMoviesParams(genreId: currentState.selectedGenreId!, page: _page));
    
    result.fold(
      (failure) {
        _page--;
      },
      (newMovies) {
        emit(currentState.copyWith(
          moviesForGenre: [...currentState.moviesForGenre, ...newMovies],
        ));
      }
    );
    
    _isFetching = false;
  }
}
