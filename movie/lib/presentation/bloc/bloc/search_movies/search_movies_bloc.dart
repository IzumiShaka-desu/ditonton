import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
part 'search_movies_state.dart';
part 'search_movies_event.dart';

class SearchMoviesBloc extends Bloc<SearchMoviesEvent, SearchMoviesState> {
  final SearchMovies _searchMovies;
  SearchMoviesBloc(this._searchMovies) : super(InitialSearchMoviesState()) {
    on<OnQueryChanged>(
      (event, emit) async {
        final query = event.query;
        emit(LoadingSearchMoviesState());
        final result = await _searchMovies.execute(query);
        result.fold(
          (failure) {
            emit(ErrorSearchMoviesState(failure.message));
          },
          (data) {
            emit(LoadedSearchMoviesState(data));
          },
        );
      },
      transformer: (event, transtitionFn) => event
          .debounceTime(const Duration(milliseconds: 500))
          .switchMap(transtitionFn),
    );
  }
}
