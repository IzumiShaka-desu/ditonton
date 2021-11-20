import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
part 'top_rated_tvs_state.dart';

class TopRatedTvsCubit extends Cubit<TopRatedTvsState> {
  final GetTopRatedTvs _getTopRatedTvs;
  TopRatedTvsCubit({
    required getTopRatedTvs,
  })  : _getTopRatedTvs = getTopRatedTvs,
        super(
          InitialTopRatedTvsState(),
        );
  Future<void> loadTopRatedTvs() async {
    emit(LoadingTopRatedTvsState());
    final getResult = await _getTopRatedTvs.execute();
    getResult.fold(
      (error) => emit(
        ErrorTopRatedTvsState(error.message),
      ),
      (resultTvs) => emit(
        LoadedTopRatedTvsState(resultTvs),
      ),
    );
  }
}
