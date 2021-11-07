import 'dart:convert';

import 'package:ditonton/data/models/episode_model.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final testTvDetail = TvDetailModel(
    backdropPath: '/oaGvjB0DvdhXhOAuADfHb261ZHa.jpg',
    episodeRunTime: [54],
    firstAirDate: DateTime(2021, 09, 17),
    genres: [
      GenreModel(id: 10759, name: 'Action & Adventure'),
      GenreModel(id: 9648, name: "Mystery")
    ],
    id: 93405,
    inProduction: false,
    languages: ["en", "ar", "ko"],
    lastAirDate: DateTime(2021, 09, 17),
    lastEpisodeToAir: EpisodeModel(
      airDate: DateTime(2021, 09, 17),
      episodeNumber: 9,
      id: 2,
      seasonNumber: 1,
    ),
    name: "Squid Game",
    numberOfEpisodes: 9,
    numberOfSeasons: 1,
    originCountry: ["KR"],
    originalLanguage: "ko",
    originalName: "오징어 게임",
    overview:
        "Hundreds of cash-strapped players accept a strange invitation to compete in children's games—with high stakes. But, a tempting prize awaits the victor.",
    popularity: 10283.353,
    posterPath: "/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg",
    seasons: [
      SeasonModel(
          airDate: DateTime(2021, 09, 17),
          episodeCount: 9,
          id: 131977,
          name: "Season 1",
          overview:
              "Hundreds of cash-strapped players accept a strange invitation to compete in children's games. Inside, a tempting prize awaits — with deadly high stakes.",
          posterPath: "/lDm3AjG0ZsPRAz1qHD0em8pzTTp.jpg",
          seasonNumber: 1)
    ],
    status: 'Ended',
    voteAverage: 7.9,
    voteCount: 6788,
  );
  TvDetailModel(
    backdropPath: '/oaGvjB0DvdhXhOAuADfHb261ZHa.jpg',
    episodeRunTime: [54],
    firstAirDate: DateTime(2021, 09, 17),
    genres: [
      GenreModel(id: 10759, name: 'Action & Adventure'),
      GenreModel(id: 9648, name: "Mystery")
    ],
    id: 93405,
    inProduction: false,
    languages: ["en", "ar", "ko"],
    lastAirDate: DateTime(2021, 09, 17),
    lastEpisodeToAir: EpisodeModel(
      airDate: DateTime(2021, 09, 17),
      episodeNumber: 9,
      seasonNumber: 1,
      id: 2,
    ),
    name: "Squid Game",
    numberOfEpisodes: 9,
    numberOfSeasons: 1,
    originCountry: ["KR"],
    originalLanguage: "ko",
    originalName: "오징어 게임",
    overview:
        "Hundreds of cash-strapped players accept a strange invitation to compete in children's games—with high stakes. But, a tempting prize awaits the victor.",
    popularity: 10283.353,
    posterPath: "/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg",
    seasons: [
      SeasonModel(
          airDate: DateTime(2021, 09, 17),
          episodeCount: 9,
          id: 131977,
          name: "Season 1",
          overview:
              "Hundreds of cash-strapped players accept a strange invitation to compete in children's games. Inside, a tempting prize awaits — with deadly high stakes.",
          posterPath: "/lDm3AjG0ZsPRAz1qHD0em8pzTTp.jpg",
          seasonNumber: 1)
    ],
    status: 'Ended',
    voteAverage: 7.9,
    voteCount: 6788,
  );
  final testEntity = TvDetail(
    backdropPath: '/oaGvjB0DvdhXhOAuADfHb261ZHa.jpg',
    episodeRunTime: 54,
    firstAirDate: DateTime(2021, 09, 17),
    genres: [
      Genre(id: 10759, name: 'Action & Adventure'),
      Genre(id: 9648, name: "Mystery")
    ],
    id: 93405,
    inProduction: false,
    lastAirDate: DateTime(2021, 09, 17),
    lastEpisodeToAir: Episode(
      airDate: DateTime(2021, 09, 17),
      episodeNumber: 9,
      seasonNumber: 1,
      id: 2,
      name: 'null',
      overview: 'null',
      stillPath: 'null',
      voteAverage: null,
      voteCount: null,
    ),
    name: "Squid Game",
    numberOfEpisodes: 9,
    numberOfSeasons: 1,
    originalName: "오징어 게임",
    overview:
        "Hundreds of cash-strapped players accept a strange invitation to compete in children's games—with high stakes. But, a tempting prize awaits the victor.",
    popularity: 10283.353,
    posterPath: "/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg",
    seasons: [
      Season(
          airDate: DateTime(2021, 09, 17),
          episodeCount: 9,
          id: 131977,
          name: "Season 1",
          overview:
              "Hundreds of cash-strapped players accept a strange invitation to compete in children's games. Inside, a tempting prize awaits — with deadly high stakes.",
          posterPath: "/lDm3AjG0ZsPRAz1qHD0em8pzTTp.jpg",
          seasonNumber: 1)
    ],
    status: 'Ended',
    voteAverage: 7.9,
    voteCount: 6788,
  );
  final testJsonMap = {
    "backdrop_path": "/oaGvjB0DvdhXhOAuADfHb261ZHa.jpg",
    "episode_run_time": [54],
    "first_air_date": "2021-09-17",
    "genres": [
      {"id": 10759, "name": "Action & Adventure"},
      {"id": 9648, "name": "Mystery"}
    ],
    "id": 93405,
    "in_production": false,
    "languages": ["en", "ar", "ko"],
    "last_air_date": "2021-09-17",
    "last_episode_to_air": {
      "air_date": "2021-09-17",
      "episode_number": 9,
      "id": 2,
      "name": null,
      "overview": null,
      "production_code": null,
      "season_number": 1,
      "still_path": null,
      "vote_average": null,
      "vote_count": null
    },
    "name": "Squid Game",
    "number_of_episodes": 9,
    "number_of_seasons": 1,
    "origin_country": ["KR"],
    "original_language": "ko",
    "original_name": "오징어 게임",
    "overview":
        "Hundreds of cash-strapped players accept a strange invitation to compete in children's games—with high stakes. But, a tempting prize awaits the victor.",
    "popularity": 10283.353,
    "poster_path": "/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg",
    "seasons": [
      {
        "air_date": "2021-09-17",
        "episode_count": 9,
        "id": 131977,
        "name": "Season 1",
        "overview":
            "Hundreds of cash-strapped players accept a strange invitation to compete in children's games. Inside, a tempting prize awaits — with deadly high stakes.",
        "poster_path": "/lDm3AjG0ZsPRAz1qHD0em8pzTTp.jpg",
        "season_number": 1
      }
    ],
    "status": "Ended",
    "vote_average": 7.9,
    "vote_count": 6788
  };
  test('should return a valid model from json', () {
    //arrange
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/tv_detail.json'));
    //act
    final result = TvDetailModel.fromJson(jsonMap);

    //assert
    expect(result, testTvDetail);
  });
  test('should return valid json map', () {
    //arrange
    //act
    final jsonMap = testTvDetail.toJson();
    //assert
    expect(jsonMap, testJsonMap);
  });
  test('should return valid entity ', () {
    //arrange
    final entity = testTvDetail.toEntity();
    //act
    //assert
    expect(entity, testEntity);
  });
}
