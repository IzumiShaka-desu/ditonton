import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/season_detail.dart';
import 'package:tv/domain/usecases/get_season_detail.dart';
part 'detail_season_state.dart';

class DetailSeasonCubit extends Cubit<DetailSeasonState> {
  final GetSeasonDetail _getDetailSeason;
  DetailSeasonCubit({
    required getDetailSeason,
  })  : _getDetailSeason = getDetailSeason,
        super(
          InitialDetailSeasonState(),
        );
  Future<void> loadDetailSeason(int id, int seasonNumber) async {
    emit(LoadingDetailSeasonState());
    final getResult = await _getDetailSeason.execute(
      id,
      seasonNumber,
    );
    getResult.fold(
      (error) => emit(
        ErrorDetailSeasonState(error.message),
      ),
      (resultDetailSeason) => emit(
        LoadedDetailSeasonState(resultDetailSeason),
      ),
    );
  }
}
