import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/cubit/watchlist_movies/watchlist_movies_cubit.dart';
import 'package:tv/presentation/bloc/cubit/watchlist_tvs/watchlist_tvs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockWatchlistTvsCubit extends MockCubit<WatchlistTvsState>
    implements WatchlistTvsCubit {}

class FakeLoadingWatchlistTvsState extends Fake
    implements LoadingWatchlistTvsState {}

class FakeLoadedWatchlistTvsState extends Fake
    implements LoadedWatchlistTvsState {}

class FakeErrorWatchlistTvsState extends Fake
    implements ErrorWatchlistTvsState {}

class MockWatchlistMoviesCubit extends MockCubit<WatchlistMoviesState>
    implements WatchlistMoviesCubit {}

class FakeLoadingWatchlistMoviesState extends Fake
    implements LoadingWatchlistMoviesState {}

class FakeLoadedWatchlistMoviesState extends Fake
    implements LoadedWatchlistMoviesState {}

class FakeErrorWatchlistMoviesState extends Fake
    implements ErrorWatchlistMoviesState {}

void main() {
  late WatchlistMoviesCubit watchlistMovieCubit;
  late WatchlistTvsCubit watchlistTvCubit;
  setUpAll(() {
    registerFallbackValue(FakeLoadingWatchlistTvsState());
    registerFallbackValue(FakeLoadedWatchlistTvsState());
    registerFallbackValue(FakeErrorWatchlistTvsState());
    registerFallbackValue(FakeLoadingWatchlistMoviesState());
    registerFallbackValue(FakeLoadedWatchlistMoviesState());
    registerFallbackValue(FakeErrorWatchlistMoviesState());
  });
  setUp(() {
    watchlistTvCubit = MockWatchlistTvsCubit();
    watchlistMovieCubit = MockWatchlistMoviesCubit();
  });
  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => watchlistMovieCubit,
        ),
        BlocProvider(
          create: (ctx) => watchlistTvCubit,
        )
      ],
      child: MaterialApp(
        home: Material(child: body),
      ),
    );
  }

  testWidgets('test watchlist homepage behaviour', (widgetTester) async {
    final testData = LoadingWatchlistMoviesState();

    when(() => watchlistMovieCubit.state).thenAnswer((_) => testData);
    when(() => watchlistMovieCubit.loadWatchlistMovies())
        .thenAnswer((invocation) async => invocation);
    whenListen(watchlistMovieCubit, Stream.fromIterable([testData]));
    final testData2 = LoadingWatchlistTvsState();

    when(() => watchlistTvCubit.state).thenAnswer((_) => testData2);
    when(() => watchlistTvCubit.loadWatchlistTvs())
        .thenAnswer((invocation) async => invocation);
    whenListen(watchlistTvCubit, Stream.fromIterable([testData2]));
    final tab = find.widgetWithText(Tab, "Tv Series");
    await widgetTester
        .pumpWidget(_makeTestableWidget(const WathcListHomePage()));
    expect(tab, findsOneWidget);
    await widgetTester.tap(tab);
    await widgetTester.pump();
  });
}
