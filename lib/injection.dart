import 'package:core/database/database_helper.dart';
import 'package:core/utils/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TvListNotifier(
      getNowPlayingTvs: locator(),
      getPopularTvs: locator(),
      getTopRatedTvs: locator(),
    ),
  );
  locator.registerFactory(
    () => TvDetailNotifier(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSearchNotifier(
      searchTvs: locator(),
    ),
  );
  locator.registerFactory(
    () => SeasonDetailNotifier(
      getSeasonDetail: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvsNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvsNotifier(
      getTopRatedTvs: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTvNotifier(
      getWatchlistTvs: locator(),
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
  locator.registerLazySingleton(
    () => http.Client(),
  );
  locator.registerLazySingleton(
    () => DataConnectionChecker(),
  );
}
