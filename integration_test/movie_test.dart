import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App  Test', () {
    testWidgets("testing movie feature", (tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      final movieMenu = find.byTooltip("menu Movie");
      await tester.tap(movieMenu);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      print("run test on movie now playing");
      final itemCard = find.byType(ClipRRect);
      await tester.tap(itemCard.first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      final recommendation1 = find.byTooltip("Recommendation item 1");
      await tester.dragUntilVisible(
        recommendation1, // what you want to find
        find.byType(DraggableScrollableSheet), // widget you want to scroll
        const Offset(0, 50), // delta to move
      );
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.tap(recommendation1);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      final watchlistButton = find.byType(ElevatedButton);
      await tester.tap(watchlistButton);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(watchlistButton);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      print("test now playing done");
      print("run test on popular movie");
      await tester.dragUntilVisible(
        find.byTooltip("navigate to Popular").first, // what you want to find
        find.byType(SingleChildScrollView).first, // widget you want to scroll
        const Offset(0, 50), // delta to move
      );
      await tester.pumpAndSettle(Duration(seconds: 1));
      print("navigate to popular movie");
      await tester.tap(find.byTooltip("navigate to Popular").first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byType(ClipRRect).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      print("popular movie test done");
      print("running test on top rated movie");
      await tester.dragUntilVisible(
        find.byTooltip("navigate to Top Rated").first, // what you want to find
        find.byType(SingleChildScrollView).first, // widget you want to scroll
        const Offset(0, 50), // delta to move
      );
      print("navigate to top rated movie");

      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.tap(find.byTooltip("navigate to Top Rated").first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byType(ClipRRect).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.arrow_back).first);
      print("top rated movie test done");
      await tester.pumpAndSettle(Duration(milliseconds: 500));
    });
  });
}
