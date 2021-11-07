import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvWatchListStatus usecase;
  late MockTvRepository repository;
  setUp(() {
    repository = MockTvRepository();
    usecase = GetTvWatchListStatus(repository);
  });
  test('return true when check availability at watchlist', () async {
    //arrange
    when(repository.isAddedToWatchlist(1)).thenAnswer((_) async => true);
    //act
    final result = await usecase.execute(1);
    //assert
    verify(repository.isAddedToWatchlist(1));
    expect(result, true);
  });
}
