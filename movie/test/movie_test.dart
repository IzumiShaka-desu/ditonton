import 'package:core/core.dart';
import 'package:core/utils/network_info.dart';
import 'package:mockito/annotations.dart';

import 'package:movie/movie.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
  NetworkInfo,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
