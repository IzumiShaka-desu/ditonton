import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/cubit/movie_list/movie_list_cubit.dart';

import '../../../dummy/dummy_objects.dart';
import 'movie_list_cubit_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
])
main() {
  late MovieListCubit cubit;
  late MockGetNowPlayingMovies getNowPlayingMovies;
  late MockGetPopularMovies getPopularMovies;
  late MockGetTopRatedMovies getTopRatedMovies;
  setUp(() {
    getNowPlayingMovies = MockGetNowPlayingMovies();
    getTopRatedMovies = MockGetTopRatedMovies();
    getPopularMovies = MockGetPopularMovies();
    cubit = MovieListCubit(
      getNowPlayingMovies: getNowPlayingMovies,
      getPopularMovies: getPopularMovies,
      getTopRatedMovies: getTopRatedMovies,
    );
  });
  test("Initial state test", () {
    expect(
      cubit.state,
      InitialMovieListStates(),
    );
  });
  blocTest<MovieListCubit, MovieListState>(
    "The cubit should emit a LoadedState when is called",
    build: () {
      when(getNowPlayingMovies.execute()).thenAnswer(
        (_) async => Right([testMovie]),
      );
      when(getTopRatedMovies.execute()).thenAnswer(
        (_) async => Right([testMovie]),
      );
      when(getPopularMovies.execute()).thenAnswer(
        (_) async => Right([testMovie]),
      );

      return cubit;
    },
    act: (cubit) => cubit.loadMovieList(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingMovieListState(),
      LoadedMovieListState(
          nowPlaying: [testMovie], popular: [testMovie], topRated: [testMovie]),
    ],
  );
  blocTest<MovieListCubit, MovieListState>(
    "The cubit should emit a LoadedState with one empty array when is called",
    build: () {
      when(getNowPlayingMovies.execute()).thenAnswer(
        (_) async => Right([testMovie]),
      );
      when(getTopRatedMovies.execute()).thenAnswer(
        (_) async => Left(ConnectionFailure("cannot connect to network")),
      );
      when(getPopularMovies.execute()).thenAnswer(
        (_) async => Right([testMovie]),
      );

      return cubit;
    },
    act: (cubit) => cubit.loadMovieList(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingMovieListState(),
      LoadedMovieListState(
          nowPlaying: [testMovie], popular: [testMovie], topRated: const []),
    ],
  );
  blocTest<MovieListCubit, MovieListState>(
    "The cubit should emit a ErrorState when is called",
    build: () {
      when(getNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      when(getTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      when(getPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('server error')));
      return cubit;
    },
    act: (cubit) => cubit.loadMovieList(),
    wait: const Duration(milliseconds: 200),
    expect: () => [
      LoadingMovieListState(),
      const ErrorMovieListState(ErrorMovieListState.defaultMessage),
    ],
  );
  tearDown(() => cubit.close());
}
