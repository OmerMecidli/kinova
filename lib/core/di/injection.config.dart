// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/favorites/data/repositories/favorite_repository_impl.dart'
    as _i238;
import '../../features/favorites/domain/repositories/favorite_repository.dart'
    as _i316;
import '../../features/favorites/domain/usecases/favorite_usecases.dart'
    as _i841;
import '../../features/favorites/presentation/cubit/favorites_cubit.dart'
    as _i36;
import '../../features/movies/data/repositories/movie_repository_impl.dart'
    as _i652;
import '../../features/movies/domain/repositories/movie_repository.dart'
    as _i465;
import '../../features/movies/domain/usecases/actor_usecases.dart' as _i626;
import '../../features/movies/domain/usecases/genre_usecases.dart' as _i109;
import '../../features/movies/domain/usecases/movie_usecases.dart' as _i628;
import '../../features/movies/domain/usecases/similar_movies_usecases.dart'
    as _i243;
import '../../features/movies/presentation/cubit/actor_details_cubit.dart'
    as _i626;
import '../../features/movies/presentation/cubit/genres_cubit.dart' as _i808;
import '../../features/movies/presentation/cubit/movie_extras_cubit.dart'
    as _i924;
import '../../features/movies/presentation/cubit/movies_cubit.dart' as _i957;
import '../../features/movies/presentation/cubit/ratings_cubit.dart' as _i157;
import '../../features/movies/presentation/cubit/similar_movies_cubit.dart'
    as _i512;
import '../../features/search/presentation/cubit/search_cubit.dart' as _i341;
import '../network/dio_client.dart' as _i667;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i157.RatingsCubit>(() => _i157.RatingsCubit());
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient());
    gh.lazySingleton<_i316.FavoriteRepository>(
      () => _i238.FavoriteRepositoryImpl(),
    );
    gh.lazySingleton<_i465.MovieRepository>(
      () => _i652.MovieRepositoryImpl(gh<_i667.DioClient>()),
    );
    gh.factory<_i924.MovieExtrasCubit>(
      () => _i924.MovieExtrasCubit(gh<_i465.MovieRepository>()),
    );
    gh.lazySingleton<_i626.GetActorDetailsUseCase>(
      () => _i626.GetActorDetailsUseCase(gh<_i465.MovieRepository>()),
    );
    gh.lazySingleton<_i626.GetActorMoviesUseCase>(
      () => _i626.GetActorMoviesUseCase(gh<_i465.MovieRepository>()),
    );
    gh.lazySingleton<_i109.GetGenresUseCase>(
      () => _i109.GetGenresUseCase(gh<_i465.MovieRepository>()),
    );
    gh.lazySingleton<_i109.GetMoviesByGenreUseCase>(
      () => _i109.GetMoviesByGenreUseCase(gh<_i465.MovieRepository>()),
    );
    gh.lazySingleton<_i628.GetPopularMoviesUseCase>(
      () => _i628.GetPopularMoviesUseCase(gh<_i465.MovieRepository>()),
    );
    gh.lazySingleton<_i628.GetTopRatedMoviesUseCase>(
      () => _i628.GetTopRatedMoviesUseCase(gh<_i465.MovieRepository>()),
    );
    gh.lazySingleton<_i628.GetUpcomingMoviesUseCase>(
      () => _i628.GetUpcomingMoviesUseCase(gh<_i465.MovieRepository>()),
    );
    gh.lazySingleton<_i628.SearchMoviesUseCase>(
      () => _i628.SearchMoviesUseCase(gh<_i465.MovieRepository>()),
    );
    gh.lazySingleton<_i628.GetMovieExtrasUseCase>(
      () => _i628.GetMovieExtrasUseCase(gh<_i465.MovieRepository>()),
    );
    gh.lazySingleton<_i243.GetSimilarMoviesUseCase>(
      () => _i243.GetSimilarMoviesUseCase(gh<_i465.MovieRepository>()),
    );
    gh.lazySingleton<_i841.GetFavoritesUseCase>(
      () => _i841.GetFavoritesUseCase(gh<_i316.FavoriteRepository>()),
    );
    gh.lazySingleton<_i841.ToggleFavoriteUseCase>(
      () => _i841.ToggleFavoriteUseCase(gh<_i316.FavoriteRepository>()),
    );
    gh.factory<_i957.MoviesCubit>(
      () => _i957.MoviesCubit(
        gh<_i628.GetPopularMoviesUseCase>(),
        gh<_i628.GetTopRatedMoviesUseCase>(),
        gh<_i628.GetUpcomingMoviesUseCase>(),
      ),
    );
    gh.factory<_i512.SimilarMoviesCubit>(
      () => _i512.SimilarMoviesCubit(gh<_i243.GetSimilarMoviesUseCase>()),
    );
    gh.factory<_i36.FavoritesCubit>(
      () => _i36.FavoritesCubit(
        gh<_i841.GetFavoritesUseCase>(),
        gh<_i841.ToggleFavoriteUseCase>(),
      ),
    );
    gh.factory<_i341.SearchCubit>(
      () => _i341.SearchCubit(gh<_i628.SearchMoviesUseCase>()),
    );
    gh.factory<_i626.ActorDetailsCubit>(
      () => _i626.ActorDetailsCubit(
        gh<_i626.GetActorDetailsUseCase>(),
        gh<_i626.GetActorMoviesUseCase>(),
      ),
    );
    gh.factory<_i808.GenresCubit>(
      () => _i808.GenresCubit(
        gh<_i109.GetGenresUseCase>(),
        gh<_i109.GetMoviesByGenreUseCase>(),
      ),
    );
    return this;
  }
}
