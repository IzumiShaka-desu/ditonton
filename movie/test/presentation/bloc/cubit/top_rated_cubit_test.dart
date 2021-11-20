import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/cubit/top_rated_movies/top_rated_movies_cubit.dart';

import '../../../dummy/dummy_objects.dart';
import 'top_rated_cubit_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
main() {
  late TopRatedMoviesCubit cubit;
  late MockGetTopRatedMovies getTopRatedMovies;
  setUp(() {
    getTopRatedMovies = MockGetTopRatedMovies();
    cubit = TopRatedMoviesCubit(getTopRatedMovies: getTopRatedMovies);
  });
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialTopRatedMoviesState(),
    );
  });
  blocTest<TopRatedMoviesCubit, TopRatedMoviesState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getTopRatedMovies.execute())
          .thenAnswer((_) async => Right([testMovie]));
      return cubit;
    },
    act: (cubit) => cubit.loadTopRatedMovies(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingTopRatedMoviesState(),
      LoadedTopRatedMoviesState([testMovie]),
    ],
  );
  blocTest<TopRatedMoviesCubit, TopRatedMoviesState>(
    "The cubit should emit a ErrorState when is called",
    build: () {
      when(getTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      return cubit;
    },
    act: (cubit) => cubit.loadTopRatedMovies(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingTopRatedMoviesState(),
      const ErrorTopRatedMoviesState('server error'),
    ],
  );
  tearDown(() => cubit.close());
}
