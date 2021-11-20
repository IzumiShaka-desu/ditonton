import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/presentation/widgets/state_widget.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Material(child: body),
    );
  }

  testWidgets('should dsiplay circular progress when loading', (tester) async {
    final finder = find.byType(CircularProgressIndicator);
    await tester.pumpWidget(
      _makeTestableWidget(
        StateWidget(
          state: RequestState.Loading,
          message: '',
          child: (ctx) => Container(),
        ),
      ),
    );
    expect(finder, findsOneWidget);
  });

  testWidgets('should dsiplay circular progress when loaded', (tester) async {
    final finder = find.byTooltip('success');
    await tester.pumpWidget(
      _makeTestableWidget(
        StateWidget(
          state: RequestState.Loaded,
          message: '',
          child: (ctx) => Tooltip(
            message: 'success',
            child: Container(),
          ),
        ),
      ),
    );
    expect(finder, findsOneWidget);
  });
  testWidgets('should dsiplay error widget when error', (tester) async {
    final finder = find.byTooltip('error message');
    await tester.pumpWidget(
      _makeTestableWidget(
        StateWidget(
          state: RequestState.Error,
          message: '',
          child: (ctx) => Container(),
        ),
      ),
    );
    expect(finder, findsOneWidget);
  });
  testWidgets('should dsiplay empty widget when empty', (tester) async {
    final finder = find.byTooltip('data empty');
    await tester.pumpWidget(
      _makeTestableWidget(
        StateWidget(
          state: RequestState.Empty,
          message: 'error',
          child: (ctx) => Container(),
        ),
      ),
    );
    expect(finder, findsOneWidget);
  });
}
