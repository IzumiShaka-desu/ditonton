import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';

part 'detail_movies_state.dart';

class DetailMoviesCubit extends Cubit<DetailMoviesState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail _getMovieDetail;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;
  final GetMovieRecommendations _getMovieRecommendations;
  final GetWatchListStatus _getWatchListStatus;
  String _message = '';
  String get message => _message;
  DetailMoviesCubit({
    required getMovieRecommendations,
    required getWatchListStatus,
    required saveWatchlist,
    required removeWatchlist,
    required getMovieDetail,
  })  : _saveWatchlist = saveWatchlist,
        _removeWatchlist = removeWatchlist,
        _getMovieDetail = getMovieDetail,
        _getMovieRecommendations = getMovieRecommendations,
        _getWatchListStatus = getWatchListStatus,
        super(
          InitialDetailMoviesState(),
        );

  Future<void> loadDetailMovies(int id) async {
    emit(LoadingDetailMoviesState());
    final getDetailResult = await _getMovieDetail.execute(id);
    final isAddedToWatchlist = await _getWatchListStatus.execute(id);
    final getRecommendationResult = await _getMovieRecommendations.execute(id);
    getDetailResult.fold(
      (error) => emit(
        ErrorDetailMoviesState(error.message),
      ),
      (detailResult) {
        getRecommendationResult.fold(
          (error) => emit(
            LoadedWithRecommendationErrorDetailMoviesState(
              detailResult,
              isAddedToWatchlist,
              error.message,
            ),
          ),
          (recommend) => emit(
            LoadedWithRecommendationListDetailMoviesState(
              detailResult,
              isAddedToWatchlist,
              recommend,
            ),
          ),
        );
      },
    );
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    try {
      final result = await _removeWatchlist.execute(movie);
      result.fold(
        (fail) async => _message = fail.message,
        (result) async => _message = watchlistRemoveSuccessMessage,
      );
    } catch (e) {
      _message = "Failed";
    }
  }

  Future<void> addWatchlist(MovieDetail movie) async {
    try {
      final result = await _saveWatchlist.execute(movie);
      print(result);
      result.fold(
        (fail) async => _message = fail.message,
        (result) async => _message = watchlistAddSuccessMessage,
      );
    } catch (e) {
      _message = "Failed";
    }
  }
}
