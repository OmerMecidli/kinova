import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> getTopRatedMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> getUpcomingMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
  Future<Either<Failure, Map<String, dynamic>>> getMovieExtras(int movieId);
}
