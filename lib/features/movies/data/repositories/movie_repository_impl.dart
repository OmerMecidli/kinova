import 'package:kinova/features/movies/data/models/movie_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/entities/movie.dart';
import 'movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final DioClient _dioClient;

  MovieRepositoryImpl(this._dioClient);

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dioClient.dio.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );
      final List<dynamic> results = response.data['results'];
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception(ErrorHandler.handle(e));
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await _dioClient.dio.get(
        '/search/movie',
        queryParameters: {'query': query},
      );
      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Axtarış zamanı xəta baş verdi');
    }
  }

  // YENİLİK: page parametri əlavə edildi
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _dioClient.dio.get(
        '/movie/top_rated',
        queryParameters: {'page': page}, 
      );
      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Top Rated filmlər yüklənərkən xəta baş verdi');
    }
  }

  // YENİLİK: page parametri əlavə edildi
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _dioClient.dio.get(
        '/movie/upcoming',
        queryParameters: {'page': page}, 
      );
      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Upcoming filmlər yüklənərkən xəta baş verdi');
    }
  }

  Future<Map<String, dynamic>> getMovieExtras(int movieId) async {
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

      return {
        'trailerKey': trailer?['key'],
        'cast': cast.take(10).toList(),
      };
    } catch (e) {
      throw Exception('Əlavə məlumatlar yüklənmədi');
    }
  }
}