import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../movies/domain/entities/movie.dart';
import '../repositories/favorite_repository.dart';

@lazySingleton
class GetFavoritesUseCase {
  final FavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  Either<Failure, List<Movie>> call(NoParams params) {
    return repository.getFavorites();
  }
}

class ToggleFavoriteParams {
  final Movie movie;
  ToggleFavoriteParams({required this.movie});
}

@lazySingleton
class ToggleFavoriteUseCase implements UseCase<void, ToggleFavoriteParams> {
  final FavoriteRepository repository;

  ToggleFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleFavoriteParams params) {
    return repository.toggleFavorite(params.movie);
  }
}
