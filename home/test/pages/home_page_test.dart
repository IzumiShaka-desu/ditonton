import 'package:about/about_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/home.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/bloc/search_movies/search_movies_bloc.dart'
    as m;
import 'package:movie/presentation/bloc/cubit/movie_list/movie_list_cubit.dart';
import 'package:movie/presentation/pages/search_page.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/bloc/bloc/search_movies/search_tvs_bloc.dart';
import 'package:tv/presentation/bloc/cubit/tv_list/tv_list_cubit.dart';
import 'package:tv/tv.dart';

class MockSearchTvsBloc extends MockBloc<SearchTvsEvent, SearchTvsState>
    implements SearchTvsBloc {}

class FakeLoadingSearchTvsState extends Fake implements LoadingSearchTvsState {}

class FakeLoadedSearchTvsState extends Fake implements LoadedSearchTvsState {}

class FakeErrorSearchTvsState extends Fake implements ErrorSearchTvsState {}

class FakeOnQueryChanged extends Fake implements OnQueryChanged {}

class MockMovieListCubit extends MockCubit<MovieListState>
    implements MovieListCubit {}

class FakeLoadingMovieListState extends Fake implements LoadingMovieListState {}

class FakeLoadedMovieListState extends Fake implements LoadedMovieListState {}

class FakeErrorMovieListState extends Fake implements ErrorMovieListState {}

class MockTvListCubit extends MockCubit<TvListState> implements TvListCubit {}

class FakeLoadingTvListState extends Fake implements LoadingTvListState {}

class FakeLoadedTvListState extends Fake implements LoadedTvListState {}

class FakeErrorTvListState extends Fake implements ErrorTvListState {}

class MockSearchMoviesBloc
    extends MockBloc<m.SearchMoviesEvent, m.SearchMoviesState>
    implements m.SearchMoviesBloc {}

class FakeLoadingSearchMoviesState extends Fake
    implements m.LoadingSearchMoviesState {}

class FakeLoadedSearchMoviesState extends Fake
    implements m.LoadedSearchMoviesState {}

class FakeErrorSearchMoviesState extends Fake
    implements m.ErrorSearchMoviesState {}

class FakeOnQueryMChanged extends Fake implements m.OnQueryChanged {}

main() {
  late TvListCubit mockTvCubit;
  late MovieListCubit mockCubit;
  late SearchTvsBloc searchTvsBloc;
  late m.SearchMoviesBloc searchMoviesBloc;
  setUpAll(() {
    registerFallbackValue(FakeLoadingSearchMoviesState());
    registerFallbackValue(FakeLoadedSearchMoviesState());
    registerFallbackValue(FakeErrorSearchMoviesState());
    registerFallbackValue(FakeOnQueryMChanged());
    registerFallbackValue(FakeLoadingSearchTvsState());
    registerFallbackValue(FakeLoadedSearchTvsState());
    registerFallbackValue(FakeErrorSearchTvsState());
    registerFallbackValue(FakeOnQueryChanged());
    registerFallbackValue(FakeLoadingTvListState());
    registerFallbackValue(FakeLoadedTvListState());
    registerFallbackValue(FakeErrorTvListState());
    registerFallbackValue(FakeLoadingMovieListState());
    registerFallbackValue(FakeLoadedMovieListState());
    registerFallbackValue(FakeErrorMovieListState());
  });
  setUp(() {
    mockTvCubit = MockTvListCubit();
    mockCubit = MockMovieListCubit();
    searchTvsBloc = MockSearchTvsBloc();
    searchMoviesBloc = MockSearchMoviesBloc();
  });
  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieListCubit>(create: (ctx) => mockCubit),
        BlocProvider<TvListCubit>(create: (ctx) => mockTvCubit),
        BlocProvider<SearchTvsBloc>(create: (ctx) => searchTvsBloc),
        BlocProvider<m.SearchMoviesBloc>(create: (ctx) => searchMoviesBloc),
      ],
      child: MaterialApp(
          home: body,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case SearchPage.ROUTE_NAME:
                return CupertinoPageRoute(builder: (_) => const SearchPage());
              case AboutPage.ROUTE_NAME:
                return CupertinoPageRoute(builder: (_) => const AboutPage());
            }
          }),
    );
  }

  final now = DateTime.now();
  final testTv = Tv(
    id: 1,
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

  final testMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  testWidgets('Page should display tv home page and go to search',
      (WidgetTester tester) async {
    final testDataTv = LoadedTvListState(
      nowPlaying: [testTv],
      topRated: [testTv],
      popular: [testTv],
    );
    final testDataSearch = m.InitialSearchMoviesState();

    when(() => searchMoviesBloc.state).thenAnswer((_) => testDataSearch);
    // when(() => mockBloc.)
    //     .thenAnswer((invocation) async => invocation);
    whenListen(searchMoviesBloc, Stream.fromIterable([testDataSearch]));
    when(() => mockTvCubit.state).thenAnswer((_) => testDataTv);
    when(() => mockTvCubit.loadTvList())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testDataTv]));
    final testData = LoadedMovieListState(
      nowPlaying: [testMovie],
      topRated: [testMovie],
      popular: [testMovie],
    );
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadMovieList())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final homePage = find.byType(HomeMoviePage);

    final menuTvSeries = find.byTooltip('menu Tv Series');
    await tester.pumpWidget(
      _makeTestableWidget(const HomePage()),
    );
    expect(homePage, findsOneWidget);
    expect(menuTvSeries, findsOneWidget);

    await tester.tap(menuTvSeries);
    await tester.pump();
    final homeTvPage = find.byType(HomeTvPage);
    final backButton = find.widgetWithIcon(IconButton, Icons.chevron_left);
    expect(homeTvPage, findsOneWidget);
    expect(backButton, findsOneWidget);
    await tester.tap(backButton);
    await tester.pump();
    final menuMovie = find.byTooltip('menu Movie');
    expect(menuMovie, findsOneWidget);
    await tester.tap(menuMovie);
    await tester.pump();
    final searchButton = find.widgetWithIcon(IconButton, Icons.search);
    expect(searchButton, findsOneWidget);
    await tester.tap(searchButton);
    await tester.pump();
  });

  testWidgets('Page should display tv home page and open drawer',
      (WidgetTester tester) async {
    final testDataTv = LoadedTvListState(
      nowPlaying: [testTv],
      topRated: [testTv],
      popular: [testTv],
    );
    when(() => mockTvCubit.state).thenAnswer((_) => testDataTv);
    when(() => mockTvCubit.loadTvList())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testDataTv]));
    final testData = LoadedMovieListState(
      nowPlaying: [testMovie],
      topRated: [testMovie],
      popular: [testMovie],
    );
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadMovieList())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));
    final finder = find.byTooltip('open drawer menu');
    await tester.pumpWidget(
      _makeTestableWidget(const HomePage()),
    );
    await tester.tap(finder);
    await tester.pump();
  });
  testWidgets('test open drawer', (WidgetTester tester) async {
    final testDataTv = LoadedTvListState(
      nowPlaying: [testTv],
      topRated: [testTv],
      popular: [testTv],
    );
    when(() => mockTvCubit.state).thenAnswer((_) => testDataTv);
    when(() => mockTvCubit.loadTvList())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testDataTv]));
    final testData = LoadedMovieListState(
      nowPlaying: [testMovie],
      topRated: [testMovie],
      popular: [testMovie],
    );
    when(() => mockCubit.state).thenAnswer((_) => testData);
    when(() => mockCubit.loadMovieList())
        .thenAnswer((invocation) async => invocation);
    whenListen(mockCubit, Stream.fromIterable([testData]));

    final finder = find.byTooltip('open drawer menu');
    await tester.pumpWidget(
      _makeTestableWidget(const HomePage()),
    );
    await tester.tap(finder);
    await tester.pump(const Duration(seconds: 1));
    await tester.dragFrom(
        tester.getTopRight(find.byType(Scaffold).first), const Offset(-300, 0));
    await tester.pump(const Duration(seconds: 1));

    final aboutMenu = find.widgetWithText(ListTile, "About");
    expect(aboutMenu, findsOneWidget);
    await tester.tap(aboutMenu);
  });
}
