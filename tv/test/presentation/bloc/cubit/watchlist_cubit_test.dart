import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/tv.dart';
import 'package:tv/presentation/bloc/cubit/watchlist_tvs/watchlist_tvs_cubit.dart';

import '../../../dummy_data/tv_dummy_objects.dart';
import 'watchlist_cubit_test.mocks.dart';

@GenerateMocks([GetWatchlistTvs])
main() {
  late WatchlistTvsCubit cubit;
  late MockGetWatchlistTvs getWatchlistTvs;
  setUp(() {
    getWatchlistTvs = MockGetWatchlistTvs();
    cubit = WatchlistTvsCubit(getWatchlistTvs: getWatchlistTvs);
  });
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialWatchlistTvsState(),
    );
  });
  blocTest<WatchlistTvsCubit, WatchlistTvsState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getWatchlistTvs.execute()).thenAnswer((_) async => Right([testTv]));
      return cubit;
    },
    act: (cubit) => cubit.loadWatchlistTvs(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingWatchlistTvsState(),
      LoadedWatchlistTvsState([testTv]),
    ],
  );
  blocTest<WatchlistTvsCubit, WatchlistTvsState>(
    "The cubit should emit a ErrorState when is called",
    build: () {
      when(getWatchlistTvs.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('error')));
      return cubit;
    },
    act: (cubit) => cubit.loadWatchlistTvs(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingWatchlistTvsState(),
      const ErrorWatchlistTvsState('error'),
    ],
  );
  tearDown(() => cubit.close());
}
