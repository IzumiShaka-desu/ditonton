import 'dart:io';

import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie/data/models/movie_table.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getNowPlayingMovies();
        localDataSource.cacheNowPlayingMovies(
          result
              .map(
                (movie) => MovieTable.fromDTO(movie),
              )
              .toList(),
        );
        return Right(
          result
              .map(
                (model) => model.toEntity(),
              )
              .toList(),
        );
        // ignore: nullable_type_in_catch_clause
      } on ServerException {
        return Left(
          ServerFailure(''),
        );
      } on SocketException {
        return Left(
          ConnectionFailure('Failed to connect to the network'),
        );
      }
    } else {
      try {
        final result = await localDataSource.getCachedNowPlayingMovies();
        return Right(
          result
              .map(
                (model) => model.toEntity(),
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
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async {
    try {
      final result = await remoteDataSource.getMovieDetail(id);
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
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getMovieRecommendations(id);
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

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    try {
      final result = await remoteDataSource.getPopularMovies();
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

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async {
    try {
      final result = await remoteDataSource.getTopRatedMovies();
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

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final result = await remoteDataSource.searchMovies(query);
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

  @override
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie) async {
    try {
      final result = await localDataSource.insertWatchlist(
        MovieTable.fromEntity(movie),
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
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie) async {
    try {
      final result = await localDataSource.removeWatchlist(
        MovieTable.fromEntity(movie),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(
        DatabaseFailure(e.message),
      );
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getMovieById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() async {
    final result = await localDataSource.getWatchlistMovies();
    return Right(
      result
          .map(
            (data) => data.toEntity(),
          )
          .toList(),
    );
  }
}
