import 'package:anime_history/models/anime_model.dart';
import 'package:anime_history/ui/anime/anime.dart';
import 'package:anime_history/widgets/anime_card.dart';
import 'package:flutter/material.dart';

class ViewAllAnime extends StatelessWidget {
  const ViewAllAnime({
    Key? key,
    required this.animes,
    this.hasLabel = false,
    required this.title
    }) : super(key: key);

    final List<AnimeModel> animes;
    final bool hasLabel;
    final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        // ignore: sized_box_for_whitespace
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Wrap(
              spacing: 10,
              runSpacing: 20,
              children: List.generate(animes.length, (index) => AnimeCard(
                anime: animes[index],
                hasLabel: hasLabel,
                label: (index + 1).toString(),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Anime(id: animes[index].id))),
              )),
            ),
          ),
        ),
      ),
    );
  }
}