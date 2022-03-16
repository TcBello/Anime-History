// ignore_for_file: sized_box_for_whitespace

import 'package:anime_history/models/detail_model.dart';
import 'package:anime_history/provider/anime_provider.dart';
import 'package:anime_history/provider/user_provider.dart';
import 'package:anime_history/ui/anime/components/anime_rich_text.dart';
import 'package:anime_history/ui/anime/components/anime_simple_wrap.dart';
import 'package:anime_history/ui/anime/components/anime_wrap.dart';
import 'package:anime_history/ui/anime/components/detail.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class AnimeContent extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final parsedStartDate = startDate != null
      ? Jiffy(startDate ?? "").yMMMd
      : "";
    final parsedEndDate = endDate != null
      ? Jiffy(endDate ?? "").yMMMd
      : "";

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: size.height * 0.42),
        padding: const EdgeInsets.only(top: 30, bottom: 10),
        width: size.width,
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
                  width: size.width * 0.8,
                  child: Center(
                    child: Text(
                      title,
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
                  spacing: _kWrapSpacing,
                  list: titleSynonyms,
                  size: size,
                  title: "Synonyms",
                )
              ),
              // TITLE JAPANESE
              Detail(
                child: AnimeRichText(title: "Japanese", content: titleJapanese)
              ),
              // TITLE ENGLISH
              Detail(
                child: AnimeRichText(title: "English", content: titleEnglish ?? "")
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
                child: AnimeRichText(title: "Rating", content: rating.toString()),
              ),
              // RANK
              Detail(
                child: AnimeRichText(title: "Rank", content: "#$rank"),
              ),
              // TYPE
              Detail(
                child: AnimeRichText(title: "Type", content: type),
              ),
              // EPISODES
              Detail(
                child: AnimeRichText(title: "Episodes", content: episodes),
              ),
              // STATUS
              Detail(
                child: AnimeRichText(title: "Status", content: status),
              ),
              // DATE AIRED (START DATE - END DATE)
              Detail(
                child: AnimeRichText(title: "Rating", content: "$parsedStartDate - $parsedEndDate"),
              ),
              // PRODUCERS
              Detail(
                child: AnimeWrap(
                  spacing: _kWrapSpacing,
                  detailModelList: producers,
                  title: "Producers",
                  size: size
                ),
              ),
              // LICENSORS
              Detail(
                child: AnimeWrap(
                  spacing: _kWrapSpacing,
                  detailModelList: licensors,
                  title: "Licensors",
                  size: size
                ),
              ),
              // STUDIOS
              Detail(
                child: AnimeWrap(
                  spacing: _kWrapSpacing,
                  detailModelList: studios,
                  title: "Studios",
                  size: size
                ),
              ),
              // SOURCE
              Detail(
                child: AnimeRichText(title: "Source", content: source),
              ),
              // GENRE
              Detail(
                child: AnimeWrap(
                  spacing: _kWrapSpacing,
                  detailModelList: genres,
                  title: "Genres",
                  size: size
                ),
              ),
              // DURATION
              Detail(
                child: AnimeRichText(title: "Duration", content: duration),
              ),
              // RATED
              Detail(
                child: AnimeRichText(title: "Rated", content: rated ?? ""),
              ),
              // SUMMARY
              Detail(
                child: Text("Summary:", style: Theme.of(context).textTheme.bodyText1,),
              ),
              Detail(
                child: Text("       $synopsis", style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  height: 1.5
                ),),
              ),
              // ADD TO HISTORY BUTTON
              Consumer2<AnimeProvider, UserProvider>(
                builder: (context, anime, user, child) {
                  return Align(
                    alignment: Alignment.center,
                    child: Detail(
                      padding: const EdgeInsets.only(top: 40),
                      child: StreamBuilder<bool>(
                        stream: anime.isAlreadyOnHistoryStream(id, user.id),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            if(!snapshot.data!){
                              return SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 50,
                                child: TextButton(
                                  child: const Text("ADD TO HISTORY"),
                                  onPressed: () => anime.addToHistory(id, user.id, url, image, title, titleJapanese, titleEnglish, titleSynonyms, status, duration, rank, airing, synopsis, source, type, episodes, producers, studios, licensors, genres, rating, startDate, endDate, rated),
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
                                  onPressed: () => anime.removeFromHistory(id),
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
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}