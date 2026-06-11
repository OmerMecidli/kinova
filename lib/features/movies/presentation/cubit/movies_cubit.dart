import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../../data/repositories/movie_repository_impl.dart';

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
class MoviesCubit extends Cubit<MoviesState> {
  final MovieRepositoryImpl _repository;

  // YENİLİK: Pagination üçün səhifə nömrələri və yüklənmə statusları
  int _popularPage = 1;
  int _topRatedPage = 1;
  int _upcomingPage = 1;

  bool _isFetchingPopular = false;
  bool _isFetchingTopRated = false;
  bool _isFetchingUpcoming = false;

  MoviesCubit(this._repository) : super(MoviesInitial());

  Future<void> loadAllMovies() async {
    emit(MoviesLoading());
    try {
      // Səhifələri sıfırlayırıq ki, yenilənəndə 1-dən başlasın
      _popularPage = 1;
      _topRatedPage = 1;
      _upcomingPage = 1;

      final results = await Future.wait([
        _repository.getPopularMovies(page: _popularPage),
        _repository.getTopRatedMovies(page: _topRatedPage),
        _repository.getUpcomingMovies(page: _upcomingPage),
      ]);

      emit(MoviesLoaded(
        popularMovies: results[0],
        topRatedMovies: results[1],
        upcomingMovies: results[2],
      ));
    } catch (e) {
      emit(MoviesError('Filmləri yükləmək mümkün olmadı: ${e.toString()}'));
    }
  }

  // YENİLİK: Popular üçün pagination
  Future<void> loadMorePopular() async {
    if (_isFetchingPopular || state is! MoviesLoaded) return;
    
    _isFetchingPopular = true;
    _popularPage++;
    
    try {
      final newMovies = await _repository.getPopularMovies(page: _popularPage);
      final currentState = state as MoviesLoaded;
      
      emit(MoviesLoaded(
        popularMovies: [...currentState.popularMovies, ...newMovies], // Köhnə + Yeni
        topRatedMovies: currentState.topRatedMovies,
        upcomingMovies: currentState.upcomingMovies,
      ));
    } catch (e) {
      _popularPage--; // Xəta olsa səhifəni geri qaytarırıq
    } finally {
      _isFetchingPopular = false;
    }
  }

  // YENİLİK: Top Rated üçün pagination
  Future<void> loadMoreTopRated() async {
    if (_isFetchingTopRated || state is! MoviesLoaded) return;
    
    _isFetchingTopRated = true;
    _topRatedPage++;
    
    try {
      final newMovies = await _repository.getTopRatedMovies(page: _topRatedPage);
      final currentState = state as MoviesLoaded;
      
      emit(MoviesLoaded(
        popularMovies: currentState.popularMovies,
        topRatedMovies: [...currentState.topRatedMovies, ...newMovies], // Köhnə + Yeni
        upcomingMovies: currentState.upcomingMovies,
      ));
    } catch (e) {
      _topRatedPage--;
    } finally {
      _isFetchingTopRated = false;
    }
  }

  // YENİLİK: Upcoming üçün pagination
  Future<void> loadMoreUpcoming() async {
    if (_isFetchingUpcoming || state is! MoviesLoaded) return;
    
    _isFetchingUpcoming = true;
    _upcomingPage++;
    
    try {
      final newMovies = await _repository.getUpcomingMovies(page: _upcomingPage);
      final currentState = state as MoviesLoaded;
      
      emit(MoviesLoaded(
        popularMovies: currentState.popularMovies,
        topRatedMovies: currentState.topRatedMovies,
        upcomingMovies: [...currentState.upcomingMovies, ...newMovies], // Köhnə + Yeni
      ));
    } catch (e) {
      _upcomingPage--;
    } finally {
      _isFetchingUpcoming = false;
    }
  }
}