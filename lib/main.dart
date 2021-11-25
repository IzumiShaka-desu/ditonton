import 'package:core/core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:movie/presentation/bloc/bloc/search_movies/search_movies_bloc.dart';
import 'package:movie/presentation/bloc/cubit/detail_movies/detail_movies_cubit.dart';
import 'package:movie/presentation/bloc/cubit/movie_list/movie_list_cubit.dart';
import 'package:movie/presentation/bloc/cubit/popular_movies/popular_movies_cubit.dart';
import 'package:movie/presentation/bloc/cubit/top_rated_movies/top_rated_movies_cubit.dart';
import 'package:movie/presentation/bloc/cubit/watchlist_movies/watchlist_movies_cubit.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:tv/presentation/bloc/bloc/search_movies/search_tvs_bloc.dart';
import 'package:tv/presentation/bloc/cubit/detail_season/detail_season_cubit.dart';
import 'package:tv/presentation/bloc/cubit/detail_tv/detail_tv_cubit.dart';
import 'package:tv/presentation/bloc/cubit/popular_tvs/popular_tvs_cubit.dart';
import 'package:tv/presentation/bloc/cubit/top_rated_movies/top_rated_tvs_cubit.dart';
import 'package:tv/presentation/bloc/cubit/tv_list/tv_list_cubit.dart';
import 'package:tv/presentation/bloc/cubit/watchlist_tvs/watchlist_tvs_cubit.dart';

void main() async {
  di.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  await analytics.logAppOpen();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieListCubit>(
          create: (context) => di.locator<MovieListCubit>(),
        ),
        BlocProvider<DetailSeasonCubit>(
          create: (_) => di.locator<DetailSeasonCubit>(),
        ),
        BlocProvider<DetailMoviesCubit>(
          create: (_) => di.locator<DetailMoviesCubit>(),
        ),
        BlocProvider<SearchMoviesBloc>(
          create: (_) => di.locator<SearchMoviesBloc>(),
        ),
        BlocProvider<TopRatedMoviesCubit>(
          create: (_) => di.locator<TopRatedMoviesCubit>(),
        ),
        BlocProvider<PopularMoviesCubit>(
          create: (_) => di.locator<PopularMoviesCubit>(),
        ),
        BlocProvider<WatchlistMoviesCubit>(
          create: (_) => di.locator<WatchlistMoviesCubit>(),
        ),
        BlocProvider<TvListCubit>(
          create: (_) => di.locator<TvListCubit>(),
        ),
        BlocProvider<DetailTvCubit>(
          create: (_) => di.locator<DetailTvCubit>(),
        ),
        BlocProvider<SearchTvsBloc>(
          create: (_) => di.locator<SearchTvsBloc>(),
        ),
        BlocProvider<TopRatedTvsCubit>(
          create: (_) => di.locator<TopRatedTvsCubit>(),
        ),
        BlocProvider<PopularTvsCubit>(
          create: (_) => di.locator<PopularTvsCubit>(),
        ),
        BlocProvider<WatchlistTvsCubit>(
          create: (_) => di.locator<WatchlistTvsCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          colorScheme: kColorScheme.copyWith(
            secondary: kMikadoYellow,
          ),
        ),
        home: HomePage(),
        onGenerateRoute: Routes(),
      ),
    );
  }
}
