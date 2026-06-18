import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/actor_details.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class ActorParams {
  final int actorId;
  ActorParams({required this.actorId});
}

@lazySingleton
class GetActorDetailsUseCase implements UseCase<ActorDetails, ActorParams> {
  final MovieRepository repository;

  GetActorDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, ActorDetails>> call(ActorParams params) {
    return repository.getActorDetails(params.actorId);
  }
}

@lazySingleton
class GetActorMoviesUseCase implements UseCase<List<Movie>, ActorParams> {
  final MovieRepository repository;

  GetActorMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(ActorParams params) {
    return repository.getActorMovies(params.actorId);
  }
}
