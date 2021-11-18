part of 'top_rated_movies_cubit.dart';

abstract class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState();
  @override
  List<Object> get props => [];
}

class InitialTopRatedMoviesState extends TopRatedMoviesState {}

class LoadingTopRatedMoviesState extends TopRatedMoviesState {}

class ErrorTopRatedMoviesState extends TopRatedMoviesState {
  final String message;
  const ErrorTopRatedMoviesState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedTopRatedMoviesState extends TopRatedMoviesState {
  final List<Movie> movies;
  const LoadedTopRatedMoviesState(this.movies);
  @override
  List<Object> get props => [movies];
}
