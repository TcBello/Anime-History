import 'package:anime_history/models/anime_model.dart';
import 'package:anime_history/ui/anime/anime.dart';
import 'package:anime_history/widgets/anime_card.dart';
import 'package:flutter/material.dart';

class StreamAnimeBrowseContent extends StatelessWidget {
  const StreamAnimeBrowseContent({
    Key? key,
    required this.stream,
    this.limit = 10,
    this.hasLabel = false
  }) : super(key: key);

  final Stream<List<AnimeModel>> stream;
  final int limit;
  final bool hasLabel;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AnimeModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          final animes = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                animes.isEmpty
                  ? 0
                  : limit, (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                // ANIME CARD
                child: AnimeCard(
                  anime: animes[index],
                  hasLabel: hasLabel,
                  label: (index + 1).toString(),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Anime(id: animes[index].id))),
                ),
              )),
            ),
          );
        }
        else{
          // LOADING
          return const Center(
            child: SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}