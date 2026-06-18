import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/movie_usecases.dart';

// --- State Sinfi ---
abstract class MoviesState {}

class MoviesInitial extends MoviesState {}
class MoviesLoading extends MoviesState {}
class MoviesError extends MoviesState {
  final String message;
  MoviesError(this.message);
}
class MoviesLoaded extends MoviesState {
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> upcomingMovies;

  MoviesLoaded({
    required this.popularMovies,
    required this.topRatedMovies,
    required this.upcomingMovies,
  });
}

// --- Cubit Sinfi ---
@injectable
class MoviesCubit extends Cubit<MoviesState> {
  final GetPopularMoviesUseCase _getPopular;
  final GetTopRatedMoviesUseCase _getTopRated;
  final GetUpcomingMoviesUseCase _getUpcoming;

  int _popularPage = 1;
  int _topRatedPage = 1;
  int _upcomingPage = 1;

  bool _isFetchingPopular = false;
  bool _isFetchingTopRated = false;
  bool _isFetchingUpcoming = false;

  MoviesCubit(this._getPopular, this._getTopRated, this._getUpcoming) : super(MoviesInitial());

  Future<void> loadAllMovies() async {
    emit(MoviesLoading());
    try {
      _popularPage = 1;
      _topRatedPage = 1;
      _upcomingPage = 1;

      final popularResult = await _getPopular(PageParams(page: _popularPage));
      final topRatedResult = await _getTopRated(PageParams(page: _topRatedPage));
      final upcomingResult = await _getUpcoming(PageParams(page: _upcomingPage));

      // Check if any failed
      if (popularResult.isLeft() || topRatedResult.isLeft() || upcomingResult.isLeft()) {
        emit(MoviesError('Filmləri yükləmək mümkün olmadı'));
        return;
      }

      final popularMovies = popularResult.getRight().toNullable() ?? [];
      final topRatedMovies = topRatedResult.getRight().toNullable() ?? [];
      final upcomingMovies = upcomingResult.getRight().toNullable() ?? [];

      emit(MoviesLoaded(
        popularMovies: popularMovies,
        topRatedMovies: topRatedMovies,
        upcomingMovies: upcomingMovies,
      ));
    } catch (e) {
      emit(MoviesError('Gözlənilməz xəta: ${e.toString()}'));
    }
  }

  Future<void> loadMorePopular() async {
    if (_isFetchingPopular || state is! MoviesLoaded) return;
    
    _isFetchingPopular = true;
    _popularPage++;
    
    final result = await _getPopular(PageParams(page: _popularPage));
    
    result.fold(
      (failure) {
        _popularPage--;
      },
      (newMovies) {
        final currentState = state as MoviesLoaded;
        emit(MoviesLoaded(
          popularMovies: [...currentState.popularMovies, ...newMovies],
          topRatedMovies: currentState.topRatedMovies,
          upcomingMovies: currentState.upcomingMovies,
        ));
      }
    );
    
    _isFetchingPopular = false;
  }

  Future<void> loadMoreTopRated() async {
    if (_isFetchingTopRated || state is! MoviesLoaded) return;
    
    _isFetchingTopRated = true;
    _topRatedPage++;
    
    final result = await _getTopRated(PageParams(page: _topRatedPage));
    
    result.fold(
      (failure) {
        _topRatedPage--;
      },
      (newMovies) {
        final currentState = state as MoviesLoaded;
        emit(MoviesLoaded(
          popularMovies: currentState.popularMovies,
          topRatedMovies: [...currentState.topRatedMovies, ...newMovies],
          upcomingMovies: currentState.upcomingMovies,
        ));
      }
    );
    
    _isFetchingTopRated = false;
  }

  Future<void> loadMoreUpcoming() async {
    if (_isFetchingUpcoming || state is! MoviesLoaded) return;
    
    _isFetchingUpcoming = true;
    _upcomingPage++;
    
    final result = await _getUpcoming(PageParams(page: _upcomingPage));
    
    result.fold(
      (failure) {
        _upcomingPage--;
      },
      (newMovies) {
        final currentState = state as MoviesLoaded;
        emit(MoviesLoaded(
          popularMovies: currentState.popularMovies,
          topRatedMovies: currentState.topRatedMovies,
          upcomingMovies: [...currentState.upcomingMovies, ...newMovies],
        ));
      }
    );
    
    _isFetchingUpcoming = false;
  }
}