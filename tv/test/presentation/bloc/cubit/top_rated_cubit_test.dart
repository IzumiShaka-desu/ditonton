import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/tv.dart';
import 'package:tv/presentation/bloc/cubit/top_rated_movies/top_rated_tvs_cubit.dart';

import '../../../dummy_data/tv_dummy_objects.dart';
import 'top_rated_cubit_test.mocks.dart';

@GenerateMocks([GetTopRatedTvs])
main() {
  late TopRatedTvsCubit cubit;
  late MockGetTopRatedTvs getTopRatedTvs;
  setUp(() {
    getTopRatedTvs = MockGetTopRatedTvs();
    cubit = TopRatedTvsCubit(getTopRatedTvs: getTopRatedTvs);
  });
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialTopRatedTvsState(),
    );
  });
  blocTest<TopRatedTvsCubit, TopRatedTvsState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getTopRatedTvs.execute()).thenAnswer((_) async => Right([testTv]));
      return cubit;
    },
    act: (cubit) => cubit.loadTopRatedTvs(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingTopRatedTvsState(),
      LoadedTopRatedTvsState([testTv]),
    ],
  );
  blocTest<TopRatedTvsCubit, TopRatedTvsState>(
    "The cubit should emit a ErrorState when is called",
    build: () {
      when(getTopRatedTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      return cubit;
    },
    act: (cubit) => cubit.loadTopRatedTvs(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingTopRatedTvsState(),
      const ErrorTopRatedTvsState('server error'),
    ],
  );
  tearDown(() => cubit.close());
}
