import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';

import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesCubit extends Cubit<WatchlistMoviesState> {
  final GetWatchlistMovies _getWatchlistMovies;
  WatchlistMoviesCubit({
    required getWatchlistMovies,
  })  : _getWatchlistMovies = getWatchlistMovies,
        super(
          InitialWatchlistMoviesState(),
        );

  Future<void> loadWatchlistMovies() async {
    emit(LoadingWatchlistMoviesState());
    final getResult = await _getWatchlistMovies.execute();
    getResult.fold(
      (error) => emit(
        ErrorWatchlistMoviesState(
          error.message,
        ),
      ),
      (resultMovies) => emit(LoadedWatchlistMoviesState(
        resultMovies,
      )),
    );
  }
}
