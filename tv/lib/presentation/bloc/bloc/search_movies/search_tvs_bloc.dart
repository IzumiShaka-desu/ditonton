import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/search_tv.dart';
part 'search_tvs_state.dart';
part 'search_tvs_event.dart';

class SearchTvsBloc extends Bloc<SearchTvsEvent, SearchTvsState> {
  final SearchTvs _searchTvs;
  SearchTvsBloc(this._searchTvs) : super(InitialSearchTvsState()) {
    on<OnQueryChanged>(
      (event, emit) async {
        final query = event.query;
        emit(LoadingSearchTvsState());
        final result = await _searchTvs.execute(query);
        result.fold(
          (failure) {
            emit(ErrorSearchTvsState(failure.message));
          },
          (data) {
            emit(LoadedSearchTvsState(data));
          },
        );
      },
      transformer: (event, transtitionFn) => event
          .debounceTime(const Duration(milliseconds: 500))
          .switchMap(transtitionFn),
    );
  }
}
