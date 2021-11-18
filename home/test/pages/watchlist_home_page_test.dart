import 'package:core/core.dart';
import 'package:home/home.dart';
import 'package:movie/presentation/provider/watchlist_movie_notifier.dart';
import 'package:tv/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'watchlist_home_page_test.mocks.dart';

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
    await widgetTester
        .pumpWidget(_makeTestableWidget(const WathcListHomePage()));
    expect(tab, findsOneWidget);
    await widgetTester.tap(tab);
    await widgetTester.pump();
  });
}
