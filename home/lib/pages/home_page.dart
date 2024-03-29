import 'package:about/about.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:home/widgets/custom_sliver_header.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/pages/search_page.dart';
import 'package:tv/presentation/pages/search_tv_page.dart';
import 'package:tv/tv.dart';

import 'watchlist_home_page.dart';

class HomePage extends StatefulWidget {
  static String routeName = 'homepage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _menu = const ['Movie', 'Tv Series', 'Watchlist'];
  String _currentMenu = '';

  int get _currentPosition => _menu.indexOf(_currentMenu);

  late final PageController _pageController;

  final _views = [
    const HomeMoviePage(),
    const HomeTvPage(),
    const WathcListHomePage(),
  ];
  double get _currentOffset {
    var distances = ((_currentPosition + 1) * ((_currentPosition + 1) * 0.8));
    return -0.28 * distances;
  }

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 40,
              actions: [
                Tooltip(
                  message: 'open drawer menu',
                  child: InkWell(
                    onTap: () => Scaffold.of(context).openEndDrawer(),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/circle-g.png'),
                    ),
                  ),
                )
              ],
              floating: false,
              pinned: false,
              title: Container(
                height: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Ditonton',
                          style: Theme.of(context).textTheme.headline5,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
              leading: AnimatedOpacity(
                opacity: _currentMenu.isEmpty ? 0 : 1,
                duration: const Duration(milliseconds: 350),
                child: _currentMenu.isEmpty
                    ? const SizedBox()
                    : IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () => setState(() {
                          _currentMenu = '';
                        }),
                      ),
              ),
            ),
            SliverPersistentHeader(
              delegate: CustomSliverHeader(
                AppBar(
                  toolbarHeight: 75,
                  title: _animatedMenuBuilder(),
                  actions: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: ['', _menu.last].contains(_currentMenu) ? 0 : 1,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            _currentMenu == _menu.first
                                ? SearchPage.ROUTE_NAME
                                : SearchTvPage.ROUTE_NAME,
                          );
                        },
                        icon: const Icon(Icons.search),
                      ),
                    )
                  ],
                ),
              ),
              pinned: true,
            )
          ];
        },
        body: Container(
          child: PageView.builder(
            itemBuilder: (ctx, index) {
              return AnimatedOpacity(
                opacity: [index, -1].contains(_currentPosition) ? 1 : 0,
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 200),
                child: AnimatedSlide(
                  offset: Offset(
                      0, [index, -1].contains(_currentPosition) ? 0 : -1),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.fastOutSlowIn,
                  child: _views.elementAt(index),
                ),
              );
            },
            scrollDirection: Axis.vertical,
            dragStartBehavior: DragStartBehavior.down,
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: _views.length,
          ),
        ),
      ),
    );
  }

  Row _animatedMenuBuilder() {
    return Row(
      children: _menu
          .map(
            (e) => AnimatedOpacity(
              opacity: _currentMenu == e || _currentMenu.isEmpty ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Tooltip(
                  message: 'menu $e',
                  child: InkWell(
                    onTap: _currentMenu.isNotEmpty
                        ? null
                        : () {
                            if (_currentMenu != e) {
                              setState(() {
                                _currentMenu = e;

                                _pageController.jumpToPage(
                                  _currentPosition,
                                );
                              });
                            }
                          },
                    child: AnimatedSlide(
                      offset:
                          Offset(_currentMenu.isEmpty ? 0 : _currentOffset, 0),
                      curve: Curves.fastOutSlowIn,
                      duration: const Duration(milliseconds: 350),
                      child: Text(e),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
