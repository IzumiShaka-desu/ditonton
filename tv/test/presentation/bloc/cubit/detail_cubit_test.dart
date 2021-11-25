import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/tv.dart';
import 'package:tv/presentation/bloc/cubit/detail_tv/detail_tv_cubit.dart';

import '../../../dummy_data/tv_dummy_objects.dart';
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
  late MockGetTvWatchListStatus getWatchListStatus;
  late MockRemoveTvWatchlist removeWatchlist;
  late MockSaveTvWatchlist saveWatchlist;
  setUp(() {
    getTvDetail = MockGetTvDetail();
    getTvDetail = MockGetTvDetail();
    getTvRecommendations = MockGetTvRecommendations();
    getWatchListStatus = MockGetTvWatchListStatus();
    removeWatchlist = MockRemoveTvWatchlist();
    saveWatchlist = MockSaveTvWatchlist();
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

  test(
    'should execute save watchlist when function called',
    () async {
      /// arrange
      when(saveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Right('success insert'));
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => true);

      /// act
      await cubit.addWatchlist(testTvDetail);

      /// assert
      expect(cubit.message, DetailTvCubit.watchlistAddSuccessMessage);
      verify(saveWatchlist.execute(testTvDetail));
    },
  );
  test(
    'should execute save watchlist with  failed message when function called',
    () async {
      /// arrange
      when(saveWatchlist.execute(testTvDetail)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Failed insert')));
      // when(getWatchListStatus.execute(tId)).thenAnswer((_) async => true);

      /// act
      await cubit.addWatchlist(testTvDetail);

      /// assert
      expect(cubit.message, 'Failed insert');
      verify(saveWatchlist.execute(testTvDetail));
    },
  );
  test(
    'should execute remove watchlist when function called',
    () async {
      /// arrange
      when(removeWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Right('success remove'));
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => true);

      /// act
      await cubit.removeFromWatchlist(testTvDetail);

      /// assert
      expect(cubit.message, DetailTvCubit.watchlistRemoveSuccessMessage);
      verify(removeWatchlist.execute(testTvDetail));
    },
  );
  test(
    'should execute remove watchlist  when function called',
    () async {
      /// arrange
      when(removeWatchlist.execute(testTvDetail)).thenAnswer(
          (_) async => const Left(DatabaseFailure('failed remove')));
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => true);

      /// act
      await cubit.removeFromWatchlist(testTvDetail);

      /// assert
      expect(cubit.message, 'failed remove');
      verify(removeWatchlist.execute(testTvDetail));
    },
  );
  blocTest<DetailTvCubit, DetailTvsState>(
    "The cubit should emit a true added status  when is called",
    build: () {
      when(getTvDetail.execute(tId)).thenAnswer(
        (_) async => Right(
          testTvDetail,
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
      LoadedWithRecommendationListDetailTvsState(testTvDetail, false, [testTv]),
    ],
  );
  blocTest<DetailTvCubit, DetailTvsState>(
    "The cubit should emit a  loaded data  when is addWatchlist called",
    build: () {
      when(getTvDetail.execute(tId)).thenAnswer(
        (_) async => Right(
          testTvDetail,
        ),
      );
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => false);
      when(getTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testTv]));
      return cubit;
    },
    act: (cubit) async {
      await cubit.loadDetailTv(tId);
      await cubit.addWatchlist(testTvDetail);
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      LoadingDetailTvsState(),
      LoadedWithRecommendationListDetailTvsState(testTvDetail, false, [testTv]),
    ],
  );

  blocTest<DetailTvCubit, DetailTvsState>(
    "The cubit should emit a  loaded data  when is removeWatchlist called",
    build: () {
      when(getTvDetail.execute(tId)).thenAnswer(
        (_) async => Right(
          testTvDetail,
        ),
      );
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      when(getTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testTv]));
      return cubit;
    },
    act: (cubit) async {
      await cubit.loadDetailTv(tId);
      await cubit.removeFromWatchlist(testTvDetail);
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      LoadingDetailTvsState(),
      LoadedWithRecommendationListDetailTvsState(testTvDetail, true, [testTv]),
    ],
  );
  blocTest<DetailTvCubit, DetailTvsState>(
    "The cubit should emit a ErrorState  when is called",
    build: () {
      when(getTvDetail.execute(tId)).thenAnswer(
        (_) async => const Left(
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
        (_) async => const Left(
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
