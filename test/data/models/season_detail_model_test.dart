import 'dart:convert';

import 'package:ditonton/data/models/season_detail_model.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final testEntity = SeasonDetail(
    id: '5d753a082ea6b90010bff496',
    name: "Season 1",
    airDate: DateTime(2021, 09, 17),
    episodes: [],
    seasonDetailResponseId: 131977,
    posterPath: "/lDm3AjG0ZsPRAz1qHD0em8pzTTp.jpg",
    seasonNumber: 1,
    overview:
        "Hundreds of cash-strapped players accept a strange invitation to compete in children's games. Inside, a tempting prize awaits — with deadly high stakes.",
  );
  final testModel = SeasonDetailModel(
    id: '5d753a082ea6b90010bff496',
    name: "Season 1",
    airDate: DateTime(2021, 09, 17),
    episodes: [],
    seasonDetailResponseId: 131977,
    posterPath: "/lDm3AjG0ZsPRAz1qHD0em8pzTTp.jpg",
    seasonNumber: 1,
    overview:
        "Hundreds of cash-strapped players accept a strange invitation to compete in children's games. Inside, a tempting prize awaits — with deadly high stakes.",
  );
  final testJsonMap = {
    "_id": "5d753a082ea6b90010bff496",
    "air_date": "2021-09-17",
    "episodes": [],
    "name": "Season 1",
    "overview":
        "Hundreds of cash-strapped players accept a strange invitation to compete in children's games. Inside, a tempting prize awaits — with deadly high stakes.",
    "id": 131977,
    "poster_path": "/lDm3AjG0ZsPRAz1qHD0em8pzTTp.jpg",
    "season_number": 1
  };
  test('should return a valid model from json', () {
    //arrange
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/Season_detail.json'));
    //act
    final result = SeasonDetailModel.fromJson(jsonMap);

    //assert
    expect(result, testModel);
  });
  test('should return a valid entity from json', () {
    //arrange
    //act
    final result = testModel.toEntity();

    //assert
    expect(result, testEntity);
  });
  test('should return valid json map', () {
    //arrange
    //act
    final jsonMap = testModel.toJson();
    //assert
    expect(jsonMap, testJsonMap);
  });
}
