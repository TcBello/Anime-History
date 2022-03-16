import 'package:anime_history/provider/anime_provider.dart';
import 'package:anime_history/ui/anime/anime.dart';
import 'package:anime_history/ui/home/components/anime_history_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultHistory extends StatefulWidget {
  const ResultHistory({
    Key? key,
    required this.query
  }) : super(key: key);

  final String query;

  @override
  State<ResultHistory> createState() => _ResultHistoryState();
}

class _ResultHistoryState extends State<ResultHistory> {

  @override
  void initState() {
    var anime = context.read<AnimeProvider>();
    anime.searchHistory(widget.query);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimeProvider>(
      builder: (context, anime, child) {
        return SingleChildScrollView(
          // ignore: sized_box_for_whitespace
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Wrap(
                spacing: 10,
                runSpacing: 20,
                children: List.generate(anime.animeHistorySearchResults.length, (index) => AnimeHistoryCard(
                  anime: anime.animeHistorySearchResults[index],
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Anime(id: anime.animeHistorySearchResults[index].id))),
                )),
              ),
            ),
          ),
        );
      },
    );
  }
}