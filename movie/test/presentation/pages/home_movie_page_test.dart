import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/cubit/movie_list/movie_list_cubit.dart';
import 'package:movie/presentation/widgets/poster_image.dart';

import '../../dummy/dummy_objects.dart';

class MockMovieListCubit extends MockCubit<MovieListState>
    implements MovieListCubit {}

class FakeLoadingMovieListState extends Fake implements LoadingMovieListState {}

class FakeLoadedMovieListState extends Fake implements LoadedMovieListState {}

class FakeErrorMovieListState extends Fake implements ErrorMovieListState {}

main() {
  late MovieListCubit mockCubit;
  setUpAll(() {
    registerFallbackValue(FakeLoadingMovieListState());
    registerFallbackValue(FakeLoadedMovieListState());
    registerFallbackValue(FakeErrorMovieListState());
  });
  setUp(() {
    mockCubit = MockMovieListCubit();
  });
  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieListCubit>(
      create: (context) => mockCubit,
      child: MaterialApp(
        home: body,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (ctx) => body,
        ),
      ),
    );
  }

  // testWidgets('description', (widgetTester) async {
  //   final testData = LoadedMovieListState(
  //     nowPlaying: [testMovie],
  //     topRated: [testMovie],
  //     popular: [testMovie],
  //   );
  //   when(() => mockCubit.state).thenAnswer((_) => testData);
  //   when(() => mockCubit.loadMovieList())
  //       .thenAnswer((invocation) async => invocation);
  //   whenListen(mockCubit, Stream.fromIterable([testData]));
  //   await widgetTester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
  // });
  group('verify tap behaviour', () {
    setUp(() {
      final testData = LoadedMovieListState(
        nowPlaying: [testMovie],
        topRated: [testMovie],
        popular: [testMovie],
      );
      when(() => mockCubit.state).thenAnswer((_) => testData);
      when(() => mockCubit.loadMovieList())
          .thenAnswer((invocation) async => invocation);
      whenListen(mockCubit, Stream.fromIterable([testData]));
    });
    testWidgets('navigate to popular', (widgetTester) async {
      await widgetTester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      var popular = find.byTooltip("navigate to Popular");
      expect(popular, findsOneWidget);
      await widgetTester.tap(popular);
      await widgetTester.pump();
    });
    testWidgets('navigate to top rated ', (tester) async {
      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      var topRated = find.byTooltip("navigate to Top Rated");
      expect(topRated, findsOneWidget);
      await tester.tap(topRated);
      await tester.pump();
    });
    testWidgets('itemlist ', (tester) async {
      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      var itemList = find.byType(ClipRRect);

      expect(itemList, findsWidgets);
      await tester.tap(itemList.first);
      await tester.pump();
    });
  });
  // group('verify tap behaviour', () {
  //   // setUp(() {
  //   when(
  //     () => mockCubit.state,
  //   ).thenReturn(LoadedMovieListState(
  //     nowPlaying: [testMovie],
  //     topRated: [testMovie],
  //     popular: [testMovie],
  //   ));
  //   whenListen(
  //     mockCubit,
  //     Stream.fromIterable([
  //       LoadedMovieListState(
  //         nowPlaying: [testMovie],
  //         topRated: [testMovie],
  //         popular: [testMovie],
  //       )
  //     ]),
  //   );
  //   // });
  //   _pumpWidget(WidgetTester tester) async {
  //     return await tester.pumpWidget(
  //       _makeTestableWidget(
  //         const HomeMoviePage(),
  //       ),
  //     );
  //   }

  //   testWidgets('navigate to popular ', (tester) async {
  //     await _pumpWidget(tester);
  //     var popular = find.byTooltip("navigate to Popular");
  //     expect(popular, findsOneWidget);
  //     await tester.tap(popular);
  //     await tester.pump();
  //   });
  //   testWidgets('navigate to top rated ', (tester) async {
  //     await _pumpWidget(tester);
  //     var topRated = find.byTooltip("navigate to Top Rated");
  //     expect(topRated, findsOneWidget);
  //     await tester.tap(topRated);
  //     await tester.pump();
  //   });
  //   testWidgets('itemlist ', (tester) async {
  //     await _pumpWidget(tester);
  //     var itemList = find.byType(ClipRRect);

  //     expect(itemList, findsOneWidget);
  //     await tester.tap(itemList);
  //     await tester.pump();
  //   });
  // });
  group('now playing not loaded', () {
    final testData = LoadedMovieListState(
      popular: [testMovie],
      nowPlaying: const [],
      topRated: [testMovie],
    );
    setUp(() {
      when(() => mockCubit.state).thenAnswer((_) => testData);
      when(() => mockCubit.loadMovieList())
          .thenAnswer((invocation) async => invocation);
      whenListen(mockCubit, Stream.fromIterable([testData]));
    });
    testWidgets(
        'should display text failed when now playing section state is empty or error',
        (tester) async {
      var findCircularProgress = find.byType(CircularProgressIndicator);

      var textFailedFinder = find.byTooltip('failed to load movies');
      await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));
      expect(findCircularProgress, findsWidgets);
      expect(textFailedFinder, findsOneWidget);
    });
  });
  group('popular not loaded', () {
    final testData = LoadedMovieListState(
      popular: const [],
      nowPlaying: [testMovie],
      topRated: [testMovie],
    );
    setUp(() {
      when(() => mockCubit.state).thenAnswer((_) => testData);
      when(() => mockCubit.loadMovieList())
          .thenAnswer((invocation) async => invocation);
      whenListen(mockCubit, Stream.fromIterable([testData]));
    });
    testWidgets(
        'should display text failed when popular section state is empty or error',
        (tester) async {
      var findCircularProgress = find.byType(CircularProgressIndicator);

      var textFailedFinder = find.byTooltip('failed to load movies');
      await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));
      expect(findCircularProgress, findsWidgets);
      expect(textFailedFinder, findsOneWidget);
    });
  });
  group('top rated not loaded', () {
    final testData = LoadedMovieListState(
      popular: [testMovie],
      nowPlaying: [testMovie],
      topRated: const [],
    );
    setUp(() {
      when(() => mockCubit.state).thenAnswer((_) => testData);
      when(() => mockCubit.loadMovieList())
          .thenAnswer((invocation) async => invocation);
      whenListen(mockCubit, Stream.fromIterable([testData]));
    });
    testWidgets(
        'should display text failed when top rated section state is empty or error',
        (tester) async {
      var findCircularProgress = find.byType(CircularProgressIndicator);

      var textFailedFinder = find.byTooltip('failed to load movies');
      await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));
      expect(findCircularProgress, findsWidgets);
      expect(textFailedFinder, findsOneWidget);
    });
  });
  group('error fetching all category', () {
    const testData = ErrorMovieListState('cannot establish connection');
    setUp(() {
      when(() => mockCubit.state).thenAnswer((_) => testData);
      when(() => mockCubit.loadMovieList())
          .thenAnswer((invocation) async => invocation);
      whenListen(mockCubit, Stream.fromIterable([testData]));
    });
    testWidgets(
        'should display text failed when top rated section state is empty or error',
        (tester) async {
      var textFailedFinder = find.text('cannot establish connection');
      var retryButton = find.text('Retry');
      await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));
      expect(textFailedFinder, findsOneWidget);
      expect(retryButton, findsOneWidget);
      await tester.tap(retryButton);
      await tester.pumpAndSettle();
      verify(mockCubit.loadMovieList);
    });
  });
  // testWidgets(
  //     'should display text failed when popular section state is empty or error',
  //     (tester) async {
  //   when(() => mockCubit.state).thenAnswer(
  //     (_) => LoadedMovieListState(
  //       nowPlaying: [testMovie],
  //       popular: const [],
  //       topRated: [testMovie],
  //     ),
  //   );

  //   var textFailedFinder = find.byTooltip('failed to load movies');
  //   var findCircularProgress = find.byType(CircularProgressIndicator);

  //   await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));
  //   expect(findCircularProgress, findsWidgets);
  //   expect(textFailedFinder, findsOneWidget);
  // });
  // testWidgets(
  //     'should display text failed when top rated section state is empty or error',
  //     (tester) async {
  //   when(() => mockCubit.state).thenAnswer(
  //     (_) => LoadedMovieListState(
  //       nowPlaying: [testMovie],
  //       topRated: const [],
  //       popular: [testMovie],
  //     ),
  //   );
  //   var findCircularProgress = find.byType(CircularProgressIndicator);
  //   var textFailedFinder = find.byTooltip('failed to load movies');
  //   await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));
  //   expect(textFailedFinder, findsOneWidget);
  //   expect(findCircularProgress, findsWidgets);
  // });
  // testWidgets('should display movie when now playing section state is loaded',
  //     (tester) async {
  //   when(() => mockCubit.state).thenAnswer(
  //     (_) => LoadedMovieListState(
  //       nowPlaying: [testMovie],
  //       popular: const [],
  //       topRated: const [],
  //     ),
  //   );
  //   var findCircularProgress = find.byType(CircularProgressIndicator);

  //   var posterImageFinder = find.byType(PosterImage);
  //   await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));
  //   expect(findCircularProgress, findsWidgets);
  //   expect(posterImageFinder, findsOneWidget);
  // });
  // testWidgets('should movie card failed when popular section state is loaded',
  //     (tester) async {
  //   when(() => mockCubit.state).thenAnswer(
  //     (_) => LoadedMovieListState(
  //       nowPlaying: const [],
  //       popular: [testMovie],
  //       topRated: const [],
  //     ),
  //   );
  //   var posterImageFinder = find.byType(PosterImage);

  //   var findCircularProgress = find.byType(CircularProgressIndicator);

  //   await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));
  //   expect(findCircularProgress, findsWidgets);
  //   expect(posterImageFinder, findsOneWidget);
  // });
  // testWidgets(
  //     'should display movie card when top rated section state is loaded',
  //     (tester) async {
  //   when(() => mockCubit.state).thenAnswer(
  //     (_) => LoadedMovieListState(
  //       nowPlaying: const [],
  //       popular: const [],
  //       topRated: [testMovie],
  //     ),
  //   );

  //   var findCircularProgress = find.byType(CircularProgressIndicator);
  //   var posterImageFinder = find.byType(PosterImage);

  //   await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
  //   expect(posterImageFinder, findsOneWidget);
  //   expect(findCircularProgress, findsWidgets);
  // });
}
