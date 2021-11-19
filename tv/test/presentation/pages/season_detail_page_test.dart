import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/presentation/bloc/cubit/detail_season/detail_season_cubit.dart';
import 'package:tv/presentation/pages/season_detail_page.dart';
import 'package:tv/presentation/widgets/poster_image.dart';

import '../../dummy_data/tv_dummy_objects.dart';

class MockDetailSeasonCubit extends MockCubit<DetailSeasonState>
    implements DetailSeasonCubit {}

class FakeLoadingDetailSeasonState extends Fake
    implements LoadingDetailSeasonState {}

class FakeLoadedDetailSeasonState extends Fake
    implements LoadedDetailSeasonState {}

class FakeErrorDetailSeasonState extends Fake
    implements ErrorDetailSeasonState {}

void main() {
  late DetailSeasonCubit mockCubit;
  setUpAll(() {
    registerFallbackValue(FakeLoadingDetailSeasonState);
    registerFallbackValue(FakeErrorDetailSeasonState());
    registerFallbackValue(FakeLoadedDetailSeasonState());
  });
  setUp(() {
    mockCubit = MockDetailSeasonCubit();
  });
  const tId = 1;
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          BlocProvider<DetailSeasonCubit>(
            create: (ctx) => mockCubit,
          ),
        ],
        child: body,
      ),
    );
  }

  var testSeason = Season(id: 1, airDate: DateTime(0), seasonNumber: 1);
  testWidgets(
      'verify season detail page behaviour when season property not complete',
      (widgetTester) async {
    final testData = LoadingDetailSeasonState();

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailSeason(tId, tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(
        mockCubit,
        Stream.fromIterable(
            [testData, LoadedDetailSeasonState(testSeasonDetail)]));
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
    final testData = LoadingDetailSeasonState();

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailSeason(tId, tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(
        mockCubit, Stream.fromIterable([LoadingDetailSeasonState(), testData]));
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
    var testDataDetail = testSeasonDetail;
    testDataDetail.episodes.clear();
    testDataDetail.episodes.addAll(
      List.generate(
        10,
        (index) => testEpisode,
      ).toList(),
    );
    final testData = LoadedDetailSeasonState(testDataDetail);

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailSeason(tId, tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
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
        posterImage.last, find.byType(ListView).last, const Offset(0, 100));
    await widgetTester.pump();
  });

  testWidgets('verify season detail page episode list when error state ',
      (widgetTester) async {
    const testData = ErrorDetailSeasonState('cannot established connection');

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailSeason(tId, tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
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
    when(() => mockCubit.loadDetailSeason(tId, tId))
        .thenAnswer((invocation) async => invocation);
    final errorWidget = find.byTooltip('error message');
    expect(errorWidget, findsWidgets);
  });

  testWidgets('verify season detail page when error', (widgetTester) async {
    const testData = ErrorDetailSeasonState('cannot established connection');

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailSeason(tId, tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
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
