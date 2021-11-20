import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/presentation/bloc/cubit/detail_movies/detail_movies_cubit.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/widgets/poster_image.dart';

import '../../dummy/dummy_objects.dart';

class MockDetailMoviesCubit extends MockCubit<DetailMoviesState>
    implements DetailMoviesCubit {}

class FakeLoadingDetailMoviesState extends Fake
    implements LoadingDetailMoviesState {}

class FakeLoadedWithRecommendationListDetailMoviesState extends Fake
    implements LoadedWithRecommendationListDetailMoviesState {}

class FakeLoadedWithRecommendationErrorDetailMoviesState extends Fake
    implements LoadedWithRecommendationErrorDetailMoviesState {}

class FakeErrorDetailMoviesState extends Fake
    implements ErrorDetailMoviesState {}

void main() {
  late MockDetailMoviesCubit mockCubit;
  setUpAll(() {
    registerFallbackValue(FakeLoadingDetailMoviesState());
    registerFallbackValue(FakeLoadedWithRecommendationErrorDetailMoviesState());
    registerFallbackValue(FakeLoadedWithRecommendationListDetailMoviesState());
    registerFallbackValue(FakeErrorDetailMoviesState());
  });
  setUp(() {
    mockCubit = MockDetailMoviesCubit();
  });
  const tId = 1;
  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<DetailMoviesCubit>(
      create: (BuildContext context) => mockCubit,
      child: MaterialApp(
          home: body,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => Container(),
            );
          }),
    );
  }

  testWidgets('display circular indicator when loading ',
      (WidgetTester tester) async {
    final testData = LoadingDetailMoviesState();

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailMovies(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final progressIndicator = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(progressIndicator, findsOneWidget);
  });
  testWidgets('display test error message when error state',
      (WidgetTester tester) async {
    const testData = ErrorDetailMoviesState('cannot reach server');

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailMovies(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final erorrText = find.byTooltip('error message');

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
    expect(erorrText, findsOneWidget);
  });
  testWidgets('should display sizedbox when recomendation empty',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailMoviesState(
      testMovieDetail,
      true,
      const [],
    );

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailMovies(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
    // final erorrText = find.byTooltip('error message');
    final findEmptyWidget = find.byTooltip('Recommendation empty');

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(findEmptyWidget, findsOneWidget);
  });
  testWidgets('should display lisdt widget when recomendation is available',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailMoviesState(
      testMovieDetail,
      true,
      [testMovie],
    );

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailMovies(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final findPosterImsge = find.byType(PosterImage);
    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
    expect(findPosterImsge, findsWidgets);
  });
  testWidgets(
      'should display error text message widget when recomendation error state',
      (WidgetTester tester) async {
    var newTestData = const MovieDetail(
        id: 1,
        overview: 'overview',
        posterPath: 'posterPath',
        adult: true,
        backdropPath: '',
        genres: [],
        originalTitle: '',
        releaseDate: '',
        runtime: 10,
        title: '',
        voteAverage: 1,
        voteCount: 0);

    final testData = LoadedWithRecommendationErrorDetailMoviesState(
      newTestData,
      true,
      'Recommendation error',
    );

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailMovies(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final findErrorWidget = find.text('Recommendation error');
    final backButton = find.byIcon(Icons.arrow_back);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(findErrorWidget, findsOneWidget);
    await tester.tap(backButton);
  });
  testWidgets(
      'should display recommendation list widget when recomendation loaded state',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailMoviesState(
        testMovieDetail, true, [testMovie]);
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailMovies(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final findPosterImage = find.byType(PosterImage);
    final findRecommendationList = find.byTooltip('Recommendation list');
    final findClip = find.byType(ClipRRect);
    final findInkwell = find.byTooltip("Recommendation item 1");

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
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

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailMovies(tId))
        .thenAnswer((invocation) async => invocation);
    // await tester.scrollUntilVisible(findInkwell, 200, maxScrolls: 1000);
    await tester.tap(findInkwell);
    await tester.pump();
  });
  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailMoviesState(
      testMovieDetail,
      false,
      const [],
    );

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailMovies(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailMoviesState(
      testMovieDetail,
      true,
      const [],
    );
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadDetailMovies(tId))
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final watchlistButtonIcon = find.byIcon(Icons.check);
    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailMoviesState(
      testMovieDetail,
      false,
      const [],
    );
    when(() => mockCubit.message)
        .thenAnswer((_) => DetailMoviesCubit.watchlistAddSuccessMessage);
    when(() => mockCubit.addWatchlist(testMovieDetail))
        .thenAnswer((invocation) async {});
    when(() => mockCubit.state).thenAnswer(
      (_) => testData,
    );

    when(() => mockCubit.loadDetailMovies(tId)).thenAnswer(
      (invocation) async => invocation,
    );
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });
  testWidgets(
      'Watchlist button should display Snackbar when removed from watchlist',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailMoviesState(
      testMovieDetail,
      true,
      const [],
    );
    when(() => mockCubit.message)
        .thenAnswer((_) => DetailMoviesCubit.watchlistRemoveSuccessMessage);
    when(() => mockCubit.removeFromWatchlist(testMovieDetail))
        .thenAnswer((invocation) async {});
    when(() => mockCubit.state).thenAnswer(
      (_) => testData,
    );

    when(() => mockCubit.loadDetailMovies(tId)).thenAnswer(
      (invocation) async => invocation,
    );
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final testData = LoadedWithRecommendationListDetailMoviesState(
      testMovieDetail,
      false,
      const [],
    );
    when(() => mockCubit.message).thenAnswer((_) => 'Failed');
    when(() => mockCubit.addWatchlist(testMovieDetail))
        .thenAnswer((invocation) async {});
    when(() => mockCubit.state).thenAnswer(
      (_) => testData,
    );

    when(() => mockCubit.loadDetailMovies(tId)).thenAnswer(
      (invocation) async => invocation,
    );
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text("Failed"), findsOneWidget);
  });
}
