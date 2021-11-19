import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
part 'tv_list_state.dart';

class TvListCubit extends Cubit<TvListState> {
  final GetNowPlayingTvs _getNowPlayingTvs;
  final GetTopRatedTvs _getTopRatedTvs;
  final GetPopularTvs _getPopularTvs;
  TvListCubit({
    required getNowPlayingTvs,
    required getPopularTvs,
    required getTopRatedTvs,
  })  : _getNowPlayingTvs = getNowPlayingTvs,
        _getPopularTvs = getPopularTvs,
        _getTopRatedTvs = getTopRatedTvs,
        super(
          InitialTvListStates(),
        );
  Future<void> loadTvList() async {
    emit(LoadingTvListState());
    final results = await Future.wait<Either<Failure, List<Tv>>>([
      _getNowPlayingTvs.execute(),
      _getTopRatedTvs.execute(),
      _getPopularTvs.execute(),
    ]);
    final resultsData = results
        .map<List<Tv>>(
          (element) => element.fold(
            (l) => [],
            (r) => r,
          ),
        )
        .toList();
    emit(_getState(resultsData));
  }

  TvListState _getState(List<List<Tv>> resultsData) {
    if (resultsData.where((element) => element.isNotEmpty).isEmpty ||
        resultsData.length < 3) {
      return const ErrorTvListState(
        ErrorTvListState.defaultMessage,
      );
    }
    return LoadedTvListState(
      nowPlaying: resultsData.elementAt(0),
      topRated: resultsData.elementAt(1),
      popular: resultsData.elementAt(2),
    );
  }
}
