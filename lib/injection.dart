import 'package:core/database/database_helper.dart';
import 'package:core/utils/network_info.dart';
import 'package:core/utils/secure_client.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/bloc/search_movies/search_movies_bloc.dart';
import 'package:movie/presentation/bloc/cubit/detail_movies/detail_movies_cubit.dart';
import 'package:movie/presentation/bloc/cubit/movie_list/movie_list_cubit.dart';
import 'package:movie/presentation/bloc/cubit/popular_movies/popular_movies_cubit.dart';
import 'package:movie/presentation/bloc/cubit/top_rated_movies/top_rated_movies_cubit.dart';
import 'package:movie/presentation/bloc/cubit/watchlist_movies/watchlist_movies_cubit.dart';
import 'package:tv/presentation/bloc/bloc/search_movies/search_tvs_bloc.dart';
import 'package:tv/presentation/bloc/cubit/detail_season/detail_season_cubit.dart';
import 'package:tv/presentation/bloc/cubit/detail_tv/detail_tv_cubit.dart';
import 'package:tv/presentation/bloc/cubit/popular_tvs/popular_tvs_cubit.dart';
import 'package:tv/presentation/bloc/cubit/top_rated_movies/top_rated_tvs_cubit.dart';
import 'package:tv/presentation/bloc/cubit/tv_list/tv_list_cubit.dart';
import 'package:tv/presentation/bloc/cubit/watchlist_tvs/watchlist_tvs_cubit.dart';
import 'package:tv/tv.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory<MovieListCubit>(
    () => MovieListCubit(
      getNowPlayingMovies: locator<GetNowPlayingMovies>(),
      getPopularMovies: locator<GetPopularMovies>(),
      getTopRatedMovies: locator<GetTopRatedMovies>(),
    ),
  );
  locator.registerFactory(
    () => DetailMoviesCubit(
      getMovieDetail: locator<GetMovieDetail>(),
      getMovieRecommendations: locator<GetMovieRecommendations>(),
      getWatchListStatus: locator<GetWatchListStatus>(),
      saveWatchlist: locator<SaveWatchlist>(),
      removeWatchlist: locator<RemoveWatchlist>(),
    ),
  );
  locator.registerFactory(
    () => SearchMoviesBloc(
      locator<SearchMovies>(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesCubit(
      getPopularMovies: locator<GetPopularMovies>(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesCubit(
      getTopRatedMovies: locator<GetTopRatedMovies>(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMoviesCubit(
      getWatchlistMovies: locator<GetWatchlistMovies>(),
    ),
  );
  locator.registerFactory(
    () => TvListCubit(
      getNowPlayingTvs: locator<GetNowPlayingTvs>(),
      getPopularTvs: locator<GetPopularTvs>(),
      getTopRatedTvs: locator<GetTopRatedTvs>(),
    ),
  );
  locator.registerFactory(
    () => DetailTvCubit(
      getTvDetail: locator<GetTvDetail>(),
      getTvRecommendations: locator<GetTvRecommendations>(),
      getWatchListStatus: locator<GetTvWatchListStatus>(),
      saveWatchlist: locator<SaveTvWatchlist>(),
      removeWatchlist: locator<RemoveTvWatchlist>(),
    ),
  );
  locator.registerFactory(
    () => SearchTvsBloc(
      locator<SearchTvs>(),
    ),
  );
  locator.registerFactory(
    () => DetailSeasonCubit(
      getDetailSeason: locator<GetSeasonDetail>(),
    ),
  );
  locator.registerFactory(
    () => PopularTvsCubit(
      getPopularTvs: locator<GetPopularTvs>(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvsCubit(
      getTopRatedTvs: locator<GetTopRatedTvs>(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTvsCubit(
      getWatchlistTvs: locator<GetWatchlistTvs>(),
    ),
  );

  // use case
  //movie
  locator.registerLazySingleton(
    () => GetNowPlayingMovies(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetPopularMovies(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTopRatedMovies(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetMovieDetail(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetMovieRecommendations(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SearchMovies(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetWatchListStatus(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SaveWatchlist(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => RemoveWatchlist(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetWatchlistMovies(
      locator(),
    ),
  );
  //tv
  locator.registerLazySingleton(
    () => GetNowPlayingTvs(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetPopularTvs(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTopRatedTvs(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTvDetail(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTvRecommendations(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SearchTvs(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTvWatchListStatus(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SaveTvWatchlist(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => RemoveTvWatchlist(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetWatchlistTvs(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetSeasonDetail(
      locator(),
    ),
  );

  // repository
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      localDataSource: locator(),
      remoteDataSource: locator(),
      networkInfo: locator(),
    ),
  );
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );
  // network info
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      locator(),
    ),
  );
  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(
      client: locator(),
    ),
  );

  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(
      databaseHelper: locator(),
    ),
  );

  locator.registerLazySingleton<TvRemoteDataSource>(
    () => TvRemoteDataSourceImpl(
      client: locator(),
    ),
  );
  locator.registerLazySingleton<TvLocalDataSource>(
    () => TvLocalDataSourceImpl(
      databaseHelper: locator(),
    ),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper(),
  );

  // external
  locator.registerSingletonAsync<http.Client>(
    () => SecureClient.getSecureClient(),
  );
  locator.registerLazySingleton(
    () => DataConnectionChecker(),
  );
}
