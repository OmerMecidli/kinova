import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kinova/core/error/failure.dart';
import 'package:kinova/features/movies/domain/entities/movie.dart';
import 'package:kinova/features/movies/domain/usecases/movie_usecases.dart';
import 'package:kinova/features/movies/presentation/cubit/movies_cubit.dart';

class MockGetPopularMoviesUseCase extends Mock implements GetPopularMoviesUseCase {}
class MockGetTopRatedMoviesUseCase extends Mock implements GetTopRatedMoviesUseCase {}
class MockGetUpcomingMoviesUseCase extends Mock implements GetUpcomingMoviesUseCase {}

class FakePageParams extends Fake implements PageParams {}

void main() {
  late MoviesCubit cubit;
  late MockGetPopularMoviesUseCase mockGetPopular;
  late MockGetTopRatedMoviesUseCase mockGetTopRated;
  late MockGetUpcomingMoviesUseCase mockGetUpcoming;

  setUpAll(() {
    registerFallbackValue(FakePageParams());
  });

  setUp(() {
    mockGetPopular = MockGetPopularMoviesUseCase();
    mockGetTopRated = MockGetTopRatedMoviesUseCase();
    mockGetUpcoming = MockGetUpcomingMoviesUseCase();
    cubit = MoviesCubit(mockGetPopular, mockGetTopRated, mockGetUpcoming);
  });

  tearDown(() {
    cubit.close();
  });

  final List<Movie> tMoviesList = [
    Movie(id: 1, title: 'Test', overview: 'Desc', posterPath: '', voteAverage: 8.0, releaseDate: '2023-01-01')
  ];

  group('loadAllMovies', () {
    blocTest<MoviesCubit, MoviesState>(
      'should emit [MoviesLoading, MoviesLoaded] when data is gotten successfully',
      build: () {
        when(() => mockGetPopular(any())).thenAnswer((_) async => Right(tMoviesList));
        when(() => mockGetTopRated(any())).thenAnswer((_) async => Right(tMoviesList));
        when(() => mockGetUpcoming(any())).thenAnswer((_) async => Right(tMoviesList));
        return cubit;
      },
      act: (cubit) => cubit.loadAllMovies(),
      expect: () => [
        isA<MoviesLoading>(),
        isA<MoviesLoaded>(),
      ],
    );

    blocTest<MoviesCubit, MoviesState>(
      'should emit [MoviesLoading, MoviesError] when getting data fails',
      build: () {
        when(() => mockGetPopular(any())).thenAnswer((_) async => const Left(ServerFailure('Error')));
        when(() => mockGetTopRated(any())).thenAnswer((_) async => Right(tMoviesList));
        when(() => mockGetUpcoming(any())).thenAnswer((_) async => Right(tMoviesList));
        return cubit;
      },
      act: (cubit) => cubit.loadAllMovies(),
      expect: () => [
        isA<MoviesLoading>(),
        isA<MoviesError>(),
      ],
    );
  });
}
