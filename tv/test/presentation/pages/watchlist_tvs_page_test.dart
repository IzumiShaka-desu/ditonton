import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/cubit/watchlist_tvs/watchlist_tvs_cubit.dart';
import 'package:tv/presentation/pages/watchlist_tvs_page.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

import '../../dummy_data/tv_dummy_objects.dart';

class MockWatchlistTvsCubit extends MockCubit<WatchlistTvsState>
    implements WatchlistTvsCubit {}

class FakeLoadingWatchlistTvsState extends Fake
    implements LoadingWatchlistTvsState {}

class FakeLoadedWatchlistTvsState extends Fake
    implements LoadedWatchlistTvsState {}

class FakeErrorWatchlistTvsState extends Fake
    implements ErrorWatchlistTvsState {}

void main() {
  late MockWatchlistTvsCubit mockCubit;
  setUpAll(() {
    registerFallbackValue(FakeLoadingWatchlistTvsState());
    registerFallbackValue(FakeLoadedWatchlistTvsState());
    registerFallbackValue(FakeErrorWatchlistTvsState());
  });
  setUp(() {
    mockCubit = MockWatchlistTvsCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvsCubit>(
      create: (context) => mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    final testData = LoadingWatchlistTvsState();

    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadWatchlistTvs())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView with TvCard when data is loaded',
      (WidgetTester tester) async {
    final testData = LoadedWatchlistTvsState(
      [testTv],
    );
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadWatchlistTvs())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final listViewFinder = find.byType(ListView);
    final tvCardFinder = find.byType(TvCard);

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvsPage()));

    expect(listViewFinder, findsOneWidget);
    expect(tvCardFinder, findsWidgets);
  });
  testWidgets('Page should display Text when data is loaded but empty',
      (WidgetTester tester) async {
    const testData = LoadedWatchlistTvsState(
      [],
    );
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadWatchlistTvs())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final textFinder = find.text("you don't have any watchlist yet");

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvsPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const testData = ErrorWatchlistTvsState('cannot connect');
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadWatchlistTvs())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvsPage()));

    expect(textFinder, findsOneWidget);
  });
}
