part of 'watchlist_tvs_cubit.dart';

abstract class WatchlistTvsState extends Equatable {
  const WatchlistTvsState();
  @override
  List<Object> get props => [];
}

class InitialWatchlistTvsState extends WatchlistTvsState {}

class LoadingWatchlistTvsState extends WatchlistTvsState {}

class ErrorWatchlistTvsState extends WatchlistTvsState {
  final String message;
  const ErrorWatchlistTvsState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedWatchlistTvsState extends WatchlistTvsState {
  final List<Tv> tvs;
  const LoadedWatchlistTvsState(this.tvs);
  @override
  List<Object> get props => [tvs];
}
