import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testDetail = MovieDetailResponse(
    adult: true,
    backdropPath: 'backdropPath',
    budget: 1,
    genres: [],
    homepage: '',
    id: 1,
    imdbId: '1',
    originalLanguage: "en",
    originalTitle: '',
    overview: '',
    popularity: 1,
    posterPath: 'path',
    releaseDate: '',
    revenue: 1,
    runtime: 1,
    status: '',
    tagline: '',
    title: 'title',
    video: true,
    voteAverage: 1,
    voteCount: 1,
  );
  final testJson = {
    "adult": true,
    "backdrop_path": 'backdropPath',
    "budget": 1,
    "genres": [],
    "homepage": '',
    "id": 1,
    "imdb_id": '1',
    "original_language": 'en',
    "original_title": '',
    "overview": '',
    "popularity": 1,
    "poster_path": 'path',
    "release_date": '',
    "revenue": 1,
    "runtime": 1,
    "status": '',
    "tagline": '',
    "title": 'title',
    "video": true,
    "vote_average": 1.0,
    "vote_count": 1,
  };
  test('should return valid object when use factory fromJson', () {
    var detail = MovieDetailResponse.fromJson(testJson);
    expect(detail, testDetail);
  });
  test('should return valid jsonMap', () {
    var map = testDetail.toJson();
    expect(map, testJson);
  });
}
