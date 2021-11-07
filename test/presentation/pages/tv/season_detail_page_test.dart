import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/presentation/pages/tv/season_detail_page.dart';
import 'package:ditonton/presentation/provider/tv/season_detail_notifier.dart';
import 'package:ditonton/presentation/widgets/episode_card.dart';
import 'package:ditonton/presentation/widgets/poster_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/tv_dummy_objects.dart';
import 'season_detail_page_test.mocks.dart';

@GenerateMocks([SeasonDetailNotifier])
void main() {
  late SeasonDetailNotifier seasonDetailNotifier;
  setUp(() {
    seasonDetailNotifier = MockSeasonDetailNotifier();
  });
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<SeasonDetailNotifier>(
            create: (ctx) => seasonDetailNotifier,
          ),
        ],
        child: body,
      ),
    );
  }

  var testSeason = Season(id: 1);
  testWidgets(
      'verify season detail page behaviour when season property not complete',
      (widgetTester) async {
    when(seasonDetailNotifier.seasonState)
        .thenAnswer((_) => RequestState.Loading);
    when(seasonDetailNotifier.message).thenAnswer((_) => '');
    await widgetTester.pumpWidget(_makeTestableWidget(
      SeasonDetailPage(
        coverImageUrl: testTvDetail.posterPath,
        season: testSeason,
        tvId: testTvDetail.id,
      ),
    ));

    final episodesListMenu = find.widgetWithText(Tab, "episodes");
    final progressFinder = find.byType(CircularProgressIndicator);
    expect(progressFinder, findsWidgets);
    when(seasonDetailNotifier.seasonState)
        .thenAnswer((_) => RequestState.Loaded);
    when(seasonDetailNotifier.season).thenAnswer((_) => testSeasonDetail);
    await widgetTester.pump();
    expect(episodesListMenu, findsWidgets);
    await widgetTester.tap(episodesListMenu.first);
    await widgetTester.pump();
    final posterImage = find.byType(PosterImage);
    expect(posterImage, findsWidgets);
    final backButton = find.widgetWithIcon(IconButton, Icons.arrow_back);
    await widgetTester.tap(backButton);
    await widgetTester.pump();
  });

  testWidgets('verify season detail page behaviour', (widgetTester) async {
    when(seasonDetailNotifier.seasonState)
        .thenAnswer((_) => RequestState.Loading);
    when(seasonDetailNotifier.message).thenAnswer((_) => '');

    await widgetTester.pumpWidget(_makeTestableWidget(
      SeasonDetailPage(
        coverImageUrl: testTvDetail.posterPath,
        season: testTvDetail.seasons.first,
        tvId: testTvDetail.id,
      ),
    ));

    final episodesListMenu = find.widgetWithText(Tab, "episodes");
    final progressFinder = find.byType(CircularProgressIndicator);
    expect(progressFinder, findsWidgets);
    when(seasonDetailNotifier.seasonState)
        .thenAnswer((_) => RequestState.Loaded);
    when(seasonDetailNotifier.season).thenAnswer((_) => testSeasonDetail);
    await widgetTester.pump();
    expect(episodesListMenu, findsWidgets);
    await widgetTester.tap(episodesListMenu.first);
    await widgetTester.pump();
    final posterImage = find.byType(PosterImage);
    expect(posterImage, findsWidgets);
    final backButton = find.widgetWithIcon(IconButton, Icons.arrow_back);
    await widgetTester.tap(backButton);
    await widgetTester.pump();
  });
  testWidgets('verify season detail page scroll behaviour ',
      (widgetTester) async {
    when(seasonDetailNotifier.message).thenAnswer((_) => '');

    var testData = testSeasonDetail;
    testData.episodes =
        List.generate(10, (index) => testSeasonDetail.episodes.first).toList();
    when(seasonDetailNotifier.season).thenAnswer((_) => testData);
    when(seasonDetailNotifier.seasonState)
        .thenAnswer((_) => RequestState.Loaded);
    await widgetTester.pumpWidget(_makeTestableWidget(
      SeasonDetailPage(
        coverImageUrl: testTvDetail.posterPath,
        season: testSeason,
        tvId: testTvDetail.id,
      ),
    ));

    final episodesListMenu = find.widgetWithText(Tab, "episodes");
    await widgetTester.pump();
    expect(episodesListMenu, findsWidgets);
    await widgetTester.tap(episodesListMenu.first);
    await widgetTester.pump();
    final posterImage = find.byType(PosterImage);
    expect(posterImage, findsWidgets);
    await widgetTester.dragUntilVisible(
        posterImage.last, find.byType(ListView).last, Offset(0, 100));
    await widgetTester.pump();
  });

  testWidgets('verify season detail page episode list when error state ',
      (widgetTester) async {
    when(seasonDetailNotifier.seasonState)
        .thenAnswer((_) => RequestState.Error);
    when(seasonDetailNotifier.message).thenAnswer((_) => "Failed");
    await widgetTester.pumpWidget(_makeTestableWidget(
      SeasonDetailPage(
        coverImageUrl: testTvDetail.posterPath,
        season: testSeason,
        tvId: testTvDetail.id,
      ),
    ));

    final episodesListMenu = find.byTooltip("navigate to episodes");

    await widgetTester.pump();
    expect(episodesListMenu, findsWidgets);
    await widgetTester.tap(episodesListMenu);
    await widgetTester.pump();
    final errorWidget = find.byTooltip('error message');
    expect(errorWidget, findsWidgets);
  });
  testWidgets('verify season detail page episode list when empty state ',
      (widgetTester) async {
    when(seasonDetailNotifier.message).thenAnswer((_) => '');

    when(seasonDetailNotifier.seasonState)
        .thenAnswer((_) => RequestState.Empty);
    await widgetTester.pumpWidget(_makeTestableWidget(
      SeasonDetailPage(
        coverImageUrl: testTvDetail.posterPath,
        season: testSeason,
        tvId: testTvDetail.id,
      ),
    ));

    final episodesListMenu = find.byTooltip("navigate to episodes");

    await widgetTester.pump();
    expect(episodesListMenu, findsWidgets);
    await widgetTester.tap(episodesListMenu);
    await widgetTester.pump();
    final errorWidget = find.byTooltip('data empty');
    expect(errorWidget, findsOneWidget);
  });

  testWidgets('verify season detail page when empty', (widgetTester) async {
    when(seasonDetailNotifier.seasonState)
        .thenAnswer((_) => RequestState.Empty);
    when(seasonDetailNotifier.message).thenAnswer((_) => '');

    await widgetTester.pumpWidget(_makeTestableWidget(
      SeasonDetailPage(
        coverImageUrl: testTvDetail.posterPath,
        season: testTvDetail.seasons.first,
        tvId: testTvDetail.id,
      ),
    ));

    final emptyWidget = find.byTooltip("data empty");
    expect(emptyWidget, findsWidgets);
  });
  testWidgets('verify season detail page when property empty',
      (widgetTester) async {
    when(seasonDetailNotifier.seasonState)
        .thenAnswer((_) => RequestState.Loaded);
    when(seasonDetailNotifier.message).thenAnswer((_) => '');

    when(seasonDetailNotifier.season).thenAnswer((_) => testSeasonDetail);
    await widgetTester.pumpWidget(_makeTestableWidget(
      SeasonDetailPage(
        coverImageUrl: testTvDetail.posterPath,
        season: Season(id: 1),
        tvId: testTvDetail.id,
      ),
    ));

    final emptyWidget = find.text("-");
    expect(emptyWidget, findsWidgets);
  });

  testWidgets('verify season detail page when empty', (widgetTester) async {
    when(seasonDetailNotifier.seasonState)
        .thenAnswer((_) => RequestState.Empty);
    when(seasonDetailNotifier.message).thenAnswer((_) => '');

    await widgetTester.pumpWidget(_makeTestableWidget(
      SeasonDetailPage(
        coverImageUrl: testTvDetail.posterPath,
        season: testTvDetail.seasons.first,
        tvId: testTvDetail.id,
      ),
    ));

    final emptyWidget = find.byTooltip("data empty");
    expect(emptyWidget, findsWidgets);
  });
  testWidgets('verify season detail page when error', (widgetTester) async {
    when(seasonDetailNotifier.seasonState)
        .thenAnswer((_) => RequestState.Error);
    when(seasonDetailNotifier.message).thenAnswer((_) => "failed");
    await widgetTester.pumpWidget(_makeTestableWidget(
      SeasonDetailPage(
        coverImageUrl: testTvDetail.posterPath,
        season: testTvDetail.seasons.first,
        tvId: testTvDetail.id,
      ),
    ));

    final emptyWidget = find.byTooltip("error message");
    expect(emptyWidget, findsWidgets);
  });
}
