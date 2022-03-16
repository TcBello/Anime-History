// ignore_for_file: sized_box_for_whitespace

import 'package:anime_history/provider/anime_provider.dart';
import 'package:anime_history/provider/user_provider.dart';
import 'package:anime_history/ui/home/components/browse_anime.dart';
import 'package:anime_history/ui/home/components/history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AnimeProvider? _animeProvider;

  List<Widget> pages = const [History(), BrowseAnime()];
  int pageIndex = 0;

  @override
  void initState() {
    _animeProvider = context.read<AnimeProvider>();
    var user = context.read<UserProvider>();
    _animeProvider?.initResources(user.id);
    super.initState();
  }

  @override
  void dispose() {
    _animeProvider?.disposeResources();
    _animeProvider = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // HISTORY & BROWSE ANIME PAGES
      body: pages[pageIndex],
      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        items: const [
          // HISTORY
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History"
          ),
          // BROWSE ANIME
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: "Browse Anime"
          )
        ],
      ),
    );
  }
}