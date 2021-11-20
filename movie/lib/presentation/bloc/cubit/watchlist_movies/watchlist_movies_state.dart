part of 'watchlist_movies_cubit.dart';

abstract class WatchlistMoviesState extends Equatable {
  const WatchlistMoviesState();
  @override
  List<Object> get props => [];
}

class InitialWatchlistMoviesState extends WatchlistMoviesState {}

class LoadingWatchlistMoviesState extends WatchlistMoviesState {}

class ErrorWatchlistMoviesState extends WatchlistMoviesState {
  final String message;
  const ErrorWatchlistMoviesState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedWatchlistMoviesState extends WatchlistMoviesState {
  final List<Movie> movies;
  const LoadedWatchlistMoviesState(this.movies);
  @override
  List<Object> get props => [movies];
}
