import 'dart:io';

import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/data/models/tv_table.dart';
import 'package:tv/domain/entities/season_detail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class TvRepositoryImpl extends TvRepository {
  final TvLocalDataSource localDataSource;
  final TvRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TvRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<Tv>>> getNowPlayingTvs() async {
    if (await networkInfo.isConnected) {
      try {
        final results = await remoteDataSource.getNowPlayingTvs();
        localDataSource.cacheNowPlayingTvs(
          results
              .map(
                (e) => TvTable.fromDTO(e),
              )
              .toList(),
        );
        return Right(
          results
              .map(
                (e) => e.toEntity(),
              )
              .toList(),
        );
      } on ServerException {
        return Left(
          ServerFailure(''),
        );
      } on SocketException {
        return Left(
          ConnectionFailure('Failed Connect to Network'),
        );
      }
    } else {
      try {
        final res = await localDataSource.getCachedNowPlayingTvs();
        return Right(
          res
              .map(
                (e) => e.toEntity(),
              )
              .toList(),
        );
      } on CacheException catch (e) {
        return Left(
          CacheFailure(e.message),
        );
      }
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getPopularTvs() async {
    try {
      final results = await remoteDataSource.getPopularTvs();
      return Right(
        results
            .map(
              (e) => e.toEntity(),
            )
            .toList(),
      );
    } on ServerException {
      return Left(
        ServerFailure(''),
      );
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, SeasonDetail>> getSeasonDetail(
      int id, int seasonNumber) async {
    try {
      final result = await remoteDataSource.getSeasonDetail(id, seasonNumber);
      return Right(
        result.toEntity(),
      );
    } on ServerException {
      return Left(
        ServerFailure(''),
      );
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTvs() async {
    try {
      final results = await remoteDataSource.getTopRatedTvs();
      return Right(
        results
            .map(
              (e) => e.toEntity(),
            )
            .toList(),
      );
    } on ServerException {
      return Left(
        ServerFailure(''),
      );
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, TvDetail>> getTvDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvDetail(id);
      return Right(
        result.toEntity(),
      );
    } on ServerException {
      return Left(
        ServerFailure(''),
      );
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id) async {
    try {
      final results = await remoteDataSource.getTvRecommendations(id);
      return Right(
        results
            .map(
              (e) => e.toEntity(),
            )
            .toList(),
      );
    } on ServerException {
      return Left(
        ServerFailure(''),
      );
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getWatchlistTvs() async {
    final result = await localDataSource.getWatchlistTvs();
    return Right(
      result
          .map(
            (data) => data.toEntity(),
          )
          .toList(),
    );
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getTvById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv) async {
    try {
      final result = await localDataSource.removeWatchlist(
        TvTable.fromEntity(tv),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(
        DatabaseFailure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv) async {
    try {
      final result = await localDataSource.insertWatchlist(
        TvTable.fromEntity(tv),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(
        DatabaseFailure(e.message),
      );
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTvs(String query) async {
    try {
      final result = await remoteDataSource.searchTvs(query);
      return Right(
        result
            .map(
              (model) => model.toEntity(),
            )
            .toList(),
      );
    } on ServerException {
      return Left(
        ServerFailure(''),
      );
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }
}
