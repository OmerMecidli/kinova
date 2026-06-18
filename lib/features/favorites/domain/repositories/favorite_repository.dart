import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../movies/domain/entities/movie.dart';

abstract class FavoriteRepository {
  Either<Failure, List<Movie>> getFavorites();
  Future<Either<Failure, void>> toggleFavorite(Movie movie);
}
