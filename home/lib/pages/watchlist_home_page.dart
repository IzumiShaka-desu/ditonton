import 'package:flutter/material.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:tv/presentation/pages/watchlist_tvs_page.dart';

class WathcListHomePage extends StatelessWidget {
  const WathcListHomePage({Key? key}) : super(key: key);
  final _tabs = const <String>['Movies', "Tv Series"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: _tabs
                  .map(
                    (e) => Tab(
                      text: e,
                    ),
                  )
                  .toList(),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  WatchlistMoviesPage(),
                  WatchlistTvsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
