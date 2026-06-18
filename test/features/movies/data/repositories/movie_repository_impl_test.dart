import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:kinova/core/network/dio_client.dart';
import 'package:kinova/features/movies/data/repositories/movie_repository_impl.dart';

class MockDioClient extends Mock implements DioClient {}
class MockDio extends Mock implements Dio {}

void main() {
  late MovieRepositoryImpl repository;
  late MockDioClient mockDioClient;
  late MockDio mockDio;

  setUp(() {
    mockDioClient = MockDioClient();
    mockDio = MockDio();
    when(() => mockDioClient.dio).thenReturn(mockDio);
    repository = MovieRepositoryImpl(mockDioClient);
  });

  group('getPopularMovies', () {
    test('should return Right(List<Movie>) when the call to remote data source is successful', () async {
      // arrange
      final tResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: {
          'results': [
            {
              'id': 1,
              'title': 'Test Movie',
              'overview': 'Overview',
              'poster_path': '/path.jpg',
              'vote_average': 8.5,
              'release_date': '2023-01-01'
            }
          ]
        },
        statusCode: 200,
      );
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => tResponse);

      // act
      final result = await repository.getPopularMovies(page: 1);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not be left'),
        (r) => expect(r.first.title, 'Test Movie'),
      );
    });

    test('should return Left(ServerFailure) when the call to remote data source is unsuccessful', () async {
      // arrange
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      // act
      final result = await repository.getPopularMovies(page: 1);

      // assert
      expect(result.isLeft(), true);
    });
  });
}
