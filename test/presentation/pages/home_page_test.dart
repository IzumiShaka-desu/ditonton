import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_page.dart';
import 'package:ditonton/presentation/pages/movie/home_movie_page.dart';
import 'package:ditonton/presentation/pages/movie/search_page.dart';
import 'package:ditonton/presentation/pages/tv/home_tv_page.dart';
import 'package:ditonton/presentation/provider/movie/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/movie/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/movie/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/movie/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/tv/popular_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/tv/top_rated_tv_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_search_notifier.dart';
import 'package:ditonton/presentation/provider/tv/watch_list_tv_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'home_page_test.mocks.dart';

@GenerateMocks([
  MovieListNotifier,
  MovieDetailNotifier,
  MovieSearchNotifier,
  TopRatedMoviesNotifier,
  PopularMoviesNotifier,
  WatchlistMovieNotifier,
  TvListNotifier,
  TvDetailNotifier,
  TvSearchNotifier,
  TopRatedTvsNotifier,
  PopularTvsNotifier,
  WatchlistTvNotifier
])
void main() {
  late MovieListNotifier mockMovieListNotifier;
  late MovieDetailNotifier mockMovieDetailNotifier;
  late MovieSearchNotifier mockSearchNotifier;
  late TopRatedMoviesNotifier mockTopRatedMoviesNotifier;
  late PopularMoviesNotifier mockPopularMoviesNotifier;
  late WatchlistMovieNotifier mockWatchListMovieNotifier;
  late TvListNotifier mockTvListNotifier;
  late TvDetailNotifier mockDetailNotifier;
  late TvSearchNotifier mockTvSearchNotifier;
  late TopRatedTvsNotifier mockTopRatedTvsNotifier;
  late PopularTvsNotifier mockPopularTvsNotifier;
  late WatchlistTvNotifier mockWatchlistTvNotifier;

  setUp(() {
    mockMovieListNotifier = MockMovieListNotifier();
    mockMovieDetailNotifier = MockMovieDetailNotifier();
    mockSearchNotifier = MockMovieSearchNotifier();
    mockTopRatedMoviesNotifier = MockTopRatedMoviesNotifier();
    mockPopularMoviesNotifier = MockPopularMoviesNotifier();
    mockWatchListMovieNotifier = MockWatchlistMovieNotifier();
    mockTvListNotifier = MockTvListNotifier();
    mockDetailNotifier = MockTvDetailNotifier();
    mockTvSearchNotifier = MockTvSearchNotifier();
    mockTopRatedTvsNotifier = MockTopRatedTvsNotifier();
    mockPopularTvsNotifier = MockPopularTvsNotifier();
    mockWatchlistTvNotifier = MockWatchlistTvNotifier();
  });
  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => mockPopularMoviesNotifier,
        ),
        ChangeNotifierProvider(
          create: (_) => mockTopRatedMoviesNotifier,
        ),
        ChangeNotifierProvider(
          create: (_) => mockSearchNotifier,
        ),
        ChangeNotifierProvider(
          create: (_) => mockMovieListNotifier,
        ),
        ChangeNotifierProvider(
          create: (_) => mockMovieDetailNotifier,
        ),
        ChangeNotifierProvider(
          create: (_) => mockWatchListMovieNotifier,
        ),
        ChangeNotifierProvider(
          create: (_) => mockTvListNotifier,
        ),
        ChangeNotifierProvider(
          create: (_) => mockDetailNotifier,
        ),
        ChangeNotifierProvider(
          create: (_) => mockTvSearchNotifier,
        ),
        ChangeNotifierProvider(
          create: (_) => mockTopRatedTvsNotifier,
        ),
        ChangeNotifierProvider(
          create: (_) => mockPopularTvsNotifier,
        ),
        ChangeNotifierProvider(
          create: (_) => mockWatchlistTvNotifier,
        ),
      ],
      child: MaterialApp(
          home: body,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case SearchPage.ROUTE_NAME:
                return CupertinoPageRoute(builder: (_) => SearchPage());
              case AboutPage.ROUTE_NAME:
                return CupertinoPageRoute(builder: (_) => AboutPage());
            }
          }),
    );
  }

  testWidgets('Page should display tv home page and go to search',
      (WidgetTester tester) async {
    when(mockMovieListNotifier.nowPlayingState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockMovieListNotifier.topRatedMoviesState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockMovieListNotifier.popularMoviesState)
        .thenAnswer((_) => RequestState.Loading);

    when(mockTvListNotifier.nowPlayingState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockTvListNotifier.topRatedTvsState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockTvListNotifier.popularTvsState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockSearchNotifier.state).thenAnswer((_) => RequestState.Loading);
    final homePage = find.byType(HomeMoviePage);

    final menuTvSeries = find.byTooltip('menu Tv Series');
    await tester.pumpWidget(
      _makeTestableWidget(HomePage()),
    );
    expect(homePage, findsOneWidget);
    expect(menuTvSeries, findsOneWidget);

    await tester.tap(menuTvSeries);
    await tester.pump();
    final homeTvPage = find.byType(HomeTvPage);
    final backButton = find.widgetWithIcon(IconButton, Icons.chevron_left);
    expect(homeTvPage, findsOneWidget);
    expect(backButton, findsOneWidget);
    await tester.tap(backButton);
    await tester.pump();
    final menuMovie = find.byTooltip('menu Movie');
    expect(menuMovie, findsOneWidget);
    await tester.tap(menuMovie);
    await tester.pump();
    final searchButton = find.widgetWithIcon(IconButton, Icons.search);
    expect(searchButton, findsOneWidget);
    await tester.tap(searchButton);
    await tester.pump();
  });

  testWidgets('Page should display tv home page and go to search',
      (WidgetTester tester) async {
    when(mockMovieListNotifier.nowPlayingState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockMovieListNotifier.topRatedMoviesState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockMovieListNotifier.popularMoviesState)
        .thenAnswer((_) => RequestState.Loading);

    when(mockTvListNotifier.nowPlayingState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockTvListNotifier.topRatedTvsState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockTvListNotifier.popularTvsState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockSearchNotifier.state).thenAnswer((_) => RequestState.Loading);

    final finder = find.byTooltip('open drawer menu');
    await tester.pumpWidget(
      _makeTestableWidget(HomePage()),
    );
    await tester.tap(finder);
    await tester.pump();
  });
  testWidgets('test open drawer', (WidgetTester tester) async {
    when(mockMovieListNotifier.nowPlayingState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockMovieListNotifier.topRatedMoviesState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockMovieListNotifier.popularMoviesState)
        .thenAnswer((_) => RequestState.Loading);

    when(mockTvListNotifier.nowPlayingState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockTvListNotifier.topRatedTvsState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockTvListNotifier.popularTvsState)
        .thenAnswer((_) => RequestState.Loading);
    when(mockSearchNotifier.state).thenAnswer((_) => RequestState.Loading);

    final finder = find.byTooltip('open drawer menu');
    await tester.pumpWidget(
      _makeTestableWidget(HomePage()),
    );
    await tester.tap(finder);
    await tester.pump(Duration(seconds: 1));
    await tester.dragFrom(
        tester.getTopRight(find.byType(Scaffold).first), Offset(-300, 0));
    await tester.pump(Duration(seconds: 1));

    final aboutMenu = find.widgetWithText(ListTile, "About");
    expect(aboutMenu, findsOneWidget);
    await tester.tap(aboutMenu);
  });
}
