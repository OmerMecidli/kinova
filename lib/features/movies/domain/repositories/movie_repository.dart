import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/movie.dart';
import '../entities/genre.dart';
import '../entities/actor_details.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> getTopRatedMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> getUpcomingMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
  Future<Either<Failure, Map<String, dynamic>>> getMovieExtras(int movieId);
  
  // New methods
  Future<Either<Failure, List<Genre>>> getGenres();
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(int genreId, {int page = 1});
  Future<Either<Failure, List<Movie>>> getSimilarMovies(int movieId);
  Future<Either<Failure, ActorDetails>> getActorDetails(int actorId);
  Future<Either<Failure, List<Movie>>> getActorMovies(int actorId);
}
