import 'package:anime_history/provider/anime_provider.dart';
import 'package:anime_history/ui/home/components/browse_header.dart';
import 'package:anime_history/ui/home/components/future_anime_browse_content.dart';
import 'package:anime_history/ui/home/components/view_all_anime.dart';
import 'package:anime_history/ui/profile/profile.dart';
import 'package:anime_history/ui/search/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrowseAnime extends StatelessWidget {
  const BrowseAnime({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final anime = context.read<AnimeProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Browse Anime"),
        // PROFILE BUTTON
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: MaterialButton(
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
            color: Colors.white,
            child: const Icon(Icons.person),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()))
          ),
        ),
        actions: [
          // SEARCH BUTTON
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: Search())
          ),
        ],
      ),
      body: SingleChildScrollView(
        // ignore: sized_box_for_whitespace
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              // TOP ANIME
              BrowseHeader(
                title: "Top Anime",
                onViewAll: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAllAnime(
                  animes: anime.topAnimes,
                  title: "Top Animes",
                  hasLabel: true,
                ))),
              ),
              StreamAnimeBrowseContent(stream: anime.topAnimeStream, hasLabel: true,),
              // RECENT ANIME RECOMMENDATIONS
              BrowseHeader(
                title: "Recommendation",
                onViewAll: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAllAnime(animes: anime.recommendationAnimes, title: "Recommendations"))),
              ),
              StreamAnimeBrowseContent(stream: anime.recommendationStream),
              // SEASON NOW
              BrowseHeader(
                title: "This Season",
                onViewAll: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAllAnime(animes: anime.seasonNowAnimes, title: "This Season"))),
              ),
              StreamAnimeBrowseContent(stream: anime.seasonNowStream),
              // SEASON UPCOMING
              BrowseHeader(
                title: "Upcoming Season",
                onViewAll: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAllAnime(animes: anime.seasonUpcomingAnimes, title: "Season Upcoming"))),
              ),
              StreamAnimeBrowseContent(stream: anime.seasonUpcomingStream),
            ],
          ),
        ),
      ),
    );
  }
}