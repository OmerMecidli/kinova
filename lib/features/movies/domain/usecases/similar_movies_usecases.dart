import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class MovieIdParams {
  final int movieId;
  MovieIdParams({required this.movieId});
}

@lazySingleton
class GetSimilarMoviesUseCase implements UseCase<List<Movie>, MovieIdParams> {
  final MovieRepository repository;

  GetSimilarMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(MovieIdParams params) {
    return repository.getSimilarMovies(params.movieId);
  }
}
