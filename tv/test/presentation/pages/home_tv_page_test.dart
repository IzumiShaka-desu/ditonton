import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/cubit/tv_list/tv_list_cubit.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/tv_dummy_objects.dart';

class MockTvListCubit extends MockCubit<TvListState> implements TvListCubit {}

class FakeLoadingTvListState extends Fake implements LoadingTvListState {}

class FakeLoadedTvListState extends Fake implements LoadedTvListState {}

class FakeErrorTvListState extends Fake implements ErrorTvListState {}

main() {
  late TvListCubit mockCubit;
  setUpAll(() {
    registerFallbackValue(FakeLoadingTvListState());
    registerFallbackValue(FakeLoadedTvListState());
    registerFallbackValue(FakeErrorTvListState());
  });
  setUp(() {
    mockCubit = MockTvListCubit();
  });
  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvListCubit>(
      create: (context) => mockCubit,
      child: MaterialApp(
        home: body,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (ctx) => body,
        ),
      ),
    );
  }

  group('verify tap behaviour', () {
    setUp(() {
      final testData = LoadedTvListState(
        nowPlaying: [testTv],
        topRated: [testTv],
        popular: [testTv],
      );
      when(() => mockCubit.state).thenAnswer((_) => testData);
      when(() => mockCubit.loadTvList())
          .thenAnswer((invocation) async => invocation);
      whenListen(mockCubit, Stream.fromIterable([testData]));
    });
    testWidgets('navigate to popular', (widgetTester) async {
      await widgetTester.pumpWidget(_makeTestableWidget(HomeTvPage()));

      var popular = find.byTooltip("navigate to Popular");
      expect(popular, findsOneWidget);
      await widgetTester.tap(popular);
      await widgetTester.pump();
    });
    testWidgets('navigate to top rated ', (tester) async {
      await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

      var topRated = find.byTooltip("navigate to Top Rated");
      expect(topRated, findsOneWidget);
      await tester.tap(topRated);
      await tester.pump();
    });
    testWidgets('itemlist ', (tester) async {
      await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

      var itemList = find.byType(ClipRRect);

      expect(itemList, findsWidgets);
      await tester.tap(itemList.first);
      await tester.pump();
    });
  });
  group('now playing not loaded', () {
    final testData = LoadedTvListState(
      popular: [testTv],
      nowPlaying: const [],
      topRated: [testTv],
    );
    setUp(() {
      when(() => mockCubit.state).thenAnswer((_) => testData);
      when(() => mockCubit.loadTvList())
          .thenAnswer((invocation) async => invocation);
      whenListen(mockCubit, Stream.fromIterable([testData]));
    });
    testWidgets(
        'should display text failed when now playing section state is empty or error',
        (tester) async {
      var findCircularProgress = find.byType(CircularProgressIndicator);

      var textFailedFinder = find.byTooltip('failed to load tvs');
      await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));
      expect(findCircularProgress, findsWidgets);
      expect(textFailedFinder, findsOneWidget);
    });
  });
  group('popular not loaded', () {
    final testData = LoadedTvListState(
      popular: const [],
      nowPlaying: [testTv],
      topRated: [testTv],
    );
    setUp(() {
      when(() => mockCubit.state).thenAnswer((_) => testData);
      when(() => mockCubit.loadTvList())
          .thenAnswer((invocation) async => invocation);
      whenListen(mockCubit, Stream.fromIterable([testData]));
    });
    testWidgets(
        'should display text failed when popular section state is empty or error',
        (tester) async {
      var findCircularProgress = find.byType(CircularProgressIndicator);

      var textFailedFinder = find.byTooltip('failed to load tvs');
      await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));
      expect(findCircularProgress, findsWidgets);
      expect(textFailedFinder, findsOneWidget);
    });
  });
  group('top rated not loaded', () {
    final testData = LoadedTvListState(
      popular: [testTv],
      nowPlaying: [testTv],
      topRated: const [],
    );
    setUp(() {
      when(() => mockCubit.state).thenAnswer((_) => testData);
      when(() => mockCubit.loadTvList())
          .thenAnswer((invocation) async => invocation);
      whenListen(mockCubit, Stream.fromIterable([testData]));
    });
    testWidgets(
        'should display text failed when top rated section state is empty or error',
        (tester) async {
      var findCircularProgress = find.byType(CircularProgressIndicator);

      var textFailedFinder = find.byTooltip('failed to load tvs');
      await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));
      expect(findCircularProgress, findsWidgets);
      expect(textFailedFinder, findsOneWidget);
    });
  });
  group('error fetching all category', () {
    const testData = ErrorTvListState('cannot establish connection');
    setUp(() {
      when(() => mockCubit.state).thenAnswer((_) => testData);
      when(() => mockCubit.loadTvList())
          .thenAnswer((invocation) async => invocation);
      whenListen(mockCubit, Stream.fromIterable([testData]));
    });
    testWidgets(
        'should display text failed when top rated section state is empty or error',
        (tester) async {
      var textFailedFinder = find.text('cannot establish connection');
      var retryButton = find.text('Retry');
      await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));
      expect(textFailedFinder, findsOneWidget);
      expect(retryButton, findsOneWidget);
      await tester.tap(retryButton);
      await tester.pumpAndSettle();
      verify(mockCubit.loadTvList);
    });
  });
}
