import 'package:core/core.dart';
import 'package:core/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/cubit/movie_list/movie_list_cubit.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/presentation/widgets/poster_image.dart';
import 'package:provider/provider.dart';

import 'movie_detail_page.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({Key? key}) : super(key: key);

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() {
    Future.microtask(() => context.read<MovieListCubit>().loadMovieList());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MovieListCubit>().state;

    super.build(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: state is ErrorMovieListState
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("cannot establish connection"),
                    const Icon(
                        Icons.signal_wifi_connected_no_internet_4_outlined),
                    TextButton(
                      onPressed: fetchMovies,
                      child: const Text("Retry"),
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Now Playing',
                      style: kHeading6,
                    ),
                    const _NowPlayingMovies(),
                    _buildSubHeading(
                      title: 'Popular',
                      onTap: () => Navigator.pushNamed(
                          context, PopularMoviesPage.ROUTE_NAME),
                    ),
                    const _PopularMovies(),
                    _buildSubHeading(
                      title: 'Top Rated',
                      onTap: () => Navigator.pushNamed(
                          context, TopRatedMoviesPage.ROUTE_NAME),
                    ),
                    const _TopRatedMovies(),
                  ],
                ),
              ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        Tooltip(
          message: 'navigate to $title',
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  Text('See More'),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _NowPlayingMovies extends StatelessWidget {
  const _NowPlayingMovies({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MovieListCubit>().state;
    if (state is LoadedMovieListState) {
      if (state.nowPlaying.isEmpty) {
        return const Tooltip(
          message: 'failed to load movies',
          child: Text('Failed'),
        );
      }
      return MovieList(state.nowPlaying);
    }
    return const Center(child: CircularProgressIndicator());
  }
}

class _PopularMovies extends StatelessWidget {
  const _PopularMovies({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MovieListCubit>().state;
    if (state is LoadedMovieListState) {
      if (state.popular.isEmpty) {
        return const Tooltip(
          message: 'failed to load movies',
          child: Text('Failed'),
        );
      }
      return MovieList(state.popular);
    }
    return const Center(child: CircularProgressIndicator());
  }
}

class _TopRatedMovies extends StatelessWidget {
  const _TopRatedMovies({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MovieListCubit>().state;
    if (state is LoadedMovieListState) {
      if (state.topRated.isEmpty) {
        return const Tooltip(
          message: 'failed to load movies',
          child: Text('Failed'),
        );
      }
      return MovieList(state.topRated);
    }
    return const Center(child: CircularProgressIndicator());
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
                child: PosterImage(
                  url: '$BASE_IMAGE_URL${movie.posterPath}',
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
