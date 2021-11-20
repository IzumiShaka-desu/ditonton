import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/bloc/search_movies/search_tvs_bloc.dart';
import 'package:tv/presentation/pages/search_tv_page.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

import '../../dummy_data/tv_dummy_objects.dart';

class MockSearchTvsBloc extends MockBloc<SearchTvsEvent, SearchTvsState>
    implements SearchTvsBloc {}

class FakeLoadingSearchTvsState extends Fake implements LoadingSearchTvsState {}

class FakeLoadedSearchTvsState extends Fake implements LoadedSearchTvsState {}

class FakeErrorSearchTvsState extends Fake implements ErrorSearchTvsState {}

class FakeOnQueryChanged extends Fake implements OnQueryChanged {}

void main() {
  late MockSearchTvsBloc mockBloc;
  setUpAll(() {
    registerFallbackValue(FakeLoadingSearchTvsState());
    registerFallbackValue(FakeLoadedSearchTvsState());
    registerFallbackValue(FakeErrorSearchTvsState());
    registerFallbackValue(FakeOnQueryChanged());
  });
  setUp(() {
    mockBloc = MockSearchTvsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SearchTvsBloc>(
      create: (context) => mockBloc,
      child: MaterialApp(
        home: body,
      ),
      // ),
    );
  }

  testWidgets('should execute valid search behaviour', (widgetTester) async {
    var textField = find.byType(TextField);
    final testData = InitialSearchTvsState();

    when(() => mockBloc.state).thenAnswer((_) => testData);
    // when(() => mockBloc.)
    //     .thenAnswer((invocation) async => invocation);
    whenListen(mockBloc, Stream.fromIterable([testData]));
    await widgetTester.pumpWidget(_makeTestableWidget(const SearchTvPage()));

    await widgetTester.enterText(textField, 'gravity falls');
    expect(find.text('gravity falls'), findsOneWidget);
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);
    await widgetTester.pumpAndSettle();
  });
  testWidgets('display circular progress when state is loading',
      (widgetTester) async {
    final testData = LoadingSearchTvsState();

    when(() => mockBloc.state).thenAnswer((_) => testData);
    // when(() => mockBloc.)
    //     .thenAnswer((invocation) async => invocation);
    whenListen(mockBloc, Stream.fromIterable([testData]));
    await widgetTester.pumpWidget(_makeTestableWidget(const SearchTvPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('display list tv card when state is loaded',
      (widgetTester) async {
    final testData = LoadedSearchTvsState([testTv]);

    when(() => mockBloc.state).thenAnswer((_) => testData);
    // when(() => mockBloc.)
    //     .thenAnswer((invocation) async => invocation);
    whenListen(mockBloc, Stream.fromIterable([testData]));
    await widgetTester.pumpWidget(_makeTestableWidget(const SearchTvPage()));
    expect(find.byType(TvCard), findsOneWidget);
  });
}
