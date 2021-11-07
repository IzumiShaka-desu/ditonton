import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tvs_page.dart';
import 'package:ditonton/presentation/pages/watchlist_home_page.dart';
import 'package:ditonton/presentation/provider/movie/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/tv/watch_list_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../provider/movie/watchlist_movie_notifier_test.mocks.dart';
import '../../provider/tv/watch_list_tv_notifier_test.mocks.dart';
import '../home_page_test.mocks.dart';

@GenerateMocks([WatchlistTvNotifier, WatchlistMovieNotifier])
void main() {
  late WatchlistMovieNotifier watchlistMovieNotifier;
  late WatchlistTvNotifier watchlistTvNotifier;
  setUp(() {
    watchlistTvNotifier = MockWatchlistTvNotifier();
    watchlistMovieNotifier = MockWatchlistMovieNotifier();
  });
  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => watchlistMovieNotifier,
        ),
        ChangeNotifierProvider(
          create: (ctx) => watchlistTvNotifier,
        )
      ],
      child: MaterialApp(
        home: Material(child: body),
      ),
    );
  }

  testWidgets('test watchlist homepage behaviour', (widgetTester) async {
    when(watchlistMovieNotifier.watchlistState)
        .thenAnswer((_) => RequestState.Loading);
    when(watchlistTvNotifier.watchlistState)
        .thenAnswer((_) => RequestState.Loading);
    final tab = find.widgetWithText(Tab, "Tv Series");
    await widgetTester.pumpWidget(_makeTestableWidget(WathcListHomePage()));
    expect(tab, findsOneWidget);
    await widgetTester.tap(tab);
    await widgetTester.pump();
  });
}
