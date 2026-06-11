import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/movie_repository_impl.dart';

abstract class MovieExtrasState {}

class ExtrasInitial extends MovieExtrasState {}
class ExtrasLoading extends MovieExtrasState {}
class ExtrasLoaded extends MovieExtrasState {
  final String? trailerKey;
  final List<dynamic> cast;
  ExtrasLoaded(this.trailerKey, this.cast);
}

class MovieExtrasCubit extends Cubit<MovieExtrasState> {
  final MovieRepositoryImpl _repository;

  MovieExtrasCubit(this._repository) : super(ExtrasInitial());

  Future<void> loadExtras(int movieId) async {
    emit(ExtrasLoading());
    try {
      final extras = await _repository.getMovieExtras(movieId);
      emit(ExtrasLoaded(extras['trailerKey'], extras['cast']));
    } catch (e) {
      emit(ExtrasInitial()); // Xəta olsa da səhifə çökməsin deyə initiala qaytarırıq
    }
  }
}