// ignore_for_file: sized_box_for_whitespace

import 'package:anime_history/models/full_anime_model.dart';
import 'package:anime_history/provider/anime_provider.dart';
import 'package:anime_history/ui/anime/components/anime_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Anime extends StatelessWidget {
  const Anime({
    Key? key,
    required this.id
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 50,
          toolbarHeight: 50,
          leading: Container(
            margin: const EdgeInsets.only(
              left: 10,
              top: 10
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30)
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
          width: size.width,
          height: size.height,
          child: Consumer<AnimeProvider>(
            builder: (context, animeProvider, child) {
              return FutureBuilder<FullAnimeModel>(
                future: animeProvider.getDetails(id),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    var anime = snapshot.data!;
                    
                    return Stack(
                      children: [
                        // PICTURE
                        Container(
                          width: size.width,
                          height: size.height * 0.5,
                          child: CachedNetworkImage(imageUrl: anime.image, fit: BoxFit.cover,),
                        ),
                        // CONTENT
                        AnimeContent(
                          size: size,
                          id: id,
                          image: anime.image,
                          title: anime.title,
                          airing: anime.airing,
                          synopsis: anime.synopsis,
                          source: anime.source,
                          type: anime.type,
                          episodes: anime.episodes,
                          rating: anime.rating,
                          startDate: anime.startDate,
                          endDate: anime.endDate,
                          rated: anime.rated,
                          duration: anime.duration,
                          genres: anime.genres,
                          licensors: anime.licensors,
                          producers: anime.producers,
                          rank: anime.rank,
                          status: anime.status,
                          studios: anime.studios,
                          titleEnglish: anime.titleEnglish,
                          titleJapanese: anime.titleJapanese,
                          titleSynonyms: anime.titleSynonyms,
                          url: anime.url
                        )
                      ],
                    );
                  }
                  else{
                    // LOADING
                    return const Center(child: CircularProgressIndicator(),);
                  }
                }
              );
            }
          ),
        ),
      ),
    );
  }
}