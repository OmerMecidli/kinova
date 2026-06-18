import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/similar_movies_usecases.dart';

abstract class SimilarMoviesState {}

class SimilarMoviesInitial extends SimilarMoviesState {}
class SimilarMoviesLoading extends SimilarMoviesState {}
class SimilarMoviesLoaded extends SimilarMoviesState {
  final List<Movie> movies;
  SimilarMoviesLoaded(this.movies);
}
class SimilarMoviesError extends SimilarMoviesState {
  final String message;
  SimilarMoviesError(this.message);
}

@injectable
class SimilarMoviesCubit extends Cubit<SimilarMoviesState> {
  final GetSimilarMoviesUseCase _getSimilarMovies;

  SimilarMoviesCubit(this._getSimilarMovies) : super(SimilarMoviesInitial());

  Future<void> loadSimilarMovies(int movieId) async {
    emit(SimilarMoviesLoading());
    final result = await _getSimilarMovies(MovieIdParams(movieId: movieId));
    result.fold(
      (failure) => emit(SimilarMoviesError(failure.message)),
      (movies) => emit(SimilarMoviesLoaded(movies)),
    );
  }
}
