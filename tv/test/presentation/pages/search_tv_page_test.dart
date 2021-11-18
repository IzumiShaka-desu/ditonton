import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/pages/search_tv_page.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:tv/tv.dart';

import '../../dummy/tv_dummy_objects.dart';
import 'search_tv_page_test.mocks.dart';

@GenerateMocks([TvSearchNotifier])
main() {
  late MockTvSearchNotifier mockNotifier;
  setUp(() {
    mockNotifier = MockTvSearchNotifier();
  });
  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSearchNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('should execute valid search behaviour', (widgetTester) async {
    var textField = find.byType(TextField);
    when(mockNotifier.state).thenAnswer((_) => RequestState.Empty);

    await widgetTester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    await widgetTester.enterText(textField, 'gravity falls');
    expect(find.text('gravity falls'), findsOneWidget);
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);
    when(mockNotifier.state).thenAnswer((_) => RequestState.Loading);
    await widgetTester.pump();
    verify(mockNotifier.fetchTvSearch('gravity falls'));
  });
  testWidgets('display circular progress when state is loading',
      (widgetTester) async {
    when(mockNotifier.state).thenAnswer((_) => RequestState.Loading);
    await widgetTester.pumpWidget(_makeTestableWidget(SearchTvPage()));
    when(mockNotifier.state).thenAnswer((_) => RequestState.Loaded);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('display list tv card when state is loaded',
      (widgetTester) async {
    when(mockNotifier.searchResult).thenAnswer((_) => [testTv]);
    when(mockNotifier.state).thenAnswer((_) => RequestState.Loaded);
    await widgetTester.pumpWidget(_makeTestableWidget(SearchTvPage()));
    expect(find.byType(TvCard), findsOneWidget);
  });
}
