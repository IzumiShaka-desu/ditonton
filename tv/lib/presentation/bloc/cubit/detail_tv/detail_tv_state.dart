part of 'detail_tv_cubit.dart';

abstract class DetailTvsState extends Equatable {
  const DetailTvsState();
  @override
  List<Object> get props => [];
}

class InitialDetailTvsState extends DetailTvsState {}

class LoadingDetailTvsState extends DetailTvsState {}

class ErrorDetailTvsState extends DetailTvsState {
  final String message;
  const ErrorDetailTvsState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedWithRecommendationListDetailTvsState extends DetailTvsState {
  final TvDetail tvDetail;
  final bool isAddedtoWatchlistTvs;
  final List<Tv> recommendationTvs;
  const LoadedWithRecommendationListDetailTvsState(
    this.tvDetail,
    this.isAddedtoWatchlistTvs,
    this.recommendationTvs,
  );
  @override
  List<Object> get props => [
        tvDetail,
        isAddedtoWatchlistTvs,
        recommendationTvs,
      ];
}

class LoadedWithRecommendationErrorDetailTvsState extends DetailTvsState {
  final TvDetail tvDetail;
  final bool isAddedtoWatchlistTvs;
  final String recommendationError;
  const LoadedWithRecommendationErrorDetailTvsState(
    this.tvDetail,
    this.isAddedtoWatchlistTvs,
    this.recommendationError,
  );
  @override
  List<Object> get props => [
        tvDetail,
        isAddedtoWatchlistTvs,
        recommendationError,
      ];
}
