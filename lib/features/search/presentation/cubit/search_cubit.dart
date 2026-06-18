import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:get_storage/get_storage.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/domain/usecases/movie_usecases.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {
  final List<String> history;
  SearchInitial(this.history);
}

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
  final _storage = GetStorage();
  static const _historyKey = 'search_history';
  Timer? _debounce;

  SearchCubit(this._searchMovies) : super(SearchInitial([])) {
    _emitInitialState();
  }

  void _emitInitialState() {
    final List<dynamic> savedHistory = _storage.read(_historyKey) ?? [];
    emit(SearchInitial(savedHistory.cast<String>()));
  }

  void searchMovies(String query) {
    if (query.trim().isEmpty) {
      _emitInitialState();
      return;
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(SearchLoading());
      _saveToHistory(query.trim());
      
      final result = await _searchMovies(SearchParams(query: query));
      
      result.fold(
        (failure) => emit(SearchError(failure.message)),
        (movies) => emit(SearchLoaded(movies)),
      );
    });
  }

  void _saveToHistory(String query) {
    List<dynamic> savedHistory = _storage.read(_historyKey) ?? [];
    List<String> history = savedHistory.cast<String>();
    
    // Yalnız fərqli və uzunluğu 2-dən böyük olan sözləri əlavə edirik
    if (query.length > 2) {
      history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
      history.insert(0, query); // Ən yenisi əvvələ
      if (history.length > 10) history = history.sublist(0, 10); // Maksimum 10 dənə saxlamaq
      _storage.write(_historyKey, history);
    }
  }

  void clearHistory() {
    _storage.remove(_historyKey);
    _emitInitialState();
  }

  void removeHistoryItem(String query) {
    List<dynamic> savedHistory = _storage.read(_historyKey) ?? [];
    List<String> history = savedHistory.cast<String>();
    history.removeWhere((item) => item == query);
    _storage.write(_historyKey, history);
    if (state is SearchInitial) {
      _emitInitialState();
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}