import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/domain/usecases/movie_usecases.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchLoaded extends SearchState {
  final List<Movie> movies;
  SearchLoaded(this.movies);
}
class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

@injectable
class SearchCubit extends Cubit<SearchState> {
  final SearchMoviesUseCase _searchMovies;
  Timer? _debounce;

  SearchCubit(this._searchMovies) : super(SearchInitial());

  void searchMovies(String query) {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(SearchLoading());
      final result = await _searchMovies(SearchParams(query: query));
      
      result.fold(
        (failure) => emit(SearchError(failure.message)),
        (movies) => emit(SearchLoaded(movies)),
      );
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}