import 'package:flutter/material.dart';
import 'package:movie/presentation/bloc/cubit/watchlist_movies/watchlist_movies_cubit.dart';
import 'package:movie/presentation/provider/watchlist_movie_notifier.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  const WatchlistMoviesPage({Key? key}) : super(key: key);

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<WatchlistMoviesCubit>().loadWatchlistMovies(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WatchlistMoviesCubit>().state;
    if (state is ErrorWatchlistMoviesState) {
      return Center(
        key: const Key('error_message'),
        child: Text(state.message),
      );
    }
    if (state is LoadedWatchlistMoviesState) {
      return ListView.builder(
        itemBuilder: (context, index) {
          final movie = state.movies[index];
          return MovieCard(movie);
        },
        itemCount: state.movies.length,
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
