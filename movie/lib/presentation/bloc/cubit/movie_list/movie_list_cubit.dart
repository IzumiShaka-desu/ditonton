import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
part 'movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> {
  final GetNowPlayingMovies _getNowPlayingMovies;
  final GetTopRatedMovies _getTopRatedMovies;
  final GetPopularMovies _getPopularMovies;
  MovieListCubit({
    required getNowPlayingMovies,
    required getPopularMovies,
    required getTopRatedMovies,
  })  : _getNowPlayingMovies = getNowPlayingMovies,
        _getPopularMovies = getPopularMovies,
        _getTopRatedMovies = getTopRatedMovies,
        super(
          InitialMovieListStates(),
        );
  Future<void> loadMovieList() async {
    emit(LoadingMovieListState());
    final results = await Future.wait<Either<Failure, List<Movie>>>([
      _getNowPlayingMovies.execute(),
      _getTopRatedMovies.execute(),
      _getPopularMovies.execute(),
    ]);
    final resultsData = results
        .map<List<Movie>>(
          (element) => element.fold(
            (l) => [],
            (r) => r,
          ),
        )
        .toList();
    emit(_getState(resultsData));
  }

  MovieListState _getState(List<List<Movie>> resultsData) {
    if (resultsData.where((element) => element.isNotEmpty).isEmpty ||
        resultsData.length < 3) {
      return const ErrorMovieListState(
        ErrorMovieListState.defaultMessage,
      );
    }
    return LoadedMovieListState(
      nowPlaying: resultsData.elementAt(0),
      topRated: resultsData.elementAt(1),
      popular: resultsData.elementAt(2),
    );
  }
}
