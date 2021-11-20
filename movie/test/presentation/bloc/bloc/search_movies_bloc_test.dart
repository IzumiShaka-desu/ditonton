import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/bloc/search_movies/search_movies_bloc.dart';

import '../../../dummy/dummy_objects.dart';
import 'search_movies_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late SearchMoviesBloc searchMoviesBloc;
  late MockSearchMovies mockSearchMovies;
  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchMoviesBloc = SearchMoviesBloc(mockSearchMovies);
  });
  test('initial state should be empty', () {
    expect(searchMoviesBloc.state, InitialSearchMoviesState());
  });
  const tQuery = 'spiderman';

  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(testMovieList));
      return searchMoviesBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 600),
    expect: () => [
      LoadingSearchMoviesState(),
      LoadedSearchMoviesState(testMovieList),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );
  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'Should emit [Loading, Error] when data is gotten error',
    build: () {
      when(mockSearchMovies.execute(tQuery)).thenAnswer(
        (_) async => Left(
          ServerFailure('error connection'),
        ),
      );
      return searchMoviesBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 600),
    expect: () => [
      LoadingSearchMoviesState(),
      const ErrorSearchMoviesState('error connection'),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );
}
