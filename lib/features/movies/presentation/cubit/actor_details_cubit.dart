import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/actor_details.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/actor_usecases.dart';

abstract class ActorDetailsState {}

class ActorDetailsInitial extends ActorDetailsState {}
class ActorDetailsLoading extends ActorDetailsState {}
class ActorDetailsLoaded extends ActorDetailsState {
  final ActorDetails actor;
  final List<Movie> movies;
  ActorDetailsLoaded(this.actor, this.movies);
}
class ActorDetailsError extends ActorDetailsState {
  final String message;
  ActorDetailsError(this.message);
}

@injectable
class ActorDetailsCubit extends Cubit<ActorDetailsState> {
  final GetActorDetailsUseCase _getActorDetails;
  final GetActorMoviesUseCase _getActorMovies;

  ActorDetailsCubit(this._getActorDetails, this._getActorMovies) : super(ActorDetailsInitial());

  Future<void> loadActorDetails(int actorId) async {
    emit(ActorDetailsLoading());
    
    final detailsResult = await _getActorDetails(ActorParams(actorId: actorId));
    final moviesResult = await _getActorMovies(ActorParams(actorId: actorId));

    if (detailsResult.isLeft() || moviesResult.isLeft()) {
      emit(ActorDetailsError('Aktyor məlumatları tapılmadı'));
      return;
    }

    final actor = detailsResult.getRight().toNullable()!;
    final movies = moviesResult.getRight().toNullable()!;

    emit(ActorDetailsLoaded(actor, movies));
  }
}
