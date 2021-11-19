import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/widgets/poster_image.dart';
import 'package:tv/tv.dart';

import '../../dummy/tv_dummy_objects.dart';
import 'home_tv_page_test.mocks.dart';

main() {
  late MockTvListNotifier mockNotifier;
  setUp(() {
    mockNotifier = MockTvListNotifier();
  });
  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvListNotifier>.value(
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
      when(mockNotifier.nowPlayingTvs).thenAnswer((_) => [testTv]);

      when(mockNotifier.popularTvsState)
          .thenAnswer((_) => RequestState.Loading);

      when(mockNotifier.topRatedTvsState)
          .thenAnswer((_) => RequestState.Loading);

      await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));
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
    when(mockNotifier.popularTvsState).thenAnswer((_) => RequestState.Loading);
    when(mockNotifier.topRatedTvsState).thenAnswer((_) => RequestState.Loading);
    var findCircularProgress = find.byType(CircularProgressIndicator);

    var textFailedFinder = find.byTooltip('failed to load tvs');
    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));
    expect(findCircularProgress, findsWidgets);
    expect(textFailedFinder, findsOneWidget);
  });
  testWidgets(
      'should display text failed when popular section state is empty or error',
      (tester) async {
    when(mockNotifier.nowPlayingState).thenAnswer((_) => RequestState.Loading);
    when(mockNotifier.popularTvsState).thenAnswer((_) => RequestState.Error);
    when(mockNotifier.topRatedTvsState).thenAnswer((_) => RequestState.Loading);

    var textFailedFinder = find.byTooltip('failed to load tvs');
    var findCircularProgress = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));
    expect(findCircularProgress, findsWidgets);
    expect(textFailedFinder, findsOneWidget);
  });
  testWidgets(
      'should display text failed when top rated section state is empty or error',
      (tester) async {
    when(mockNotifier.nowPlayingState).thenAnswer((_) => RequestState.Loading);
    when(mockNotifier.popularTvsState).thenAnswer((_) => RequestState.Loading);
    when(mockNotifier.topRatedTvsState).thenAnswer((_) => RequestState.Error);
    var findCircularProgress = find.byType(CircularProgressIndicator);
    var textFailedFinder = find.byTooltip('failed to load tvs');
    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));
    expect(textFailedFinder, findsOneWidget);
    expect(findCircularProgress, findsWidgets);
  });
  testWidgets('should display tv when now playing section state is loaded',
      (tester) async {
    when(mockNotifier.nowPlayingState).thenAnswer((_) => RequestState.Loaded);
    when(mockNotifier.nowPlayingTvs).thenAnswer((_) => [testTv]);
    when(mockNotifier.popularTvsState).thenAnswer((_) => RequestState.Loading);
    when(mockNotifier.topRatedTvsState).thenAnswer((_) => RequestState.Loading);
    var findCircularProgress = find.byType(CircularProgressIndicator);

    var posterImageFinder = find.byType(PosterImage);
    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));
    expect(findCircularProgress, findsWidgets);
    expect(posterImageFinder, findsOneWidget);
  });
  testWidgets('should tv card failed when popular section state is loaded',
      (tester) async {
    when(mockNotifier.nowPlayingState).thenAnswer((_) => RequestState.Loading);
    when(mockNotifier.popularTvsState).thenAnswer((_) => RequestState.Loaded);
    when(mockNotifier.popularTvs).thenAnswer((_) => [testTv]);

    when(mockNotifier.topRatedTvsState).thenAnswer((_) => RequestState.Loading);

    var posterImageFinder = find.byType(PosterImage);

    var findCircularProgress = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));
    expect(findCircularProgress, findsWidgets);
    expect(posterImageFinder, findsOneWidget);
  });
  testWidgets('should display tv card when top rated section state is loaded',
      (tester) async {
    when(mockNotifier.nowPlayingState).thenAnswer((_) => RequestState.Loading);

    when(mockNotifier.popularTvsState).thenAnswer((_) => RequestState.Loading);
    when(mockNotifier.topRatedTvsState).thenAnswer((_) => RequestState.Loaded);
    when(mockNotifier.topRatedTvs).thenAnswer((_) => [testTv]);

    var findCircularProgress = find.byType(CircularProgressIndicator);
    var posterImageFinder = find.byType(PosterImage);

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));
    expect(posterImageFinder, findsOneWidget);
    expect(findCircularProgress, findsWidgets);
  });
}
