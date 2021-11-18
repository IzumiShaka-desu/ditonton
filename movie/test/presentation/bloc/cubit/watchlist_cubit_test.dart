import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/cubit/watchlist_movies/watchlist_movies_cubit.dart';

import '../../../dummy/dummy_objects.dart';
import 'watchlist_cubit_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
main() {
  late WatchlistMoviesCubit cubit;
  late MockGetWatchlistMovies getWatchlistMovies;
  setUp(() {
    getWatchlistMovies = MockGetWatchlistMovies();
    cubit = WatchlistMoviesCubit(getWatchlistMovies: getWatchlistMovies);
  });
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialWatchlistMoviesState(),
    );
  });
  blocTest<WatchlistMoviesCubit, WatchlistMoviesState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getWatchlistMovies.execute())
          .thenAnswer((_) async => Right([testMovie]));
      return cubit;
    },
    act: (cubit) => cubit.loadWatchlistMovies(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingWatchlistMoviesState(),
      LoadedWatchlistMoviesState([testMovie]),
    ],
  );
  blocTest<WatchlistMoviesCubit, WatchlistMoviesState>(
    "The cubit should emit a ErrorState when is called",
    build: () {
      when(getWatchlistMovies.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('error')));
      return cubit;
    },
    act: (cubit) => cubit.loadWatchlistMovies(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingWatchlistMoviesState(),
      const ErrorWatchlistMoviesState('error'),
    ],
  );
  tearDown(() => cubit.close());
}
