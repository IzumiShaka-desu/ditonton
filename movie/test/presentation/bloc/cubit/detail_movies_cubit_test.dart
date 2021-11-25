import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/cubit/detail_movies/detail_movies_cubit.dart';
import 'package:tv/presentation/bloc/cubit/detail_tv/detail_tv_cubit.dart';

import '../../../dummy/dummy_objects.dart';
import 'detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  SaveWatchlist,
  RemoveWatchlist,
  GetMovieRecommendations,
  GetWatchListStatus,
])
main() {
  late DetailMoviesCubit cubit;
  late MockGetMovieDetail getMovieDetail;
  late MockGetMovieRecommendations getMovieRecommendations;
  late MockGetWatchListStatus getWatchListStatus;
  late MockRemoveWatchlist removeWatchlist;
  late MockSaveWatchlist saveWatchlist;
  setUp(() {
    getMovieDetail = MockGetMovieDetail();
    getMovieDetail = MockGetMovieDetail();
    getMovieRecommendations = MockGetMovieRecommendations();
    getWatchListStatus = MockGetWatchListStatus();
    removeWatchlist = MockRemoveWatchlist();
    saveWatchlist = MockSaveWatchlist();
    cubit = DetailMoviesCubit(
      getMovieDetail: getMovieDetail,
      getMovieRecommendations: getMovieRecommendations,
      getWatchListStatus: getWatchListStatus,
      removeWatchlist: removeWatchlist,
      saveWatchlist: saveWatchlist,
    );
  });
  const tId = 1;
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialDetailMoviesState(),
    );
  });
  blocTest<DetailMoviesCubit, DetailMoviesState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(getMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testMovie]));
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return cubit;
    },
    act: (cubit) => cubit.loadDetailMovies(tId),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingDetailMoviesState(),
      LoadedWithRecommendationListDetailMoviesState(
        testMovieDetail,
        true,
        [testMovie],
      ),
    ],
  );
  test(
    'should execute save watchlist when function called',
    () async {
      /// arrange
      when(saveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('success insert'));
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => true);

      /// act
      await cubit.addWatchlist(testMovieDetail);

      /// assert
      expect(cubit.message, DetailTvCubit.watchlistAddSuccessMessage);
      verify(saveWatchlist.execute(testMovieDetail));
    },
  );
  test(
    'should execute save watchlist with  failed message when function called',
    () async {
      /// arrange
      when(saveWatchlist.execute(testMovieDetail)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Failed insert')));
      // when(getWatchListStatus.execute(tId)).thenAnswer((_) async => true);

      /// act
      await cubit.addWatchlist(testMovieDetail);

      /// assert
      expect(cubit.message, 'Failed insert');
      verify(saveWatchlist.execute(testMovieDetail));
    },
  );
  test(
    'should execute remove watchlist when function called',
    () async {
      /// arrange
      when(removeWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('success remove'));
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => true);

      /// act
      await cubit.removeFromWatchlist(testMovieDetail);

      /// assert
      expect(cubit.message, DetailTvCubit.watchlistRemoveSuccessMessage);
      verify(removeWatchlist.execute(testMovieDetail));
    },
  );
  test(
    'should execute remove watchlist  when function called',
    () async {
      /// arrange
      when(removeWatchlist.execute(testMovieDetail)).thenAnswer(
          (_) async => const Left(DatabaseFailure('failed remove')));
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => true);

      /// act
      await cubit.removeFromWatchlist(testMovieDetail);

      /// assert
      expect(cubit.message, 'failed remove');
      verify(removeWatchlist.execute(testMovieDetail));
    },
  );
  blocTest<DetailMoviesCubit, DetailMoviesState>(
    "The cubit should emit a ErrorState  when is called",
    build: () {
      when(getMovieDetail.execute(tId)).thenAnswer(
        (_) async => const Left(
          ServerFailure('server error'),
        ),
      );
      when(getMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testMovie]));
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => false);
      return cubit;
    },
    act: (cubit) => cubit.loadDetailMovies(tId),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingDetailMoviesState(),
      const ErrorDetailMoviesState('server error'),
    ],
  );
  blocTest<DetailMoviesCubit, DetailMoviesState>(
    "The cubit should emit a true added status  when is called",
    build: () {
      when(getMovieDetail.execute(tId)).thenAnswer(
        (_) async => Right(
          testMovieDetail,
        ),
      );

      when(getMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testMovie]));
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => false);
      return cubit;
    },
    act: (cubit) => cubit.loadDetailMovies(tId),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingDetailMoviesState(),
      LoadedWithRecommendationListDetailMoviesState(
          testMovieDetail, false, [testMovie]),
    ],
  );
  blocTest<DetailMoviesCubit, DetailMoviesState>(
    "The cubit should emit a  loaded data  when is addWatchlist called",
    build: () {
      when(getMovieDetail.execute(tId)).thenAnswer(
        (_) async => Right(
          testMovieDetail,
        ),
      );
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => false);
      when(getMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testMovie]));
      return cubit;
    },
    act: (cubit) async {
      await cubit.loadDetailMovies(tId);
      await cubit.addWatchlist(testMovieDetail);
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      LoadingDetailMoviesState(),
      LoadedWithRecommendationListDetailMoviesState(
          testMovieDetail, false, [testMovie]),
    ],
  );
  blocTest<DetailMoviesCubit, DetailMoviesState>(
    "The cubit should emit a  loaded data  when is removeWatchlist called",
    build: () {
      when(getMovieDetail.execute(tId)).thenAnswer(
        (_) async => Right(
          testMovieDetail,
        ),
      );
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      when(getMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testMovie]));
      return cubit;
    },
    act: (cubit) async {
      await cubit.loadDetailMovies(tId);
      await cubit.removeFromWatchlist(testMovieDetail);
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      LoadingDetailMoviesState(),
      LoadedWithRecommendationListDetailMoviesState(
          testMovieDetail, true, [testMovie]),
    ],
  );
  blocTest<DetailMoviesCubit, DetailMoviesState>(
    "The cubit should emit a LoadedState on recommendation when is called",
    build: () {
      when(getMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(getMovieRecommendations.execute(tId)).thenAnswer(
        (_) async => Left(
          ServerFailure('server error'),
        ),
      );
      when(getWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return cubit;
    },
    act: (cubit) => cubit.loadDetailMovies(tId),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingDetailMoviesState(),
      LoadedWithRecommendationErrorDetailMoviesState(
        testMovieDetail,
        true,
        "server error",
      ),
    ],
  );
  tearDown(() => cubit.close());
}
