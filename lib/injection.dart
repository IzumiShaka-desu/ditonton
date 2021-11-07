import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/domain/usecases/tv/get_season_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_status.dart';
import 'package:ditonton/presentation/provider/movie/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/movie/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/movie/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/movie/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/tv/season_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import 'domain/usecases/tv/get_now_playing_tv.dart';
import 'domain/usecases/tv/get_popular_tv.dart';
import 'domain/usecases/tv/get_top_rated_tv.dart';
import 'domain/usecases/tv/get_tv_detail.dart';
import 'domain/usecases/tv/get_tv_recommendations.dart';
import 'domain/usecases/tv/get_watchlist_tv.dart';
import 'domain/usecases/tv/remove_tv_watchlist.dart';
import 'domain/usecases/tv/save_tv_watchlist.dart';
import 'domain/usecases/tv/search_tv.dart';
import 'presentation/provider/tv/popular_tvs_notifier.dart';
import 'presentation/provider/tv/top_rated_tv_notifier.dart';
import 'presentation/provider/tv/tv_detail_notifier.dart';
import 'presentation/provider/tv/tv_search_notifier.dart';
import 'presentation/provider/tv/watch_list_tv_notifier.dart';

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
