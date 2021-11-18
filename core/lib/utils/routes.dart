import 'package:about/about.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home/home.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/search_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/presentation/pages/popular_tvs_page.dart';
import 'package:tv/presentation/pages/search_tv_page.dart';
import 'package:tv/presentation/pages/season_detail_page.dart';
import 'package:tv/presentation/pages/season_list_page.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:tv/presentation/pages/watchlist_tvs_page.dart';

class Routes {
  static const defaultPage = HomePage();
  Route call(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(
          builder: (_) => defaultPage,
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
