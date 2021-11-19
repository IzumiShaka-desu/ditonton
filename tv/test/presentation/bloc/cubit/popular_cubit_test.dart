import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/tv.dart';
import 'package:tv/presentation/bloc/cubit/popular_tvs/popular_tvs_cubit.dart';

import '../../../dummy/tv_dummy_objects.dart';
import 'popular_cubit_test.mocks.dart';

@GenerateMocks([GetPopularTvs])
main() {
  late PopularTvsCubit cubit;
  late MockGetPopularTvs getPopularTvs;
  setUp(() {
    getPopularTvs = MockGetPopularTvs();
    cubit = PopularTvsCubit(getPopularTvs: getPopularTvs);
  });
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialPopularTvsState(),
    );
  });
  blocTest<PopularTvsCubit, PopularTvsState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getPopularTvs.execute()).thenAnswer((_) async => Right([testTv]));
      return cubit;
    },
    act: (cubit) => cubit.loadPopularTvs(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingPopularTvsState(),
      LoadedPopularTvsState([testTv]),
    ],
  );
  blocTest<PopularTvsCubit, PopularTvsState>(
    "The cubit should emit a ErrorState when is called",
    build: () {
      when(getPopularTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      return cubit;
    },
    act: (cubit) => cubit.loadPopularTvs(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingPopularTvsState(),
      const ErrorPopularTvsState('server error'),
    ],
  );
  tearDown(() => cubit.close());
}
