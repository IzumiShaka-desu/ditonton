import 'package:flutter/material.dart';
import 'package:movie/presentation/bloc/cubit/top_rated_movies/top_rated_movies_cubit.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';
import 'package:provider/provider.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  const TopRatedMoviesPage({Key? key}) : super(key: key);

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TopRatedMoviesCubit>().loadTopRatedMovies(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: const Padding(
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
    final state = context.watch<TopRatedMoviesCubit>().state;
    if (state is ErrorTopRatedMoviesState) {
      return Center(
        key: const Key('error_message'),
        child: Text(state.message),
      );
    }
    if (state is LoadedTopRatedMoviesState) {
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
