import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kinova/core/theme/app_theme.dart';
import 'package:kinova/features/favorites/data/repositories/favorite_repository.dart';
import 'package:kinova/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:kinova/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:kinova/features/search/presentation/cubit/search_cubit.dart';

import 'core/network/dio_client.dart';
import 'core/routing/app_router.dart';
import 'features/movies/presentation/cubit/movies_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DioClient>(create: (_) => DioClient()),
        RepositoryProvider<MovieRepositoryImpl>(
          create: (context) => MovieRepositoryImpl(context.read<DioClient>()),
        ),
        // 1. FavoriteRepository-ni bura əlavə edirik
        RepositoryProvider<FavoriteRepository>(create: (_) => FavoriteRepository()), 
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MoviesCubit>(
            create: (context) => MoviesCubit(context.read<MovieRepositoryImpl>())..loadAllMovies(),
          ),
          // 2. FavoritesCubit-i bura əlavə edirik
          BlocProvider<FavoritesCubit>(
            create: (context) => FavoritesCubit(context.read<FavoriteRepository>()),
          ),
          BlocProvider<SearchCubit>(
            create: (context) => SearchCubit(context.read<MovieRepositoryImpl>()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Movie Discovery',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}