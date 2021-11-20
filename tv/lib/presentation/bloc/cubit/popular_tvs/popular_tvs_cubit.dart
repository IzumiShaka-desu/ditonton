import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
part 'popular_tvs_state.dart';

class PopularTvsCubit extends Cubit<PopularTvsState> {
  final GetPopularTvs _getPopularTvs;
  PopularTvsCubit({
    required getPopularTvs,
  })  : _getPopularTvs = getPopularTvs,
        super(
          InitialPopularTvsState(),
        );
  Future<void> loadPopularTvs() async {
    emit(LoadingPopularTvsState());
    final getResult = await _getPopularTvs.execute();
    getResult.fold(
      (error) => emit(
        ErrorPopularTvsState(error.message),
      ),
      (resultTvs) => emit(LoadedPopularTvsState(resultTvs)),
    );
  }
}
