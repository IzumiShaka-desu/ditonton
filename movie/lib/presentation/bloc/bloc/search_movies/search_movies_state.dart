part of 'search_movies_bloc.dart';

abstract class SearchMoviesState extends Equatable {
  const SearchMoviesState();
  @override
  List<Object?> get props => [];
}

class InitialSearchMoviesState extends SearchMoviesState {}

class LoadingSearchMoviesState extends SearchMoviesState {}

class ErrorSearchMoviesState extends SearchMoviesState {
  final String message;
  const ErrorSearchMoviesState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedSearchMoviesState extends SearchMoviesState {
  final List<Movie> searchResult;
  const LoadedSearchMoviesState(this.searchResult);
  @override
  List<Object> get props => [searchResult];
}
