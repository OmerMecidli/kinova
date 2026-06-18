import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:kinova/features/movies/data/models/movie_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/error_handler.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';

@LazySingleton(as: MovieRepository)
class MovieRepositoryImpl implements MovieRepository {
  final DioClient _dioClient;

  MovieRepositoryImpl(this._dioClient);

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dioClient.dio.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );
      final List<dynamic> results = response.data['results'];
      final movies = results.map((json) => MovieModel.fromJson(json)).toList();
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure(ErrorHandler.handle(e)));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final response = await _dioClient.dio.get(
        '/search/movie',
        queryParameters: {'query': query},
      );
      final results = response.data['results'] as List;
      final movies = results.map((json) => MovieModel.fromJson(json)).toList();
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure('Axtarış zamanı xəta baş verdi'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _dioClient.dio.get(
        '/movie/top_rated',
        queryParameters: {'page': page}, 
      );
      final results = response.data['results'] as List;
      final movies = results.map((json) => MovieModel.fromJson(json)).toList();
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure('Top Rated filmlər yüklənərkən xəta baş verdi'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _dioClient.dio.get(
        '/movie/upcoming',
        queryParameters: {'page': page}, 
      );
      final results = response.data['results'] as List;
      final movies = results.map((json) => MovieModel.fromJson(json)).toList();
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure('Upcoming filmlər yüklənərkən xəta baş verdi'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMovieExtras(int movieId) async {
    try {
      final response = await _dioClient.dio.get(
        '/movie/$movieId',
        queryParameters: {'append_to_response': 'credits,videos'},
      );

      final data = response.data;
      final videos = data['videos']['results'] as List;
      final trailer = videos.firstWhere(
        (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube', 
        orElse: () => null,
      );

      final cast = data['credits']['cast'] as List;

      return Right({
        'trailerKey': trailer?['key'],
        'cast': cast.take(10).toList(),
      });
    } catch (e) {
      return Left(ServerFailure('Əlavə məlumatlar yüklənmədi'));
    }
  }
}