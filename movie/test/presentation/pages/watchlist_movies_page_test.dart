import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/cubit/watchlist_movies/watchlist_movies_cubit.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';

import '../../dummy/dummy_objects.dart';

class MockWatchlistMoviesCubit extends MockCubit<WatchlistMoviesState>
    implements WatchlistMoviesCubit {}

class FakeLoadingWatchlistMoviesState extends Fake
    implements LoadingWatchlistMoviesState {}

class FakeLoadedWatchlistMoviesState extends Fake
    implements LoadedWatchlistMoviesState {}

class FakeErrorWatchlistMoviesState extends Fake
    implements ErrorWatchlistMoviesState {}

void main() {
  late MockWatchlistMoviesCubit mockCubit;
  setUpAll(() {
    registerFallbackValue(FakeLoadingWatchlistMoviesState());
    registerFallbackValue(FakeLoadedWatchlistMoviesState());
    registerFallbackValue(FakeErrorWatchlistMoviesState());
  });
  setUp(() {
    mockCubit = MockWatchlistMoviesCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMoviesCubit>(
      create: (context) => mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    final testData = LoadingWatchlistMoviesState();

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadWatchlistMovies())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView with MovieCard when data is loaded',
      (WidgetTester tester) async {
    final testData = LoadedWatchlistMoviesState(
      [testMovie],
    );
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadWatchlistMovies())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final listViewFinder = find.byType(ListView);
    final movieCardFinder = find.byType(MovieCard);

    await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

    expect(listViewFinder, findsOneWidget);
    expect(movieCardFinder, findsWidgets);
  });

  testWidgets('Page should display Text when data is loaded but empty',
      (WidgetTester tester) async {
    const testData = LoadedWatchlistMoviesState(
      [],
    );
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadWatchlistMovies())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final textFinder = find.text("you don't have any watchlist yet");

    await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const testData = ErrorWatchlistMoviesState('cannot connect');
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadWatchlistMovies())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
