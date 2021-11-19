part of 'tv_list_cubit.dart';

abstract class TvListState extends Equatable {
  const TvListState();
  @override
  List<Object> get props => [];
}

class InitialTvListStates extends TvListState {}

class LoadingTvListState extends TvListState {}

class ErrorTvListState extends TvListState {
  static const defaultMessage = "cannot load Tvs data";
  final String message;
  const ErrorTvListState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedTvListState extends TvListState {
  final List<Tv> nowPlaying;
  final List<Tv> topRated;
  final List<Tv> popular;

  const LoadedTvListState({
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
