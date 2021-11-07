import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/movie/search_page.dart';
import 'package:ditonton/presentation/provider/movie/movie_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_page_test.mocks.dart';

@GenerateMocks([MovieSearchNotifier])
main() {
  late MockMovieSearchNotifier mockNotifier;
  setUp(() {
    mockNotifier = MockMovieSearchNotifier();
  });
  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieSearchNotifier>.value(
      value: mockNotifier,
      // child: MediaQuery(
      //   data: MediaQueryData(),
      child: MaterialApp(
        home: body,
      ),
      // ),
    );
  }

  testWidgets('should execute valid search behaviour', (widgetTester) async {
    var textField = find.byType(TextField);
    when(mockNotifier.state).thenAnswer((_) => RequestState.Empty);

    await widgetTester.pumpWidget(_makeTestableWidget(SearchPage()));

    await widgetTester.enterText(textField, 'gravity falls');
    expect(find.text('gravity falls'), findsOneWidget);
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);
    when(mockNotifier.state).thenAnswer((_) => RequestState.Loading);
    await widgetTester.pump();
    verify(mockNotifier.fetchMovieSearch('gravity falls'));
  });
  testWidgets('display circular progress when state is loading',
      (widgetTester) async {
    when(mockNotifier.state).thenAnswer((_) => RequestState.Loading);
    await widgetTester.pumpWidget(_makeTestableWidget(SearchPage()));
    when(mockNotifier.state).thenAnswer((_) => RequestState.Loaded);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('display list movie card when state is loaded',
      (widgetTester) async {
    when(mockNotifier.searchResult).thenAnswer((_) => [testMovie]);
    when(mockNotifier.state).thenAnswer((_) => RequestState.Loaded);
    await widgetTester.pumpWidget(_makeTestableWidget(SearchPage()));
    expect(find.byType(MovieCard), findsOneWidget);
  });
}
