import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/cubit/detail_tv/detail_tv_cubit.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:tv/presentation/widgets/poster_image.dart';

import '../../dummy_data/tv_dummy_objects.dart';

class MockDetailTvsCubit extends MockCubit<DetailTvsState>
    implements DetailTvCubit {}

class FakeLoadingDetailTvsState extends Fake implements LoadingDetailTvsState {}

class FakeLoadedWithRecommendationListDetailTvsState extends Fake
    implements LoadedWithRecommendationListDetailTvsState {}

class FakeLoadedWithRecommendationErrorDetailTvsState extends Fake
    implements LoadedWithRecommendationErrorDetailTvsState {}

class FakeErrorDetailTvsState extends Fake implements ErrorDetailTvsState {}

void main() {
  late MockDetailTvsCubit mockCubit;
  setUpAll(() {
    registerFallbackValue(FakeLoadingDetailTvsState());
    registerFallbackValue(FakeLoadedWithRecommendationErrorDetailTvsState());
    registerFallbackValue(FakeLoadedWithRecommendationListDetailTvsState());
    registerFallbackValue(FakeErrorDetailTvsState());
  });
  setUp(() {
    mockCubit = MockDetailTvsCubit();
  });
  const tId = 1;
  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<DetailTvCubit>(
      create: (BuildContext context) => mockCubit,
      child: MaterialApp(
          home: body,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (_) => Container());
          }),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when Tvs not added to watchlist',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailTvsState(
        testTvDetail2, false, [testTv]);

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailTv(tId))
        .thenAnswer((invocation) async => invocation);
    when(() => mockCubit.message)
        .thenAnswer((_) => DetailTvCubit.watchlistAddSuccessMessage);
    when(() => mockCubit.addWatchlist(testTvDetail)).thenAnswer((_) async => _);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });
  testWidgets('display circular indicator when loading ',
      (WidgetTester tester) async {
    final testData = LoadingDetailTvsState();

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailTv(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final progressIndicator = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(progressIndicator, findsOneWidget);
  });
  testWidgets('display test error message when error state',
      (WidgetTester tester) async {
    const testData = ErrorDetailTvsState('cannot established connection');

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailTv(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final erorrText = find.byTooltip('error message');

    await tester.pumpWidget(
      _makeTestableWidget(
        const TvDetailPage(id: 1),
      ),
    );
    expect(erorrText, findsOneWidget);
  });
  testWidgets('should display sizedbox when recomendation empty',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailTvsState(
        testTvDetail, true, const []);

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailTv(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final findEmptyWidget = find.byTooltip('Recommendation empty');

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(findEmptyWidget, findsOneWidget);
  });

  testWidgets(
      'should display error text message widget when recomendation error state',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationErrorDetailTvsState(
      testTvDetail,
      true,
      'Recommendation error',
    );

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailTv(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final findErrorWidget = find.byTooltip('Recommendation error');
    final backButton = find.byIcon(Icons.arrow_back);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(findErrorWidget, findsOneWidget);
    await tester.tap(backButton);
  });
  testWidgets(
      'should display recommendation list widget when recomendation loaded state',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailTvsState(
        testTvDetail2, false, [testTv]);

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailTv(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

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
    final testData = LoadedWithRecommendationListDetailTvsState(
        testTvDetail, false, [testTv]);

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailTv(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

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
    final testData = LoadedWithRecommendationListDetailTvsState(
        testTvDetail2, false, [testTv]);

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailTv(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final lastAiringCard = find.byTooltip('last airing season');

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(lastAiringCard, findsNothing);
  });

  testWidgets(
      'should tap show more last airing season widget when loaded state',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailTvsState(
        testTvDetail, false, [testTv]);

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailTv(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final lastAiringButton = find.byIcon(Icons.remove_red_eye_outlined);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

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
      'Watchlist button should display add icon when Tvs not added to watchlist',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailTvsState(
        testTvDetail, false, [testTv]);

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailTv(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when Tvs is added to wathclist',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailTvsState(
        testTvDetail, true, [testTv]);

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailTv(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailTvsState(
        testTvDetail2, false, [testTv]);

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailTv(tId))
        .thenAnswer((invocation) async => invocation);
    when(() => mockCubit.addWatchlist(testTvDetail2))
        .thenAnswer((_) async => _);
    whenListen(mockCubit, Stream.fromIterable([testData]));
    when(() => mockCubit.message)
        .thenAnswer((_) => DetailTvCubit.watchlistAddSuccessMessage);
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
    final testData = LoadedWithRecommendationListDetailTvsState(
        testTvDetail2, true, [testTv]);

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailTv(tId))
        .thenAnswer((invocation) async => invocation);
    when(() => mockCubit.message)
        .thenAnswer((_) => DetailTvCubit.watchlistRemoveSuccessMessage);
    when(() => mockCubit.removeFromWatchlist(testTvDetail2))
        .thenAnswer((_) async => _);

    whenListen(mockCubit, Stream.fromIterable([testData]));
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
    final testData = LoadedWithRecommendationListDetailTvsState(
        testTvDetail2, false, [testTv]);

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailTv(tId))
        .thenAnswer((invocation) async => invocation);
    when(() => mockCubit.message).thenAnswer((_) => 'Failed');
    when(() => mockCubit.addWatchlist(testTvDetail2))
        .thenAnswer((_) async => _);

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
