import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvLocalDataSourceImpl dataSource;
  late MockDatabaseHelper databaseHelper;
  setUp(() {
    databaseHelper = MockDatabaseHelper();
    dataSource = TvLocalDataSourceImpl(databaseHelper: databaseHelper);
  });
  final testDatas = List<TvTable>.generate(
    5,
    (index) => TvTable(
      id: index,
      name: '$index',
      overview: '$index',
      posterPath: '%index',
    ),
  );
  group('watchlist', () {
    group('save watch list', () {
      test('return true when insert item on database helper', () async {
        //arrange
        when(databaseHelper.insertTvWatchList(testDatas.first))
            .thenAnswer((_) async => 1);
        //act
        final result = await dataSource.insertWatchlist(testDatas.first);
        //assert
        verify(databaseHelper.insertTvWatchList(testDatas.first));
        expect(result, 'Added to WatchList');
      });
      test('return database exception when insert database helper', () async {
        //arrange
        when(databaseHelper.insertTvWatchList(testDatas.first))
            .thenThrow(Exception());
        //act
        final call = dataSource.insertWatchlist(testDatas.first);
        //assert
        verify(databaseHelper.insertTvWatchList(testDatas.first));
        expect(call, throwsA(isA<DatabaseException>()));
      });
    });

    group('remove watch list', () {
      test('return true when remove item on database helper', () async {
        //arrange
        when(databaseHelper.removeTvWatchlist(testDatas.first))
            .thenAnswer((_) async => 1);

        //act
        final result = await dataSource.removeWatchlist(testDatas.first);
        //assert
        verify(databaseHelper.removeTvWatchlist(testDatas.first));
        expect(result, 'Removed from Watchlist');
      });
      test('return database exception when remove item on database helper',
          () async {
        //arrange
        when(databaseHelper.removeTvWatchlist(testDatas.first))
            .thenThrow(Exception());
        //act
        final call = dataSource.removeWatchlist(testDatas.first);
        //assert
        verify(databaseHelper.removeTvWatchlist(testDatas.first));
        expect(call, throwsA(isA<DatabaseException>()));
      });
    });

    group('get tv watchlist by id', () {
      test('return valid model when get detail tv watchlist on database helper',
          () async {
        //arrange
        when(databaseHelper.getTvById(testDatas.first.id))
            .thenAnswer((_) async => testDatas.first.toJson());
        //act
        final result = await dataSource.getTvById(testDatas.first.id);
        //assert
        verify(databaseHelper.getTvById(testDatas.first.id));
        expect(result, testDatas.first);
      });
      test('return null when get detail tv watchlist on database helper',
          () async {
        //arrange
        when(databaseHelper.getTvById(testDatas.first.id))
            .thenAnswer((_) async => null);

        //act
        final result = await dataSource.getTvById(testDatas.first.id);
        //assert
        verify(databaseHelper.getTvById(testDatas.first.id));
        expect(result, null);
      });
    });
    group('get tv watch list', () {
      test('should return list when get tv watchlist', () async {
        //arrange
        when(databaseHelper.getWatchlistTvs())
            .thenAnswer((_) async => testDatas.map((e) => e.toJson()).toList());

        //act
        final result = await dataSource.getWatchlistTvs();
        //assert
        verify(databaseHelper.getWatchlistTvs());
        expect(result, testDatas);
      });
    });
  });
  group('caching', () {
    group('cache now playing tv', () {
      test('return true when save cache on database helper', () async {
        when(databaseHelper.clearTvCache('now playing'))
            .thenAnswer((_) async => 1);
        // act
        await dataSource.cacheNowPlayingTvs(testDatas);
        // assert
        verify(databaseHelper.clearTvCache('now playing'));
        verify(
            databaseHelper.insertTvCacheTransaction(testDatas, 'now playing'));
      });
    });

    group('get cache now playing tv', () {
      test('return cache exception when tv cache not available', () async {
        //arrange
        when(databaseHelper.getCacheTvs('now playing'))
            .thenAnswer((_) async => []);
        // act
        final call = dataSource.getCachedNowPlayingTvs();
        // assert
        expect(() => call, throwsA(isA<CacheException>()));
      });
      test('return valid tv table list when cache available', () async {
        //arrange
        when(databaseHelper.getCacheTvs('now playing'))
            .thenAnswer((_) async => testDatas.map((e) => e.toJson()).toList());
        // act
        final result = await dataSource.getCachedNowPlayingTvs();
        // assert
        expect(result, testDatas);
      });
    });
  });
}
