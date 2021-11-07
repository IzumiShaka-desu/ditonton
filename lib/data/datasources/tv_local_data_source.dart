import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/tv_table.dart';

abstract class TvLocalDataSource {
  Future<String> insertWatchlist(TvTable tv);
  Future<String> removeWatchlist(TvTable tv);
  Future<TvTable?> getTvById(int id);
  Future<List<TvTable>> getWatchlistTvs();
  Future<void> cacheNowPlayingTvs(List<TvTable> tvs);
  Future<List<TvTable>> getCachedNowPlayingTvs();
}

class TvLocalDataSourceImpl extends TvLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> cacheNowPlayingTvs(List<TvTable> tvs) async {
    await databaseHelper.clearTvCache('now playing');
    await databaseHelper.insertTvCacheTransaction(tvs, 'now playing');
  }

  @override
  Future<List<TvTable>> getCachedNowPlayingTvs() async {
    final results = await databaseHelper.getCacheTvs('now playing');
    if (results.isNotEmpty) {
      return results
          .map(
            (e) => TvTable.fromJson(e),
          )
          .toList();
    }
    throw (CacheException("cache data not available"));
  }

  @override
  Future<TvTable?> getTvById(int id) async {
    final result = await databaseHelper.getTvById(id);
    if (result != null) {
      return TvTable.fromJson(result);
    }
  }

  @override
  Future<List<TvTable>> getWatchlistTvs() async {
    final results = await databaseHelper.getWatchlistTvs();
    return results
        .map(
          (e) => TvTable.fromJson(e),
        )
        .toList();
  }

  @override
  Future<String> insertWatchlist(TvTable tv) async {
    try {
      await databaseHelper.insertTvWatchList(tv);
      return 'Added to WatchList';
    } catch (e) {
      throw (DatabaseException(
        e.toString(),
      ));
    }
  }

  @override
  Future<String> removeWatchlist(TvTable tv) async {
    try {
      await databaseHelper.removeTvWatchlist(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw (DatabaseException(
        e.toString(),
      ));
    }
  }
}
