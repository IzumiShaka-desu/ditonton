part of 'popular_movies_cubit.dart';

abstract class PopularMoviesState extends Equatable {
  const PopularMoviesState();
  @override
  List<Object> get props => [];
}

class InitialPopularMoviesState extends PopularMoviesState {}

class LoadingPopularMoviesState extends PopularMoviesState {}

class ErrorPopularMoviesState extends PopularMoviesState {
  final String message;
  const ErrorPopularMoviesState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedPopularMoviesState extends PopularMoviesState {
  final List<Movie> movies;
  const LoadedPopularMoviesState(this.movies);
  @override
  List<Object> get props => [movies];
}
