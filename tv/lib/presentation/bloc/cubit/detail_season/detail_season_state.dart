part of 'detail_season_cubit.dart';

abstract class DetailSeasonState extends Equatable {
  const DetailSeasonState();
  @override
  List<Object> get props => [];
}

class InitialDetailSeasonState extends DetailSeasonState {}

class LoadingDetailSeasonState extends DetailSeasonState {}

class ErrorDetailSeasonState extends DetailSeasonState {
  final String message;
  const ErrorDetailSeasonState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedDetailSeasonState extends DetailSeasonState {
  final SeasonDetail seasonDetail;
  const LoadedDetailSeasonState(this.seasonDetail);
  @override
  List<Object> get props => [seasonDetail];
}
