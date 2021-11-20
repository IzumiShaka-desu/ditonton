part of 'movie_list_cubit.dart';

abstract class MovieListState extends Equatable {
  const MovieListState();
  @override
  List<Object> get props => [];
}

class InitialMovieListStates extends MovieListState {}

class LoadingMovieListState extends MovieListState {}

class ErrorMovieListState extends MovieListState {
  static const defaultMessage = "cannot load Movies data";
  final String message;
  const ErrorMovieListState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedMovieListState extends MovieListState {
  final List<Movie> nowPlaying;
  final List<Movie> topRated;
  final List<Movie> popular;

  const LoadedMovieListState({
    required this.nowPlaying,
    required this.topRated,
    required this.popular,
  });

  @override
  List<Object> get props => [
        nowPlaying,
        topRated,
        popular,
      ];
}
