import '../../domain/entities/movie.dart';

abstract class MoviesState {}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;
  final bool hasReachedMax; 
  final bool isLoadMore;    

  MoviesLoaded({
    required this.movies,
    this.hasReachedMax = false,
    this.isLoadMore = false,
  });

  MoviesLoaded copyWith({
    List<Movie>? movies,
    bool? hasReachedMax,
    bool? isLoadMore,
  }) {
    return MoviesLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadMore: isLoadMore ?? this.isLoadMore,
    );
  }
}

class MoviesError extends MoviesState {
  final String message;
  MoviesError(this.message);
}