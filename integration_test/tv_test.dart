import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/main.dart' as app;
import 'package:tv/presentation/widgets/poster_image.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('App  Test', () {
    testWidgets('test tv series feature', (tester) async {
      app.main();
      print("running test on tv series feature");
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      final menuTvSeries = find.byTooltip('menu Tv Series');
      await tester.tap(menuTvSeries);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byType(ClipRRect).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.dragUntilVisible(
        find.byTooltip("Recommendation item 1"), // what you want to find
        find.byType(DraggableScrollableSheet), // widget you want to scroll
        const Offset(0, 50), // delta to move
      );
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byTooltip("Recommendation item 1"));
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      final lastAiringButton = find.byIcon(Icons.remove_red_eye_outlined);
      await tester.dragUntilVisible(
        lastAiringButton, // what you want to find
        find.byType(DraggableScrollableSheet), // widget you want to scroll
        const Offset(0, 50), // delta to move
      );
      await tester.pumpAndSettle(Duration(milliseconds: 1000));
      print('navigate to detail season');
      await tester.tap(lastAiringButton);
      await tester.pumpAndSettle(Duration(milliseconds: 500));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      final episodesListMenu = find.widgetWithText(Tab, "episodes");
      await tester.tap(episodesListMenu.first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      final posterImage = find.byType(PosterImage);
      await tester.dragUntilVisible(
          posterImage.last, find.byType(ListView).first, Offset(0, 100));
      await tester.pumpAndSettle(Duration(milliseconds: 1000));
      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));

      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));

      print("testing now playing tv series done");
      await tester.dragUntilVisible(
        find.byTooltip("navigate to Popular").first, // what you want to find
        find.byType(SingleChildScrollView).first, // widget you want to scroll
        const Offset(0, 50), // delta to move
      );
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      print("navigate to popular");
      await tester.tap(find.byTooltip("navigate to Popular").first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byType(ClipRRect).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      print("popular done");
      await tester.dragUntilVisible(
        find.byTooltip("navigate to Top Rated").first, // what you want to find
        find.byType(SingleChildScrollView).first, // widget you want to scroll
        const Offset(0, 50), // delta to move
      );
      print("navigate to top rated");
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byTooltip("navigate to Top Rated").first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byType(ClipRRect).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      print("top rated done");
      print("tv series test done");
    });
  });
}
