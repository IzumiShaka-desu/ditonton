part of 'detail_movies_cubit.dart';

abstract class DetailMoviesState extends Equatable {
  const DetailMoviesState();
  @override
  List<Object> get props => [];
}

class InitialDetailMoviesState extends DetailMoviesState {}

class LoadingDetailMoviesState extends DetailMoviesState {}

class ErrorDetailMoviesState extends DetailMoviesState {
  final String message;
  const ErrorDetailMoviesState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedWithRecommendationListDetailMoviesState extends DetailMoviesState {
  final MovieDetail movieDetail;
  final bool isAddedtoWatchlistMovies;
  final List<Movie> recommendationMovies;
  const LoadedWithRecommendationListDetailMoviesState(
    this.movieDetail,
    this.isAddedtoWatchlistMovies,
    this.recommendationMovies,
  );
  @override
  List<Object> get props => [
        movieDetail,
        isAddedtoWatchlistMovies,
        recommendationMovies,
      ];

  LoadedWithRecommendationListDetailMoviesState copyWith({
    MovieDetail? movieDetail,
    bool? isAddedtoWatchlistMovies,
    List<Movie>? recommendationMovies,
  }) {
    return LoadedWithRecommendationListDetailMoviesState(
      movieDetail ?? this.movieDetail,
      isAddedtoWatchlistMovies ?? this.isAddedtoWatchlistMovies,
      recommendationMovies ?? this.recommendationMovies,
    );
  }
}

class LoadedWithRecommendationErrorDetailMoviesState extends DetailMoviesState {
  final MovieDetail movieDetail;
  final bool isAddedtoWatchlistMovies;
  final String recommendationError;
  const LoadedWithRecommendationErrorDetailMoviesState(
    this.movieDetail,
    this.isAddedtoWatchlistMovies,
    this.recommendationError,
  );
  @override
  List<Object> get props => [
        movieDetail,
        isAddedtoWatchlistMovies,
        recommendationError,
      ];

  LoadedWithRecommendationErrorDetailMoviesState copyWith({
    MovieDetail? movieDetail,
    bool? isAddedtoWatchlistMovies,
    String? recommendationError,
  }) {
    return LoadedWithRecommendationErrorDetailMoviesState(
      movieDetail ?? this.movieDetail,
      isAddedtoWatchlistMovies ?? this.isAddedtoWatchlistMovies,
      recommendationError ?? this.recommendationError,
    );
  }
}
