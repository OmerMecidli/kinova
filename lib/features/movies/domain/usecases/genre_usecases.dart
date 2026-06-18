import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/genre.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

@lazySingleton
class GetGenresUseCase implements UseCase<List<Genre>, NoParams> {
  final MovieRepository repository;

  GetGenresUseCase(this.repository);

  @override
  Future<Either<Failure, List<Genre>>> call(NoParams params) {
    return repository.getGenres();
  }
}

class GenreMoviesParams {
  final int genreId;
  final int page;
  GenreMoviesParams({required this.genreId, required this.page});
}

@lazySingleton
class GetMoviesByGenreUseCase implements UseCase<List<Movie>, GenreMoviesParams> {
  final MovieRepository repository;

  GetMoviesByGenreUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(GenreMoviesParams params) {
    return repository.getMoviesByGenre(params.genreId, page: params.page);
  }
}
