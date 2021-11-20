import 'dart:convert';
import 'dart:io';
import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/data/models/season_detail_model.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/data/models/tv_response.dart';
import 'package:tv/tv.dart';

import '../../json_reader.dart';
import '../../tv_test.mocks.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';
  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient client;
  setUp(() {
    client = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: client);
  });
  group('get now playing', () {
    final testList = TvResponse.fromJson(
            json.decode(readJson('dummy_data/tv_on_the_air.json')))
        .tvList;
    test('should return valid tv list when status code is 200', () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_on_the_air.json'), 200));
      // act
      final result = await dataSource.getNowPlayingTvs();
      //assert

      verify(client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')));
      expect(result, equals(testList));
    });
    test('should throw ServerException when status code is not 200 ', () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Internal Server Error', 500));
      // act
      final result = dataSource.getNowPlayingTvs();
      //assert
      verify(client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')));
      expect(result, throwsA(isA<ServerException>()));
    });
  });
  group('get top rated', () {
    const jsonName = 'dummy_data/tv_top_rated.json';
    final testList =
        TvResponse.fromJson(json.decode(readJson(jsonName))).tvList;
    test('should return valid tv list when status code is 200', () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response(readJson(jsonName), 200));
      // act
      final result = await dataSource.getTopRatedTvs();
      //assert

      verify(client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')));
      expect(result, equals(testList));
    });
    test('should throw ServerException when status code is not 200 ', () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Internal Server Error', 500));
      // act
      final result = dataSource.getTopRatedTvs();
      //assert
      verify(client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')));
      expect(result, throwsA(isA<ServerException>()));
    });
  });
  group('get popular', () {
    const jsonName = 'dummy_data/tv_popular.json';
    final testList =
        TvResponse.fromJson(json.decode(readJson(jsonName))).tvList;
    test('should return valid tv list when status code is 200', () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response(readJson(jsonName), 200));
      // act
      final result = await dataSource.getPopularTvs();
      //assert

      verify(client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')));
      expect(result, equals(testList));
    });
    test('should throw ServerException when status code is not 200 ', () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Internal Server Error', 500));
      // act
      final result = dataSource.getPopularTvs();
      //assert
      verify(client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')));
      expect(result, throwsA(isA<ServerException>()));
    });
  });
  group('get detail tv', () {
    const jsonName = 'dummy_data/tv_detail.json';
    const testId = 1;
    final testDetail = TvDetailModel.fromJson(json.decode(readJson(jsonName)));
    test('should return valid tv detail when status code is 200', () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/$testId?$API_KEY'))).thenAnswer(
          (_) async => http.Response(readJson(jsonName), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));
      // act
      final result = await dataSource.getTvDetail(testId);
      //assert

      verify(client.get(Uri.parse('$BASE_URL/tv/$testId?$API_KEY')));
      expect(result, equals(testDetail));
    });
    test('should throw ServerException when status code is not 200 ', () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/$testId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Internal Server Error', 500));
      // act
      final result = dataSource.getTvDetail(testId);
      //assert

      verify(client.get(Uri.parse('$BASE_URL/tv/$testId?$API_KEY')));

      expect(result, throwsA(isA<ServerException>()));
    });
  });
  group('get recommendations tv', () {
    const jsonName = 'dummy_data/tv_recommendations.json';
    const testId = 1;
    final testList =
        TvResponse.fromJson(json.decode(readJson(jsonName))).tvList;
    test('should return valid list tv when status code is 200', () async {
      // arrange
      when(client
              .get(Uri.parse('$BASE_URL/tv/$testId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                  readJson(jsonName), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));
      // act
      final result = await dataSource.getTvRecommendations(testId);
      //assert

      verify(client
          .get(Uri.parse('$BASE_URL/tv/$testId/recommendations?$API_KEY')));
      expect(result, equals(testList));
    });
    test('should throw ServerException when status code is not 200 ', () async {
      // arrange
      when(client
              .get(Uri.parse('$BASE_URL/tv/$testId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Internal Server Error', 500));
      // act
      final result = dataSource.getTvRecommendations(testId);
      //assert

      verify(client
          .get(Uri.parse('$BASE_URL/tv/$testId/recommendations?$API_KEY')));

      expect(result, throwsA(isA<ServerException>()));
    });
  });
  group('search tv', () {
    const jsonName = 'dummy_data/tv_alice_search.json';

    const keyword = "alice";
    final testList =
        TvResponse.fromJson(json.decode(readJson(jsonName))).tvList;
    test('should return valid list tv when status code is 200', () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$keyword')))
          .thenAnswer((_) async => http.Response(
                  readJson(jsonName), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));
      // act
      final result = await dataSource.searchTvs(keyword);
      //assert

      verify(
          client.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$keyword')));
      expect(result, equals(testList));
    });
    test('should throw ServerException when status code is not 200 ', () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$keyword')))
          .thenAnswer((_) async => http.Response('Internal Server Error', 500));
      // act
      final result = dataSource.searchTvs(keyword);
      //assert

      verify(
          client.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$keyword')));

      expect(result, throwsA(isA<ServerException>()));
    });
  });
  group('get season detail', () {
    const jsonName = 'dummy_data/season_detail.json';
    const testId = 1;
    final testModel =
        SeasonDetailModel.fromJson(json.decode(readJson(jsonName)));
    test('should return valid list tv when status code is 200', () async {
      // arrange
      when(client
              .get(Uri.parse('$BASE_URL/tv/$testId/season/$testId?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                  readJson(jsonName), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));
      // act
      final result = await dataSource.getSeasonDetail(testId, testId);
      //assert

      verify(client
          .get(Uri.parse('$BASE_URL/tv/$testId/season/$testId?$API_KEY')));
      expect(result, equals(testModel));
    });
    test('should throw ServerException when status code is not 200 ', () async {
      // arrange
      when(client
              .get(Uri.parse('$BASE_URL/tv/$testId/season/$testId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Internal Server Error', 500));
      // act
      final result = dataSource.getSeasonDetail(testId, testId);
      //assert

      verify(client
          .get(Uri.parse('$BASE_URL/tv/$testId/season/$testId?$API_KEY')));

      expect(result, throwsA(isA<ServerException>()));
    });
  });
}
