import 'package:tv/data/models/episode_model.dart';
import 'package:tv/data/models/genre_model.dart';
import 'package:tv/data/models/season_detail_model.dart';
import 'package:tv/data/models/season_model.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/models/tv_table.dart';
import 'package:tv/domain/entities/episode.dart';
import 'package:tv/domain/entities/genre.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/domain/entities/season_detail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';

final now = DateTime.now();

var testGendre = const Genre(id: 1, name: 'action');
var testGendreModel = const GenreModel(id: 1, name: 'action');
var testSeasonModel = const SeasonModel(
    airDate: null,
    id: 1,
    name: 'null',
    overview: 'null',
    posterPath: 'null',
    seasonNumber: 1,
    episodeCount: 2);

var testSeason = Season(
    airDate: DateTime(0),
    id: 1,
    name: 'null',
    overview: 'null',
    posterPath: 'null',
    seasonNumber: 1,
    episodeCount: 2);
var testEpisodeModel = EpisodeModel(
    airDate: DateTime(2019),
    episodeNumber: 1,
    id: 1,
    name: 'name',
    overview: 'overview',
    seasonNumber: 1,
    stillPath: 'stillPath',
    voteAverage: 2.0,
    voteCount: 50);
var testEpisode = Episode(
    airDate: DateTime(2019),
    episodeNumber: 1,
    id: 1,
    name: 'name',
    overview: 'overview',
    seasonNumber: 1,
    stillPath: 'stillPath',
    voteAverage: 2.0,
    voteCount: 50);
var testTvDetail = TvDetail(
  numberOfEpisodes: 10,
  numberOfSeasons: 2,
  firstAirDate: DateTime(2019),
  episodeRunTime: 45,
  genres: [testGendre],
  id: 1,
  backdropPath: 'backdropPath',
  inProduction: true,
  lastAirDate: DateTime(2020),
  seasons: [testSeason],
  originalName: 'a',
  overview: 'an lorem',
  popularity: 5.0,
  posterPath: 'posterPath',
  voteAverage: 5,
  voteCount: 10,
  status: 'status',
  name: 'name',
  lastEpisodeToAir: testEpisode,
);
var testTvDetail2 = TvDetail(
  numberOfEpisodes: 10,
  numberOfSeasons: 2,
  firstAirDate: DateTime(2019),
  episodeRunTime: 100,
  genres: [testGendre],
  id: 1,
  backdropPath: 'backdropPath',
  inProduction: true,
  lastAirDate: DateTime(2020),
  seasons: const [],
  originalName: 'a',
  overview: 'an lorem',
  popularity: 5.0,
  posterPath: 'posterPath',
  voteAverage: 5,
  voteCount: 10,
  status: 'status',
  name: 'name',
  lastEpisodeToAir: testEpisode,
);

var testTvDetailModel = TvDetailModel(
  numberOfEpisodes: 10,
  numberOfSeasons: 2,
  firstAirDate: DateTime(2019),
  episodeRunTime: const [45],
  genres: [testGendreModel],
  id: 1,
  backdropPath: 'backdropPath',
  inProduction: true,
  lastAirDate: DateTime(2020),
  seasons: [testSeasonModel],
  originalName: 'a',
  overview: 'an lorem',
  popularity: 5.0,
  posterPath: 'posterPath',
  voteAverage: 5,
  voteCount: 10,
  status: 'status',
  name: 'name',
  lastEpisodeToAir: testEpisodeModel,
  languages: const [],
  originalLanguage: '',
  originCountry: const [],
);
var testCache = const TvTable(
  id: 1,
  name: 'name',
  posterPath: 'path',
  overview: 'overview',
);
var testCacheEntity = Tv.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'path',
  overview: 'overview',
);
var testSeasonDetail = SeasonDetail(
  id: '1',
  airDate: DateTime(2019),
  episodes: [testEpisode],
  name: 'name',
  overview: 'overview',
  seasonDetailResponseId: 1,
  posterPath: 'posterPath',
  seasonNumber: 1,
);
final testSeasonDetailModel = SeasonDetailModel(
  id: '1',
  airDate: DateTime(2019),
  episodes: [testEpisodeModel],
  name: 'name',
  overview: 'overview',
  seasonDetailResponseId: 1,
  posterPath: 'posterPath',
  seasonNumber: 1,
);
final testTvModel = TvModel(
  id: 1,
  genreIds: List.generate(2, (index) => 2),
  name: 'nama',
  originalLanguage: 'en',
  originCountry: const ['eng'],
  originalName: 'name',
  firstAirDate: now.toString(),
  popularity: 3.0,
  overview: 'overview',
  backdropPath: '',
  posterPath: '',
  voteAverage: 3.0,
  voteCount: 1000,
);
const testTvTable = TvTable(
  id: 1,
  overview: 'an lorem',
  name: 'name',
  posterPath: 'posterPath',
);
final testTv = Tv(
  id: 1,
  genreIds: List.generate(2, (index) => 2),
  name: 'nama',
  originalLanguage: 'en',
  originCountry: const ['eng'],
  originalName: 'name',
  firstAirDate: now,
  popularity: 3.0,
  overview: 'overview',
  backdropPath: '',
  posterPath: '',
  voteAverage: 3.0,
  voteCount: 1000,
);
var testTvWatchlist = const TvTable(id: 1).toEntity();
