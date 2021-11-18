import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesCubit extends Cubit<TopRatedMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;
  TopRatedMoviesCubit({
    required getTopRatedMovies,
  })  : _getTopRatedMovies = getTopRatedMovies,
        super(
          InitialTopRatedMoviesState(),
        );
  Future<void> loadTopRatedMovies() async {
    emit(LoadingTopRatedMoviesState());
    final getResult = await _getTopRatedMovies.execute();
    getResult.fold(
      (error) => emit(
        ErrorTopRatedMoviesState(error.message),
      ),
      (resultMovies) => emit(
        LoadedTopRatedMoviesState(resultMovies),
      ),
    );
  }
}
