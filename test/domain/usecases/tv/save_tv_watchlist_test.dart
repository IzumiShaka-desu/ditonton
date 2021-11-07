import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/save_tv_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvRepository repository;
  late SaveTvWatchlist usecase;
  setUp(() {
    repository = MockTvRepository();
    usecase = SaveTvWatchlist(repository);
  });
  test('return "Added to Watchlist" when saveWatchlist Called', () async {
    //arrange
    when(repository.saveWatchlist(testTvDetail))
        .thenAnswer((realInvocation) async => Right("Added to Watchlist"));
    //act
    final result = await usecase.execute(testTvDetail);
    //assert
    verify(repository.saveWatchlist(testTvDetail));
    expect(result, Right("Added to Watchlist"));
  });
}
