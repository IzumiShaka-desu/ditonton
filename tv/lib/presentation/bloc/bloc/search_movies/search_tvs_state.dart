part of 'search_tvs_bloc.dart';

abstract class SearchTvsState extends Equatable {
  const SearchTvsState();
  @override
  List<Object?> get props => [];
}

class InitialSearchTvsState extends SearchTvsState {}

class LoadingSearchTvsState extends SearchTvsState {}

class ErrorSearchTvsState extends SearchTvsState {
  final String message;
  const ErrorSearchTvsState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedSearchTvsState extends SearchTvsState {
  final List<Tv> searchResult;
  const LoadedSearchTvsState(this.searchResult);
  @override
  List<Object> get props => [searchResult];
}
