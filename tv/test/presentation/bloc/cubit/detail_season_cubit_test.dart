import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/cubit/detail_season/detail_season_cubit.dart';
import 'package:tv/tv.dart';

import '../../../dummy_data/tv_dummy_objects.dart';
import '../../providers/season_detail_notifier_test.mocks.dart';

@GenerateMocks([GetSeasonDetail])
main() {
  late DetailSeasonCubit cubit;
  late MockGetSeasonDetail getSeasonDetail;
  setUp(() {
    getSeasonDetail = MockGetSeasonDetail();
    cubit = DetailSeasonCubit(getDetailSeason: getSeasonDetail);
  });
  const tId = 1;
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialDetailSeasonState(),
    );
  });
  blocTest<DetailSeasonCubit, DetailSeasonState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getSeasonDetail.execute(tId, tId))
          .thenAnswer((_) async => Right(testSeasonDetail));
      return cubit;
    },
    act: (cubit) => cubit.loadDetailSeason(tId, tId),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingDetailSeasonState(),
      LoadedDetailSeasonState(testSeasonDetail),
    ],
  );
  blocTest<DetailSeasonCubit, DetailSeasonState>(
    "The cubit should emit a ErrorState when is called",
    build: () {
      when(getSeasonDetail.execute(tId, tId))
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      return cubit;
    },
    act: (cubit) => cubit.loadDetailSeason(tId, tId),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingDetailSeasonState(),
      const ErrorDetailSeasonState('server error'),
    ],
  );
  tearDown(() => cubit.close());
}
