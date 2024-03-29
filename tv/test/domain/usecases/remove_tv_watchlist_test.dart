import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/tv_dummy_objects.dart';
import '../../tv_test.mocks.dart';

void main() {
  late RemoveTvWatchlist usecase;
  late MockTvRepository repository;
  setUp(() {
    repository = MockTvRepository();
    usecase = RemoveTvWatchlist(repository);
  });
  test('return "Removed from Watchlist" when removeWatchlist called', () async {
    //arrange
    when(repository.removeWatchlist(testTvDetail))
        .thenAnswer((_) async => const Right('Removed from Watchlist'));
    //act
    final result = await usecase.execute(testTvDetail);
    //assert
    verify(repository.removeWatchlist(testTvDetail));
    expect(result, const Right('Removed from Watchlist'));
  });
}
