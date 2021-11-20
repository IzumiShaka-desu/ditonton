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

  @override
  LoadedWithRecommendationListDetailTvsState copyWith({
    TvDetail? tvDetail,
    bool? isAddedtoWatchlistTvs,
    List<Tv>? recommendationTvs,
  }) {
    return LoadedWithRecommendationListDetailTvsState(
      tvDetail ?? this.tvDetail,
      isAddedtoWatchlistTvs ?? this.isAddedtoWatchlistTvs,
      recommendationTvs ?? this.recommendationTvs,
    );
  }
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

  @override
  LoadedWithRecommendationErrorDetailTvsState copyWith({
    TvDetail? tvDetail,
    bool? isAddedtoWatchlistTvs,
    String? recommendationError,
  }) {
    return LoadedWithRecommendationErrorDetailTvsState(
      tvDetail ?? this.tvDetail,
      isAddedtoWatchlistTvs ?? this.isAddedtoWatchlistTvs,
      recommendationError ?? this.recommendationError,
    );
  }
}
