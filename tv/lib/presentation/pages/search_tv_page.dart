import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/bloc/bloc/search_movies/search_tvs_bloc.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

class SearchTvPage extends StatelessWidget {
  static const ROUTE_NAME = '/search_tv';

  const SearchTvPage({Key? key}) : super(key: key);

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
                context.read<SearchTvsBloc>().add(OnQueryChanged(query));
              },
              onSubmitted: (query) {
                context.read<SearchTvsBloc>().add(OnQueryChanged(query));
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
    final state = context.watch<SearchTvsBloc>().state;
    if (state is LoadingSearchTvsState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is ErrorSearchTvsState) {
      return const Center(
        child: Text('Failed to Fetch result'),
      );
    }
    if (state is LoadedSearchTvsState) {
      return Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final tv = state.searchResult[index];
            return TvCard(tv);
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
