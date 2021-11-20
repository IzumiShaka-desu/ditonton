part of 'top_rated_tvs_cubit.dart';

abstract class TopRatedTvsState extends Equatable {
  const TopRatedTvsState();
  @override
  List<Object> get props => [];
}

class InitialTopRatedTvsState extends TopRatedTvsState {}

class LoadingTopRatedTvsState extends TopRatedTvsState {}

class ErrorTopRatedTvsState extends TopRatedTvsState {
  final String message;
  const ErrorTopRatedTvsState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedTopRatedTvsState extends TopRatedTvsState {
  final List<Tv> tvs;
  const LoadedTopRatedTvsState(this.tvs);
  @override
  List<Object> get props => [tvs];
}
