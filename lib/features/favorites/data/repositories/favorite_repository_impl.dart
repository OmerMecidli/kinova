import 'package:fpdart/fpdart.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../domain/repositories/favorite_repository.dart';

@LazySingleton(as: FavoriteRepository)
class FavoriteRepositoryImpl implements FavoriteRepository {
  final _box = GetStorage();
  final String _key = 'favorite_movies';

  @override
  Either<Failure, List<Movie>> getFavorites() {
    try {
      final List<dynamic> data = _box.read(_key) ?? [];
      final movies = data.map((json) => MovieModel.fromJson(json)).toList();
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure('Seçilmişlər yüklənərkən xəta baş verdi'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(Movie movie) async {
    try {
      final eitherFavorites = getFavorites();
      
      final favorites = eitherFavorites.fold(
        (failure) => <Movie>[],
        (movies) => movies,
      );

      final isExist = favorites.any((m) => m.id == movie.id);

      if (isExist) {
        favorites.removeWhere((m) => m.id == movie.id);
      } else {
        favorites.add(movie);
      }

      final List<Map<String, dynamic>> jsonData = favorites.map((m) {
        return MovieModel(
          id: m.id,
          title: m.title,
          overview: m.overview,
          posterPath: m.posterPath,
          voteAverage: m.voteAverage,
          releaseDate: m.releaseDate,
        ).toJson();
      }).toList();

      await _box.write(_key, jsonData);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Seçilmişlərə əlavə edərkən xəta baş verdi'));
    }
  }
}
