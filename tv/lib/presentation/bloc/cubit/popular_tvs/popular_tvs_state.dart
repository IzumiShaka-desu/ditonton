part of 'popular_tvs_cubit.dart';

abstract class PopularTvsState extends Equatable {
  const PopularTvsState();
  @override
  List<Object> get props => [];
}

class InitialPopularTvsState extends PopularTvsState {}

class LoadingPopularTvsState extends PopularTvsState {}

class ErrorPopularTvsState extends PopularTvsState {
  final String message;
  const ErrorPopularTvsState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedPopularTvsState extends PopularTvsState {
  final List<Tv> tvs;
  const LoadedPopularTvsState(this.tvs);
  @override
  List<Object> get props => [tvs];
}
