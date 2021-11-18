import 'package:core/core.dart';
import 'package:core/utils/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:tv/tv.dart';

@GenerateMocks([
  DatabaseHelper,
  NetworkInfo,
  TvRepository,
  TvLocalDataSource,
  TvRemoteDataSource
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
