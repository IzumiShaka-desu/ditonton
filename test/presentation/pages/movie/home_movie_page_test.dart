import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/movie/home_movie_page.dart';
import 'package:ditonton/presentation/provider/movie/movie_list_notifier.dart';
import 'package:ditonton/presentation/widgets/poster_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'home_movie_page_test.mocks.dart';

@GenerateMocks([MovieListNotifier])
main() {
  late MockMovieListNotifier mockNotifier;
  setUp(() {
    mockNotifier = MockMovieListNotifier();
  });
  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieListNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (ctx) => body,
        ),
      ),
    );
  }

  group('verify tap behaviour', () {
    _pumpWidget(tester) async {
      when(mockNotifier.nowPlayingState).thenAnswer((_) => RequestState.Loaded);
      when(mockNotifier.nowPlayingMovies).thenAnswer((_) => [testMovie]);

      when(mockNotifier.popularMoviesState)
          .thenAnswer((_) => RequestState.Loading);

      when(mockNotifier.topRatedMoviesState)
          .thenAnswer((_) => RequestState.Loading);

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
    }

    testWidgets('navigate to popular ', (tester) async {
      await _pumpWidget(tester);
      var popular = find.byTooltip("navigate to Popular");
      expect(popular, findsOneWidget);
      await tester.tap(popular);
      await tester.pump();
    });
    testWidgets('navigate to top rated ', (tester) async {
      await _pumpWidget(tester);
      var topRated = find.byTooltip("navigate to Top Rated");
      expect(topRated, findsOneWidget);
      await tester.tap(topRated);
      await tester.pump();
    });
    testWidgets('itemlist ', (tester) async {
      await _pumpWidget(tester);
      var itemList = find.byType(ClipRRect);

      expect(itemList, findsOneWidget);
      await tester.tap(itemList);
      await tester.pump();
    });
  });
  testWidgets(
      'should display text failed when now playing section state is empty or error',
      (tester) async {
    when(mockNotifier.nowPlayingState).thenAnswer((_) => RequestState.Error);
    when(mockNotifier.popularMoviesState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockNotifier.topRatedMoviesState)
        .thenAnswer((_) => RequestState.Loading);
    var findCircularProgress = find.byType(CircularProgressIndicator);

    var textFailedFinder = find.byTooltip('failed to load movies');
    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
    expect(findCircularProgress, findsWidgets);
    expect(textFailedFinder, findsOneWidget);
  });
  testWidgets(
      'should display text failed when popular section state is empty or error',
      (tester) async {
    when(mockNotifier.nowPlayingState).thenAnswer((_) => RequestState.Loading);
    when(mockNotifier.popularMoviesState).thenAnswer((_) => RequestState.Error);
    when(mockNotifier.topRatedMoviesState)
        .thenAnswer((_) => RequestState.Loading);

    var textFailedFinder = find.byTooltip('failed to load movies');
    var findCircularProgress = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
    expect(findCircularProgress, findsWidgets);
    expect(textFailedFinder, findsOneWidget);
  });
  testWidgets(
      'should display text failed when top rated section state is empty or error',
      (tester) async {
    when(mockNotifier.nowPlayingState).thenAnswer((_) => RequestState.Loading);
    when(mockNotifier.popularMoviesState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockNotifier.topRatedMoviesState)
        .thenAnswer((_) => RequestState.Error);
    var findCircularProgress = find.byType(CircularProgressIndicator);
    var textFailedFinder = find.byTooltip('failed to load movies');
    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
    expect(textFailedFinder, findsOneWidget);
    expect(findCircularProgress, findsWidgets);
  });
  testWidgets('should display movie when now playing section state is loaded',
      (tester) async {
    when(mockNotifier.nowPlayingState).thenAnswer((_) => RequestState.Loaded);
    when(mockNotifier.nowPlayingMovies).thenAnswer((_) => [testMovie]);
    when(mockNotifier.popularMoviesState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockNotifier.topRatedMoviesState)
        .thenAnswer((_) => RequestState.Loading);
    var findCircularProgress = find.byType(CircularProgressIndicator);

    var posterImageFinder = find.byType(PosterImage);
    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
    expect(findCircularProgress, findsWidgets);
    expect(posterImageFinder, findsOneWidget);
  });
  testWidgets('should movie card failed when popular section state is loaded',
      (tester) async {
    when(mockNotifier.nowPlayingState).thenAnswer((_) => RequestState.Loading);
    when(mockNotifier.popularMoviesState)
        .thenAnswer((_) => RequestState.Loaded);
    when(mockNotifier.popularMovies).thenAnswer((_) => [testMovie]);

    when(mockNotifier.topRatedMoviesState)
        .thenAnswer((_) => RequestState.Loading);

    var posterImageFinder = find.byType(PosterImage);

    var findCircularProgress = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
    expect(findCircularProgress, findsWidgets);
    expect(posterImageFinder, findsOneWidget);
  });
  testWidgets(
      'should display movie card when top rated section state is loaded',
      (tester) async {
    when(mockNotifier.nowPlayingState).thenAnswer((_) => RequestState.Loading);

    when(mockNotifier.popularMoviesState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockNotifier.topRatedMoviesState)
        .thenAnswer((_) => RequestState.Loaded);
    when(mockNotifier.topRatedMovies).thenAnswer((_) => [testMovie]);

    var findCircularProgress = find.byType(CircularProgressIndicator);
    var posterImageFinder = find.byType(PosterImage);

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
    expect(posterImageFinder, findsOneWidget);
    expect(findCircularProgress, findsWidgets);
  });
}
