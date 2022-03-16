// ignore_for_file: sized_box_for_whitespace

import 'package:anime_history/models/anime_model.dart';
import 'package:anime_history/provider/anime_provider.dart';
import 'package:anime_history/ui/anime/anime.dart';
import 'package:anime_history/widgets/anime_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Results extends StatelessWidget {
  const Results({
     Key? key,
     required this.query
  }) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<AnimeProvider>(
      builder: (context, anime, child) {
        return FutureBuilder<List<AnimeModel>>(
          future: anime.search(query),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 20,
                    children: List.generate(snapshot.data!.length, (index){
                      if(snapshot.data!.isNotEmpty && snapshot.hasData){
                        var animes = snapshot.data!;

                        // ANIME CARD
                        return AnimeCard(
                          anime: animes[index],
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Anime(id: animes[index].id))),
                        );
                      }
                      else{
                        // NO RESULT
                        return Container(
                          height: size.height,
                          width: size.width,
                          child: const Center(
                            child: Text("No Result"),
                          ),
                        );
                      }
                    }),
                  ),
                ),
              );
            }
            else{
              return Container(
                width: size.width,
                height: size.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
        );
      }
    );
  }
}