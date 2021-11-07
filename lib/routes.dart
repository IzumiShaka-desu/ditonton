import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/presentation/pages/tv/season_detail_page.dart';
import 'package:ditonton/presentation/pages/tv/season_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'domain/entities/tv_detail.dart';
import 'presentation/pages/about_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/movie/movie_detail_page.dart';
import 'presentation/pages/movie/popular_movies_page.dart';
import 'presentation/pages/movie/search_page.dart';
import 'presentation/pages/movie/top_rated_movies_page.dart';
import 'presentation/pages/movie/watchlist_movies_page.dart';
import 'presentation/pages/tv/popular_tvs_page.dart';
import 'presentation/pages/tv/search_tv_page.dart';
import 'presentation/pages/tv/top_rated_tvs_page.dart';
import 'presentation/pages/tv/tv_detail_page.dart';
import 'presentation/pages/tv/watchlist_tvs_page.dart';

class Routes {
  Route call(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case PopularTvsPage.ROUTE_NAME:
        return CupertinoPageRoute(
          builder: (_) => PopularTvsPage(),
        );
      case TopRatedTvsPage.ROUTE_NAME:
        return CupertinoPageRoute(
          builder: (_) => TopRatedTvsPage(),
        );
      case PopularMoviesPage.ROUTE_NAME:
        return CupertinoPageRoute(
          builder: (_) => PopularMoviesPage(),
        );
      case TopRatedMoviesPage.ROUTE_NAME:
        return CupertinoPageRoute(
          builder: (_) => TopRatedMoviesPage(),
        );
      case MovieDetailPage.ROUTE_NAME:
        final id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => MovieDetailPage(id: id),
          settings: settings,
        );
      case TvDetailPage.ROUTE_NAME:
        final id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => TvDetailPage(id: id),
          settings: settings,
        );
      case SeasonDetailPage.routeName:
        final mapData = settings.arguments as Map;
        return CupertinoPageRoute(
          builder: (context) {
            return SeasonDetailPage(
              coverImageUrl: mapData["coverImageUrl"],
              tvId: mapData["tvId"],
              season: mapData["season"],
            );
          },
        );
      case SearchPage.ROUTE_NAME:
        return CupertinoPageRoute(
          builder: (_) => SearchPage(),
        );
      case SearchTvPage.ROUTE_NAME:
        return CupertinoPageRoute(
          builder: (_) => SearchTvPage(),
        );
      case WatchlistTvsPage.ROUTE_NAME:
        return MaterialPageRoute(
          builder: (_) => WatchlistTvsPage(),
        );
      case WatchlistMoviesPage.ROUTE_NAME:
        return MaterialPageRoute(
          builder: (_) => WatchlistMoviesPage(),
        );
      case SeasonListPage.ROUTE_NAME:
        final tv = settings.arguments as TvDetail;
        return CupertinoPageRoute(
          builder: (_) => SeasonListPage(
            tv: tv,
          ),
          settings: settings,
        );

      case AboutPage.ROUTE_NAME:
        return MaterialPageRoute(
          builder: (_) => AboutPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(
              body: Center(
                child: Text('Page not found :('),
              ),
            );
          },
        );
    }
  }
}
