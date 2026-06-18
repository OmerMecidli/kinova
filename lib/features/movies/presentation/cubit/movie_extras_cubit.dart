import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/movie_repository.dart';

abstract class MovieExtrasState {}

class ExtrasInitial extends MovieExtrasState {}
class ExtrasLoading extends MovieExtrasState {}
class ExtrasLoaded extends MovieExtrasState {
  final String? trailerKey;
  final List<dynamic> cast;
  ExtrasLoaded(this.trailerKey, this.cast);
}

@injectable
class MovieExtrasCubit extends Cubit<MovieExtrasState> {
  final MovieRepository _repository;

  MovieExtrasCubit(this._repository) : super(ExtrasInitial());

  Future<void> loadExtras(int movieId) async {
    emit(ExtrasLoading());
    try {
      final extrasResult = await _repository.getMovieExtras(movieId);
      extrasResult.fold(
        (_) => emit(ExtrasInitial()),
        (extras) => emit(ExtrasLoaded(extras['trailerKey'], extras['cast'])),
      );
    } catch (e) {
      emit(ExtrasInitial()); // Xəta olsa da səhifə çökməsin deyə initiala qaytarırıq
    }
  }
}