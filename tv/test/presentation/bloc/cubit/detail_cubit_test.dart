import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/tv.dart';
import 'package:tv/presentation/bloc/cubit/detail_tv/detail_tv_cubit.dart';

import '../../../dummy/tv_dummy_objects.dart';
import 'detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  SaveTvWatchlist,
  RemoveTvWatchlist,
  GetTvRecommendations,
  GetTvWatchListStatus,
])
main() {
  late DetailTvCubit cubit;
  late MockGetTvDetail getTvDetail;
  late MockGetTvRecommendations getTvRecommendations;
  late MockGetWatchListStatus getWatchListStatus;
  late MockRemoveTvWatchlist removeWatchlist;
  late MockSaveWatchlist saveWatchlist;
  setUp(() {
    getTvDetail = MockGetTvDetail();
    getTvDetail = MockGetTvDetail();
    getTvRecommendations = MockGetTvRecommendations();
    getWatchListStatus = MockGetWatchListStatus();
    removeWatchlist = MockRemoveTvWatchlist();
    saveWatchlist = MockSaveWatchlist();
    cubit = DetailTvCubit(
      getTvDetail: getTvDetail,
      getTvRecommendations: getTvRecommendations,
      getWatchListStatus: getWatchListStatus,
      removeWatchlist: removeWatchlist,
      saveWatchlist: saveWatchlist,
    );
  });
  const tId = 1;
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialDetailTvsState(),
    );
  });
  blocTest<DetailTvCubit, DetailTvsState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));
      when(getTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testTv]));
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return cubit;
    },
    act: (cubit) => cubit.loadDetailTv(tId),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingDetailTvsState(),
      LoadedWithRecommendationListDetailTvsState(
        testTvDetail,
        true,
        [testTv],
      ),
    ],
  );
  blocTest<DetailTvCubit, DetailTvsState>(
    "The cubit should emit a ErrorState  when is called",
    build: () {
      when(getTvDetail.execute(tId)).thenAnswer(
        (_) async => Left(
          ServerFailure('server error'),
        ),
      );
      when(getTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testTv]));
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => false);
      return cubit;
    },
    act: (cubit) => cubit.loadDetailTv(tId),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingDetailTvsState(),
      const ErrorDetailTvsState('server error'),
    ],
  );

  blocTest<DetailTvCubit, DetailTvsState>(
    "The cubit should emit a LoadedState on recommendation when is called",
    build: () {
      when(getTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));
      when(getTvRecommendations.execute(tId)).thenAnswer(
        (_) async => Left(
          ServerFailure('server error'),
        ),
      );
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return cubit;
    },
    act: (cubit) => cubit.loadDetailTv(tId),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingDetailTvsState(),
      LoadedWithRecommendationErrorDetailTvsState(
        testTvDetail,
        true,
        "server error",
      ),
    ],
  );
  tearDown(() => cubit.close());
}
