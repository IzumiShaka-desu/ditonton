import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/cubit/top_rated_movies/top_rated_movies_cubit.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';
import 'package:provider/provider.dart';

import '../../dummy/dummy_objects.dart';

class MockTopRatedMoviesCubit extends MockCubit<TopRatedMoviesState>
    implements TopRatedMoviesCubit {}

class FakeLoadingTopRatedMoviesState extends Fake
    implements LoadingTopRatedMoviesState {}

class FakeLoadedTopRatedMoviesState extends Fake
    implements LoadedTopRatedMoviesState {}

class FakeErrorTopRatedMoviesState extends Fake
    implements ErrorTopRatedMoviesState {}

void main() {
  late MockTopRatedMoviesCubit mockCubit;
  setUpAll(() {
    registerFallbackValue(FakeLoadingTopRatedMoviesState());
    registerFallbackValue(FakeLoadedTopRatedMoviesState());
    registerFallbackValue(FakeErrorTopRatedMoviesState());
  });
  setUp(() {
    mockCubit = MockTopRatedMoviesCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesCubit>(
      create: (context) => mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    final testData = LoadingTopRatedMoviesState();

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadTopRatedMovies())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView with MovieCard when data is loaded',
      (WidgetTester tester) async {
    final testData = LoadedTopRatedMoviesState(
      [testMovie],
    );
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadTopRatedMovies())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final listViewFinder = find.byType(ListView);
    final movieCardFinder = find.byType(MovieCard);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
    expect(movieCardFinder, findsWidgets);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const testData = ErrorTopRatedMoviesState('cannot connect');
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadTopRatedMovies())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
