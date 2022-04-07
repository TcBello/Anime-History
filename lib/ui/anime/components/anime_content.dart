// ignore_for_file: sized_box_for_whitespace

import 'package:anime_history/models/detail_model.dart';
import 'package:anime_history/provider/anime_provider.dart';
import 'package:anime_history/provider/user_provider.dart';
import 'package:anime_history/ui/anime/components/anime_rich_text.dart';
import 'package:anime_history/ui/anime/components/anime_simple_wrap.dart';
import 'package:anime_history/ui/anime/components/anime_wrap.dart';
import 'package:anime_history/ui/anime/components/detail.dart';
import 'package:anime_history/utils.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class AnimeContent extends StatefulWidget {
  const AnimeContent({
    Key? key,
    required this.size,
    required this.id,
    required this.url,
    required this.image,
    required this.title,
    required this.titleJapanese,
    required this.titleEnglish,
    required this.titleSynonyms,
    required this.status,
    required this.airing,
    required this.duration,
    required this.rank,
    required this.synopsis,
    required this.source,
    required this.type,
    required this.episodes,
    required this.producers,
    required this.studios,
    required this.licensors,
    required this.genres,
    required this.rating,
    required this.startDate,
    required this.endDate,
    required this.rated,
  }) : super(key: key);

  final Size size;
  final int id;
  final String url;
  final String image;
  final String title;
  final String titleJapanese;
  final String? titleEnglish;
  final List<String> titleSynonyms;
  final String status;
  final String duration;
  final int? rank;
  final bool airing;
  final String synopsis;
  final String source;
  final String type;
  final String episodes;
  final List<DetailModel> producers;
  final List<DetailModel> studios;
  final List<DetailModel> licensors;
  final List<DetailModel> genres;
  final double? rating;
  final String? startDate;
  final String? endDate;
  final String? rated;

  static const double _kWrapSpacing = 5;

  @override
  State<AnimeContent> createState() => _AnimeContentState();
}

class _AnimeContentState extends State<AnimeContent> {
  AnimeProvider? animeProvider;

  @override
  void initState() {
    animeProvider = context.read<AnimeProvider>();
    var userProvider = context.read<UserProvider>();
    animeProvider?.initAnimeHistoryStatus(widget.id, userProvider.id);
    super.initState();
  }

  @override
  void dispose() {
    animeProvider?.disposeAnimeHistoryStatus();
    animeProvider = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final anime = context.read<AnimeProvider>();
    final user = context.read<UserProvider>();
    
    final parsedStartDate = widget.startDate != null
      ? Jiffy(widget.startDate ?? "").yMMMd
      : "";
    final parsedEndDate = widget.endDate != null
      ? Jiffy(widget.endDate ?? "").yMMMd
      : "";

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: widget.size.height * 0.42),
        padding: const EdgeInsets.only(top: 30, bottom: 10),
        width: widget.size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30)
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ANIME TITLE
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: widget.size.width * 0.8,
                  child: Center(
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              ),
              // ALTERNATIVE TITLE
              Detail(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Alternative Title",
                  style: Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
                ),
              ),
              // TITLE SYNONYMS
              Detail(
                child: AnimeSimpleWrap(
                  spacing: AnimeContent._kWrapSpacing,
                  list: widget.titleSynonyms,
                  size: widget.size,
                  title: "Synonyms",
                )
              ),
              // TITLE JAPANESE
              Detail(
                child: AnimeRichText(title: "Japanese", content: widget.titleJapanese)
              ),
              // TITLE ENGLISH
              Detail(
                child: AnimeRichText(title: "English", content: widget.titleEnglish ?? "")
              ),
              // INFORMATION HEADER
              Detail(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Information",
                  style: Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
                ),
              ),
              // RATING
              Detail(
                child: AnimeRichText(title: "Rating", content: widget.rating.toString()),
              ),
              // RANK
              Detail(
                child: AnimeRichText(title: "Rank", content: "#${widget.rank}"),
              ),
              // TYPE
              Detail(
                child: AnimeRichText(title: "Type", content: widget.type),
              ),
              // EPISODES
              Detail(
                child: AnimeRichText(title: "Episodes", content: widget.episodes),
              ),
              // STATUS
              Detail(
                child: AnimeRichText(title: "Status", content: widget.status),
              ),
              // DATE AIRED (START DATE - END DATE)
              Detail(
                child: AnimeRichText(title: "Date Aired", content: "$parsedStartDate - $parsedEndDate"),
              ),
              // PRODUCERS
              Detail(
                child: AnimeWrap(
                  spacing: AnimeContent._kWrapSpacing,
                  detailModelList: widget.producers,
                  title: "Producers",
                  size: widget.size
                ),
              ),
              // LICENSORS
              Detail(
                child: AnimeWrap(
                  spacing: AnimeContent._kWrapSpacing,
                  detailModelList: widget.licensors,
                  title: "Licensors",
                  size: widget.size
                ),
              ),
              // STUDIOS
              Detail(
                child: AnimeWrap(
                  spacing: AnimeContent._kWrapSpacing,
                  detailModelList: widget.studios,
                  title: "Studios",
                  size: widget.size
                ),
              ),
              // SOURCE
              Detail(
                child: AnimeRichText(title: "Source", content: widget.source),
              ),
              // GENRE
              Detail(
                child: AnimeWrap(
                  spacing: AnimeContent._kWrapSpacing,
                  detailModelList: widget.genres,
                  title: "Genres",
                  size: widget.size
                ),
              ),
              // DURATION
              Detail(
                child: AnimeRichText(title: "Duration", content: widget.duration),
              ),
              // RATED
              Detail(
                child: AnimeRichText(title: "Rated", content: widget.rated ?? ""),
              ),
              // SUMMARY
              Detail(
                child: Text("Summary:", style: Theme.of(context).textTheme.bodyText1,),
              ),
              Detail(
                child: Text("       ${widget.synopsis}", style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  height: 1.5
                ),),
              ),
              // ADD TO HISTORY BUTTON
              Align(
                alignment: Alignment.center,
                child: Detail(
                  padding: const EdgeInsets.only(top: 40),
                  child: StreamBuilder<bool>(
                    stream: anime.isAlreadyOnHistoryStream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        if(!snapshot.data!){
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            child: TextButton(
                              child: const Text("ADD TO HISTORY"),
                              onPressed: () async {
                                showLoad(context);
                                await anime.addToHistory(widget.id, user.id, widget.url, widget.image, widget.title, widget.titleJapanese, widget.titleEnglish, widget.titleSynonyms, widget.status, widget.duration, widget.rank, widget.airing, widget.synopsis, widget.source, widget.type, widget.episodes, widget.producers, widget.studios, widget.licensors, widget.genres, widget.rating, widget.startDate, widget.endDate, widget.rated);
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue),
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.button?.copyWith(fontSize: 16)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
                              ),
                            ),
                          );
                        }
                        else{
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            child: TextButton(
                              child: const Text("REMOVE FROM HISTORY"),
                              onPressed: () async {
                                showLoad(context);
                                await anime.removeFromHistory(widget.id);
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.red),
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.button?.copyWith(fontSize: 16)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
                              ),
                            ),
                          );
                        }
                      }
                      else{
                        // LOADING
                        return const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}