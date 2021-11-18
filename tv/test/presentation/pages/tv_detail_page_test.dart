import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:tv/presentation/widgets/poster_image.dart';
import 'package:tv/tv.dart';

import '../../dummy/tv_dummy_objects.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailNotifier])
void main() {
  late MockTvDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
          home: body,
          onGenerateRoute: (settings) {
            if (TvDetailPage.ROUTE_NAME == settings.name) {
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            }
            return MaterialPageRoute(builder: (_) => Container());
          }),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });
  testWidgets('display circular indicator when loading ',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loading);

    final progressIndicator = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(progressIndicator, findsOneWidget);
  });
  testWidgets('display test error message when error state',
      (WidgetTester tester) async {
    when(mockNotifier.message).thenReturn("Failed");
    when(mockNotifier.tvState).thenReturn(RequestState.Error);
    final erorrText = find.byTooltip('error message');

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    expect(erorrText, findsOneWidget);
  });
  testWidgets('should display sizedbox when recomendation empty',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Empty);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    final findEmptyWidget = find.byTooltip('Recommendation empty');

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(findEmptyWidget, findsOneWidget);
  });
  testWidgets('should display loading widget when recomendation loading',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loading);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    final findLoadingWidget = find.byTooltip('Recommendation loading');
    final findPosterImsge = find.byType(PosterImage);
    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(findLoadingWidget, findsOneWidget);
    expect(findPosterImsge, findsWidgets);
  });
  testWidgets(
      'should display error text message widget when recomendation error state',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);

    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Error);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.message).thenReturn('Recommendation error');

    final findErrorWidget = find.byTooltip('Recommendation error');
    final backButton = find.byIcon(Icons.arrow_back);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(findErrorWidget, findsOneWidget);
    await tester.tap(backButton);
  });
  testWidgets(
      'should display recommendation list widget when recomendation loaded state',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[testTv]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final findPosterImage = find.byType(PosterImage);
    final findRecommendationList = find.byTooltip('Recommendation list');
    final findClip = find.byType(ClipRRect);
    final findInkwell = find.byTooltip("Recommendation item 1");

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));
    expect(findClip, findsWidgets);
    expect(findInkwell, findsOneWidget);
    await tester.dragUntilVisible(
      findInkwell, // what you want to find
      find.byType(DraggableScrollableSheet), // widget you want to scroll
      const Offset(0, 50), // delta to move
    );
    await tester.pump();
    expect(findPosterImage, findsWidgets);

    expect(findRecommendationList, findsOneWidget);
    // await tester.scrollUntilVisible(findInkwell, 200, maxScrolls: 1000);
    await tester.tap(findInkwell);
    await tester.pump();
  });
  testWidgets(
      'should display last airing season widget when recomendation loaded state',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[testTv]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final findPosterImage = find.byType(PosterImage);
    final lastAiringCard = find.byTooltip('last airing season');

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    await tester.dragUntilVisible(
      lastAiringCard, // what you want to find
      find.byType(DraggableScrollableSheet), // widget you want to scroll
      const Offset(0, 50), // delta to move
    );
    await tester.pump();
    expect(findPosterImage, findsWidgets);

    expect(lastAiringCard, findsOneWidget);
    // await tester.scrollUntilVisible(findInkwell, 200, maxScrolls: 1000);
    await tester.tap(lastAiringCard);
    await tester.pump();
  });

  testWidgets(
      'should not  display last airing season widget when recomendation loaded state but haven\'t last airing season',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);

    when(mockNotifier.tv).thenReturn(testTvDetail2);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[testTv]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final lastAiringCard = find.byTooltip('last airing season');

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(lastAiringCard, findsNothing);
  });

  testWidgets(
      'should tap show more last airing season widget when loaded state',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[testTv]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final lastAiringButton = find.byIcon(Icons.remove_red_eye_outlined);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    await tester.dragUntilVisible(
      lastAiringButton, // what you want to find
      find.byType(DraggableScrollableSheet), // widget you want to scroll
      const Offset(0, 50), // delta to move
    );
    await tester.pump();

    expect(lastAiringButton, findsOneWidget);
    // await tester.scrollUntilVisible(findInkwell, 200, maxScrolls: 1000);
    await tester.tap(lastAiringButton);
    await tester.pump();
  });
  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when tv is added to wathclist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });
  testWidgets(
      'Watchlist button should display Snackbar when removed from watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);
    when(mockNotifier.watchlistMessage).thenReturn('Removed from Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
