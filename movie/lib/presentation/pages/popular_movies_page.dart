import 'package:flutter/material.dart';
import 'package:movie/presentation/bloc/cubit/popular_movies/popular_movies_cubit.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  const PopularMoviesPage({Key? key}) : super(key: key);

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PopularMoviesCubit>().loadPopularMovies(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
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
    final state = context.watch<PopularMoviesCubit>().state;
    if (state is ErrorPopularMoviesState) {
      return Center(
        key: const Key('error_message'),
        child: Text(state.message),
      );
    }
    if (state is LoadedPopularMoviesState) {
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
