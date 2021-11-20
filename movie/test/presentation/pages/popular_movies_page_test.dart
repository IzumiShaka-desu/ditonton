import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/cubit/popular_movies/popular_movies_cubit.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';

import '../../dummy/dummy_objects.dart';

class MockPopularMoviesCubit extends MockCubit<PopularMoviesState>
    implements PopularMoviesCubit {}

class FakeLoadingPopularMoviesState extends Fake
    implements LoadingPopularMoviesState {}

class FakeLoadedPopularMoviesState extends Fake
    implements LoadedPopularMoviesState {}

class FakeErrorPopularMoviesState extends Fake
    implements ErrorPopularMoviesState {}

void main() {
  late MockPopularMoviesCubit mockCubit;
  setUpAll(() {
    registerFallbackValue(FakeLoadingPopularMoviesState());
    registerFallbackValue(FakeLoadedPopularMoviesState());
    registerFallbackValue(FakeErrorPopularMoviesState());
  });
  setUp(() {
    mockCubit = MockPopularMoviesCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesCubit>(
      create: (BuildContext context) => mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    final testData = LoadingPopularMoviesState();

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadPopularMovies())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView with MovieCard when data is loaded',
      (WidgetTester tester) async {
    final testData = LoadedPopularMoviesState(
      [testMovie],
    );
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadPopularMovies())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final listViewFinder = find.byType(ListView);
    final movieCardFinder = find.byType(MovieCard);

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
    expect(movieCardFinder, findsWidgets);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const testData = ErrorPopularMoviesState('cannot connect');
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadPopularMovies())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
