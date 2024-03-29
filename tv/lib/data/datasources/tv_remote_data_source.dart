import 'dart:convert';

import 'package:core/utils/exception.dart';
import 'package:http/http.dart' as http;
import 'package:tv/data/models/season_detail_model.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/models/tv_response.dart';

abstract class TvRemoteDataSource {
  Future<List<TvModel>> getNowPlayingTvs();
  Future<List<TvModel>> getTopRatedTvs();
  Future<List<TvModel>> getPopularTvs();
  Future<TvDetailModel> getTvDetail(int id);
  Future<SeasonDetailModel> getSeasonDetail(int id, int seasonNumber);
  Future<List<TvModel>> searchTvs(String query);
  Future<List<TvModel>> getTvRecommendations(int id);
}

class TvRemoteDataSourceImpl extends TvRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvRemoteDataSourceImpl({required this.client});
  @override
  Future<List<TvModel>> getNowPlayingTvs() async {
    final response = await client.get(
      Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'),
    );
    if (response.statusCode == 200) {
      return TvResponse.fromJson(
        json.decode(response.body),
      ).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getPopularTvs() async {
    final response = await client.get(
      Uri.parse('$BASE_URL/tv/popular?$API_KEY'),
    );
    if (response.statusCode == 200) {
      return TvResponse.fromJson(
        json.decode(response.body),
      ).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SeasonDetailModel> getSeasonDetail(int id, int seasonNumber) async {
    final response = await client.get(
      Uri.parse('$BASE_URL/tv/$id/season/$seasonNumber?$API_KEY'),
    );
    if (response.statusCode == 200) {
      return SeasonDetailModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRatedTvs() async {
    final response = await client.get(
      Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'),
    );
    if (response.statusCode == 200) {
      return TvResponse.fromJson(
        json.decode(response.body),
      ).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailModel> getTvDetail(int id) async {
    final response = await client.get(
      Uri.parse('$BASE_URL/tv/$id?$API_KEY'),
    );
    if (response.statusCode == 200) {
      return TvDetailModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvRecommendations(int id) async {
    final response = await client.get(
      Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'),
    );
    if (response.statusCode == 200) {
      return TvResponse.fromJson(
        json.decode(response.body),
      ).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTvs(String query) async {
    final response = await client.get(
      Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'),
    );
    if (response.statusCode == 200) {
      return TvResponse.fromJson(
        json.decode(response.body),
      ).tvList;
    } else {
      throw ServerException();
    }
  }
}
