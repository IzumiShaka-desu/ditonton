import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/cubit/popular_movies/popular_movies_cubit.dart';

import '../../../dummy/dummy_objects.dart';
import 'popular_cubit_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
main() {
  late PopularMoviesCubit cubit;
  late MockGetPopularMovies getPopularMovies;
  setUp(() {
    getPopularMovies = MockGetPopularMovies();
    cubit = PopularMoviesCubit(getPopularMovies: getPopularMovies);
  });
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialPopularMoviesState(),
    );
  });
  blocTest<PopularMoviesCubit, PopularMoviesState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getPopularMovies.execute())
          .thenAnswer((_) async => Right([testMovie]));
      return cubit;
    },
    act: (cubit) => cubit.loadPopularMovies(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingPopularMoviesState(),
      LoadedPopularMoviesState([testMovie]),
    ],
  );
  blocTest<PopularMoviesCubit, PopularMoviesState>(
    "The cubit should emit a ErrorState when is called",
    build: () {
      when(getPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      return cubit;
    },
    act: (cubit) => cubit.loadPopularMovies(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingPopularMoviesState(),
      const ErrorPopularMoviesState('server error'),
    ],
  );
  tearDown(() => cubit.close());
}
