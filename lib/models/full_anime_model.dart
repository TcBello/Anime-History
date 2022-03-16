import 'package:anime_history/models/detail_model.dart';

class FullAnimeModel{
  final int id;
  final String url;
  final String image;
  final String title;
  final String titleJapanese;
  final String? titleEnglish;
  final List<String> titleSynonyms;
  final bool airing;
  final String status;
  final String synopsis;
  final String duration;
  final int? rank;
  final List<DetailModel> producers; // return type of {mal_id: x, type: x, name:  PROD NAME, url: x}
  final List<DetailModel> studios; // return type of {mal_id: x, type: x, name: STUD NAME, url: x}
  final List<DetailModel> licensors; // return type of {mal_id: x, type: x, name: LICEN NAME, url: x}
  final List<DetailModel> genres; // return type of {mal_id: x, type: x, name: GENRE NAME, url: x}
  final String source;
  final String type;
  final String episodes;
  final double? rating;
  final String? startDate;
  final String? endDate;
  final String? rated;

  FullAnimeModel({
    this.id = 0,
    this.url = "",
    this.image = "",
    this.title = "",
    this.titleJapanese = "",
    this.titleEnglish,
    this.titleSynonyms = const [""],
    this.airing = false,
    this.status = "",
    this.synopsis = "",
    this.duration = "",
    this.rank,
    this.producers = const [],
    this.studios = const[],
    this.licensors = const [],
    this.genres = const [],
    this.source = "",
    this.type = "",
    this.episodes = "",
    this.rating,
    this.startDate,
    this.endDate,
    this.rated
  });

  static FullAnimeModel fromJSON(Map<String, dynamic> json){
    return FullAnimeModel(
      id: json['mal_id'],
      url: json['url'],
      image: json['images']['jpg']['large_image_url'],
      title: json['title'],
      titleJapanese: json['title_japanese'],
      titleEnglish: json['title_english'] ?? "",
      titleSynonyms: List<String>.from(json['title_synonyms'].map((e) => e)),
      airing: json['airing'],
      status: json['status'],
      synopsis: json['synopsis'] ?? "No Summary Available",
      duration: json['duration'],
      rank: json['rank'] ?? 0,
      producers: json['producers'].isNotEmpty
        ? List<DetailModel>.from(json['producers'].map((json) => DetailModel.fromJSON(json)))
        : [],
      studios: json['studios'].isNotEmpty
        ? List<DetailModel>.from(json['studios'].map((json) => DetailModel.fromJSON(json)))
        : [],
      licensors: json['licensors'].isNotEmpty
        ? List<DetailModel>.from(json['licensors'].map((json) => DetailModel.fromJSON(json)))
        : [],
      genres: json['genres'].isNotEmpty
        ? List<DetailModel>.from(json['genres'].map((json) => DetailModel.fromJSON(json)))
        : [],
      source: json['source'],
      type: json['type'],
      episodes: json['episodes'] != null
        ? json['episodes'].toString()
        : "Unknown",
      rating: json['score'] ?? 0,
      startDate: json['aired']['from'].runtimeType == String
        ? json['aired']['from']
        : null,
      endDate: json['aired']['to'].runtimeType == String
        ? json['aired']['to']
        : null,
      rated: json['rating'].runtimeType == String
        ? json['rating']
        : null
    );
  }
}