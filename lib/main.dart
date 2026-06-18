import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kinova/core/theme/app_theme.dart';
import 'package:kinova/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:kinova/features/search/presentation/cubit/search_cubit.dart';

import 'core/di/injection.dart';
import 'core/routing/app_router.dart';
import 'features/movies/presentation/cubit/movies_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviesCubit>(
          create: (_) => getIt<MoviesCubit>()..loadAllMovies(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (_) => getIt<FavoritesCubit>(),
        ),
        BlocProvider<SearchCubit>(
          create: (_) => getIt<SearchCubit>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Movie Discovery',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('az'),
        ],
      ),
    );
  }
}