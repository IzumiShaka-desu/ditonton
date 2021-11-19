import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/tv.dart';
import 'package:tv/presentation/bloc/cubit/tv_list/tv_list_cubit.dart';

import '../../../dummy_data/tv_dummy_objects.dart';
import 'tv_list_cubit_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingTvs,
  GetPopularTvs,
  GetTopRatedTvs,
])
main() {
  late TvListCubit cubit;
  late MockGetNowPlayingTvs getNowPlayingTvs;
  late MockGetPopularTvs getPopularTvs;
  late MockGetTopRatedTvs getTopRatedTvs;
  setUp(() {
    getNowPlayingTvs = MockGetNowPlayingTvs();
    getTopRatedTvs = MockGetTopRatedTvs();
    getPopularTvs = MockGetPopularTvs();
    cubit = TvListCubit(
      getNowPlayingTvs: getNowPlayingTvs,
      getPopularTvs: getPopularTvs,
      getTopRatedTvs: getTopRatedTvs,
    );
  });
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialTvListStates(),
    );
  });
  blocTest<TvListCubit, TvListState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getNowPlayingTvs.execute()).thenAnswer(
        (_) async => Right([testTv]),
      );
      when(getTopRatedTvs.execute()).thenAnswer(
        (_) async => Right([testTv]),
      );
      when(getPopularTvs.execute()).thenAnswer(
        (_) async => Right([testTv]),
      );

      return cubit;
    },
    act: (cubit) => cubit.loadTvList(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingTvListState(),
      LoadedTvListState(
          nowPlaying: [testTv], popular: [testTv], topRated: [testTv]),
    ],
  );
  blocTest<TvListCubit, TvListState>(
    "The cubit should emit a LoadedState with one empty array when is called",
    build: () {
      when(getNowPlayingTvs.execute()).thenAnswer(
        (_) async => Right([testTv]),
      );
      when(getTopRatedTvs.execute()).thenAnswer(
        (_) async => Left(ConnectionFailure("cannot connect to network")),
      );
      when(getPopularTvs.execute()).thenAnswer(
        (_) async => Right([testTv]),
      );

      return cubit;
    },
    act: (cubit) => cubit.loadTvList(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingTvListState(),
      LoadedTvListState(
          nowPlaying: [testTv], popular: [testTv], topRated: const []),
    ],
  );
  blocTest<TvListCubit, TvListState>(
    "The cubit should emit a ErrorState when is called",
    build: () {
      when(getNowPlayingTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      when(getTopRatedTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      when(getPopularTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      return cubit;
    },
    act: (cubit) => cubit.loadTvList(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingTvListState(),
      const ErrorTvListState(ErrorTvListState.defaultMessage),
    ],
  );
  tearDown(() => cubit.close());
}
