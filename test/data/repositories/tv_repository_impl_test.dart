import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv_dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRemoteDataSource remoteDataSource;
  late TvLocalDataSource localDataSource;
  late NetworkInfo networkInfo;
  late TvRepository repository;
  setUp(() {
    remoteDataSource = MockTvRemoteDataSource();
    localDataSource = MockTvLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = TvRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });
  group('getNowPlayingTvs', () {
    test('should check device connection status', () async {
      //arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(remoteDataSource.getNowPlayingTvs()).thenAnswer((_) async => []);
      //act
      await repository.getNowPlayingTvs();
      //assert
      verify(networkInfo.isConnected);
      verify(remoteDataSource.getNowPlayingTvs());
    });
    group('when device is online', () {
      setUp(() => when(networkInfo.isConnected).thenAnswer((_) async => true));
      test('should return valid list when get now playing tv', () async {
        //arrange
        when(remoteDataSource.getNowPlayingTvs())
            .thenAnswer((_) async => [testTvModel]);
        //act
        final result = await repository.getNowPlayingTvs();
        final results = result.getOrElse(() => []);
        //assert
        verify(remoteDataSource.getNowPlayingTvs());

        expect(results, [testTv]);
      });

      test('should cache locally when success get list from remote datasource',
          () async {
        //arrange
        when(remoteDataSource.getNowPlayingTvs())
            .thenAnswer((_) async => [testTvModel]);
        //act
        await repository.getNowPlayingTvs();
        //assert
        verify(remoteDataSource.getNowPlayingTvs());
        verify(localDataSource.cacheNowPlayingTvs(
          [testTvModel].map((e) => TvTable.fromDTO(e)).toList(),
        ));
      });
      test('should return Server failure when server exception', () async {
        //arrange
        when(remoteDataSource.getNowPlayingTvs()).thenThrow(ServerException());
        //act
        final result = await repository.getNowPlayingTvs();
        //assert
        expect(result, Left(ServerFailure('')));
      });
      test('should return ConnectionFailure when socket exception', () async {
        //arrange
        when(remoteDataSource.getNowPlayingTvs())
            .thenThrow(SocketException(''));
        //act
        final result = await repository.getNowPlayingTvs();
        //assert
        expect(result, Left(ConnectionFailure('Failed Connect to Network')));
      });
    });
    group('when device offline', () {
      setUp(() => when(networkInfo.isConnected).thenAnswer((_) async => false));
      test('should return list from cache', () async {
        //arrange
        when(localDataSource.getCachedNowPlayingTvs())
            .thenAnswer((_) async => [testCache]);
        //act
        final result = await repository.getNowPlayingTvs();
        //assert
        verify(localDataSource.getCachedNowPlayingTvs());
        expect(result.getOrElse(() => []), [testCacheEntity]);
      });
      test('should return cache failure', () async {
        when(localDataSource.getCachedNowPlayingTvs())
            .thenThrow(CacheException('Failed to get cache list'));
        //act
        final result = await repository.getNowPlayingTvs();
        //assert
        expect(result,
            Left<Failure, List<Tv>>(CacheFailure('Failed to get cache list')));
      });
    });
  });
  group('getPopularTvs', () {
    test('should return tv list when call to data source is successful',
        () async {
      // arrange
      when(remoteDataSource.getPopularTvs())
          .thenAnswer((_) async => [testTvModel]);
      // act
      final result = await repository.getPopularTvs();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testTv]);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(remoteDataSource.getPopularTvs()).thenThrow(ServerException());
      // act
      final result = await repository.getPopularTvs();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(remoteDataSource.getPopularTvs())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularTvs();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });
  group('getSeasonDetail', () {
    final testId = 1;
    test('should return tv list when call to data source is successful',
        () async {
      // arrange
      when(remoteDataSource.getSeasonDetail(testId, testId))
          .thenAnswer((_) async => testSeasonDetailModel);
      // act
      final result = await repository.getSeasonDetail(testId, testId);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      expect(result, Right(testSeasonDetail));
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(remoteDataSource.getSeasonDetail(testId, testId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getSeasonDetail(testId, testId);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(remoteDataSource.getSeasonDetail(testId, testId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getSeasonDetail(testId, testId);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });
  group('getTopRatedTvs', () {
    test('should return tv list when call to data source is successful',
        () async {
      // arrange
      when(remoteDataSource.getTopRatedTvs())
          .thenAnswer((_) async => [testTvModel]);
      // act
      final result = await repository.getTopRatedTvs();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testTv]);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(remoteDataSource.getTopRatedTvs()).thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTvs();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(remoteDataSource.getTopRatedTvs())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedTvs();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });
  group('getTvDetail', () {
    final testId = 1;
    test('should return tv list when call to data source is successful',
        () async {
      // arrange
      when(remoteDataSource.getTvDetail(testId))
          .thenAnswer((_) async => testTvDetailModel);
      // act
      final result = await repository.getTvDetail(testId);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      expect(result, Right(testTvDetail));
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(remoteDataSource.getTvDetail(testId)).thenThrow(ServerException());
      // act
      final result = await repository.getTvDetail(testId);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(remoteDataSource.getTvDetail(testId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvDetail(testId);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });
  group('getTvRecommendations', () {
    final testId = 1;
    test('should return tv list when call to data source is successful',
        () async {
      // arrange
      when(remoteDataSource.getTvRecommendations(testId))
          .thenAnswer((_) async => [testTvModel]);
      // act
      final result = await repository.getTvRecommendations(testId);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testTv]);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(remoteDataSource.getTvRecommendations(testId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvRecommendations(testId);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(remoteDataSource.getTvRecommendations(testId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvRecommendations(testId);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });
  group('saveWatchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(localDataSource.insertWatchlist(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTvDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(localDataSource.insertWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });
  group('isAddedToWatchlist', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(localDataSource.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });
  group('removeWatchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(localDataSource.removeWatchlist(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testTvDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(localDataSource.removeWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });
  group('getWatchlistTvs', () {
    test('should return valid tv list when get watchlist', () async {
      // arrange
      when(localDataSource.getWatchlistTvs())
          .thenAnswer((_) async => [testTvTable]);
      // act
      final result = await repository.getWatchlistTvs();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testTvTable.toEntity()]);
    });
  });
  group('searchTvs', () {
    final query = "alice";
    test('should return tv list when call to data source is successful',
        () async {
      // arrange
      when(remoteDataSource.searchTvs(query))
          .thenAnswer((_) async => [testTvModel]);
      // act
      final result = await repository.searchTvs(query);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testTv]);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(remoteDataSource.searchTvs(query)).thenThrow(ServerException());
      // act
      final result = await repository.searchTvs(query);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(remoteDataSource.searchTvs(query))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository. searchTvs(query);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });
}
