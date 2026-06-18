import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class PageParams {
  final int page;
  PageParams({required this.page});
}

@lazySingleton
class GetPopularMoviesUseCase implements UseCase<List<Movie>, PageParams> {
  final MovieRepository repository;

  GetPopularMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(PageParams params) {
    return repository.getPopularMovies(page: params.page);
  }
}

@lazySingleton
class GetTopRatedMoviesUseCase implements UseCase<List<Movie>, PageParams> {
  final MovieRepository repository;

  GetTopRatedMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(PageParams params) {
    return repository.getTopRatedMovies(page: params.page);
  }
}

@lazySingleton
class GetUpcomingMoviesUseCase implements UseCase<List<Movie>, PageParams> {
  final MovieRepository repository;

  GetUpcomingMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(PageParams params) {
    return repository.getUpcomingMovies(page: params.page);
  }
}

class SearchParams {
  final String query;
  SearchParams({required this.query});
}

@lazySingleton
class SearchMoviesUseCase implements UseCase<List<Movie>, SearchParams> {
  final MovieRepository repository;

  SearchMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(SearchParams params) {
    return repository.searchMovies(params.query);
  }
}

class MovieExtrasParams {
  final int movieId;
  MovieExtrasParams({required this.movieId});
}

@lazySingleton
class GetMovieExtrasUseCase implements UseCase<Map<String, dynamic>, MovieExtrasParams> {
  final MovieRepository repository;

  GetMovieExtrasUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(MovieExtrasParams params) {
    return repository.getMovieExtras(params.movieId);
  }
}
