// ignore_for_file: unused_local_variable

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:movie/presentation/bloc/bloc/search_movies/search_movies_bloc.dart';
import 'package:movie/presentation/provider/movie_search_notifier.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchMoviesBloc>().add(OnQueryChanged(query));
              },
              onSubmitted: (query) {
                context.read<SearchMoviesBloc>().add(OnQueryChanged(query));
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            const _ResultsWidget(),
          ],
        ),
      ),
    );
  }
}

class _ResultsWidget extends StatelessWidget {
  const _ResultsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SearchMoviesBloc>().state;
    if (state is LoadingSearchMoviesState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is ErrorSearchMoviesState) {
      return const Center(
        child: Text('Failed to Fetch result'),
      );
    }
    if (state is LoadedSearchMoviesState) {
      return Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final movie = state.searchResult[index];
            return MovieCard(movie);
          },
          itemCount: state.searchResult.length,
        ),
      );
    }
    return Expanded(
      child: Container(),
    );
  }
}
