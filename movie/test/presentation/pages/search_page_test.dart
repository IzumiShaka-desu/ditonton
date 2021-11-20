import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/bloc/search_movies/search_movies_bloc.dart';
import 'package:movie/presentation/pages/search_page.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';

import '../../dummy/dummy_objects.dart';

class MockSearchMoviesBloc
    extends MockBloc<SearchMoviesEvent, SearchMoviesState>
    implements SearchMoviesBloc {}

class FakeLoadingSearchMoviesState extends Fake
    implements LoadingSearchMoviesState {}

class FakeLoadedSearchMoviesState extends Fake
    implements LoadedSearchMoviesState {}

class FakeErrorSearchMoviesState extends Fake
    implements ErrorSearchMoviesState {}

class FakeOnQueryChanged extends Fake implements OnQueryChanged {}

void main() {
  late MockSearchMoviesBloc mockBloc;
  setUpAll(() {
    registerFallbackValue(FakeLoadingSearchMoviesState());
    registerFallbackValue(FakeLoadedSearchMoviesState());
    registerFallbackValue(FakeErrorSearchMoviesState());
    registerFallbackValue(FakeOnQueryChanged());
  });
  setUp(() {
    mockBloc = MockSearchMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SearchMoviesBloc>(
      create: (context) => mockBloc,
      child: MaterialApp(
        home: body,
      ),
      // ),
    );
  }

  testWidgets('should execute valid search behaviour', (widgetTester) async {
    var textField = find.byType(TextField);
    final testData = InitialSearchMoviesState();

    when(() => mockBloc.state).thenAnswer((_) => testData);
    // when(() => mockBloc.)
    //     .thenAnswer((invocation) async => invocation);
    whenListen(mockBloc, Stream.fromIterable([testData]));
    await widgetTester.pumpWidget(_makeTestableWidget(const SearchPage()));

    await widgetTester.enterText(textField, 'gravity falls');
    expect(find.text('gravity falls'), findsOneWidget);
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);
    await widgetTester.pumpAndSettle();
  });
  testWidgets('display circular progress when state is loading',
      (widgetTester) async {
    final testData = LoadingSearchMoviesState();

    when(() => mockBloc.state).thenAnswer((_) => testData);
    // when(() => mockBloc.)
    //     .thenAnswer((invocation) async => invocation);
    whenListen(mockBloc, Stream.fromIterable([testData]));
    await widgetTester.pumpWidget(_makeTestableWidget(const SearchPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('display list movie card when state is loaded',
      (widgetTester) async {
    final testData = LoadedSearchMoviesState([testMovie]);

    when(() => mockBloc.state).thenAnswer((_) => testData);
    // when(() => mockBloc.)
    //     .thenAnswer((invocation) async => invocation);
    whenListen(mockBloc, Stream.fromIterable([testData]));
    await widgetTester.pumpWidget(_makeTestableWidget(const SearchPage()));
    expect(find.byType(MovieCard), findsOneWidget);
  });
}
