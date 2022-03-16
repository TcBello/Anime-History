import 'dart:async';
import 'dart:convert';

import 'package:anime_history/constants.dart';
import 'package:anime_history/models/anime_history_model.dart';
import 'package:anime_history/models/anime_model.dart';
import 'package:anime_history/models/detail_model.dart';
import 'package:anime_history/models/full_anime_model.dart';
import 'package:anime_history/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimeProvider extends ChangeNotifier{
  // LISTS OF ANIME HISTORY MODELS
  List<AnimeHistoryModel> _animeHistories = [];
  
  List<AnimeHistoryModel> _animeHistorySearchResults = [];
  List<AnimeHistoryModel> get animeHistorySearchResults => _animeHistorySearchResults;

  List<AnimeModel> _topAnimes = [];
  List<AnimeModel> get topAnimes => _topAnimes;

  List<AnimeModel> _recommendationAnimes = [];
  List<AnimeModel> get recommendationAnimes => _recommendationAnimes;

  List<AnimeModel> _seasonNowAnimes = [];
  List<AnimeModel> get seasonNowAnimes => _seasonNowAnimes;

  List<AnimeModel> _seasonUpcomingAnimes = [];
  List<AnimeModel> get seasonUpcomingAnimes => _seasonUpcomingAnimes;

  // STREAM CONTROLLERS
  StreamController<List<AnimeHistoryModel>>? _animeHistoryController;
  StreamController<List<AnimeModel>>? _topAnimeController;
  StreamController<List<AnimeModel>>? _recommendationController;
  StreamController<List<AnimeModel>>? _seasonNowController;
  StreamController<List<AnimeModel>>? _seasonUpcomingController;

  // STREAMS
  Stream<List<AnimeHistoryModel>> get allHistoryStream => _animeHistoryController!.stream;
  Stream<List<AnimeModel>> get topAnimeStream => _topAnimeController!.stream;
  Stream<List<AnimeModel>> get recommendationStream => _recommendationController!.stream;
  Stream<List<AnimeModel>> get seasonNowStream => _seasonNowController!.stream;
  Stream<List<AnimeModel>> get seasonUpcomingStream => _seasonUpcomingController!.stream;

  Future<List<AnimeModel>> search(String title) async {
    // GET DATA FROM SERVER
    var res = await http.get(Uri.parse(searchUrl(title)));

    // DECODE JSON
    var parsedData = jsonDecode(res.body);
    List result = parsedData['data'];
    List<AnimeModel> animeList = [];

    // ADDING LIST BY LOOPING
    for (Map<String, dynamic> json in result){
      animeList.add(AnimeModel.fromJSON(json));
    }

    return animeList;
  }

  Future<FullAnimeModel> getDetails(int id) async {
    // GET DATA FROM SERVER
    var res = await http.get(Uri.parse(fullDetailUrl(id)));

    // DECODE JSON
    var parsedData = jsonDecode(res.body);

    return FullAnimeModel.fromJSON(parsedData['data']);
  }

  void addToHistory(int id, String userId, String url, String image, String title, String titleJapanese, String? titleEnglish, List<String> titleSynonyms, String status,
    String duration, int? rank, bool airing, String synopsis, String source, String type, String episodes, List<DetailModel> producers,
    List<DetailModel> studios, List<DetailModel> licensors, List<DetailModel> genres, double? rating, String? startDate, String? endDate, String? rated,) async {

    var pref = await SharedPreferences.getInstance();

    // NEW LISTS
    List<Map<String, dynamic>> newProducers = [];
    List<Map<String, dynamic>> newStudios = [];
    List<Map<String, dynamic>> newLicensors = [];
    List<Map<String, dynamic>> newGenres = [];

    // Converting Detail Model To Lists of Map
    for(var producer in producers){
      newProducers.add({
        'id': producer.id,
        'type': producer.type,
        'name': producer.name,
        'url': producer.url
      });
    }

    // Converting Detail Model To Lists of Map
    for(var studio in studios){
      newStudios.add({
        'id': studio.id,
        'type': studio.type,
        'name': studio.name,
        'url': studio.url
      });
    }

    // Converting Detail Model To Lists of Map
    for(var licensor in licensors){
      newLicensors.add({
        'id': licensor.id,
        'type': licensor.type,
        'name': licensor.name,
        'url': licensor.url
      });
    }

    // Converting Detail Model To Lists of Map
    for(var genre in genres){
      newGenres.add({
        'id': genre.id,
        'type': genre.type,
        'name': genre.name,
        'url': genre.url
      });
    }

    // RAW DATA
    Map<String, dynamic> data = {
      'id': id,
      'userId': userId,
      'url': url,
      'image': image,
      'title': title,
      'titleJapanese': titleJapanese,
      'titleEnglish': titleEnglish,
      'titleSynonyms': titleSynonyms,
      'status': status,
      'airing': airing,
      'duration': duration,
      'rank': rank,
      'synopsis': synopsis,
      'source': source,
      'type': type,
      'episodes': episodes,
      'producers': newProducers,
      'studios': newStudios,
      'licensors': newLicensors,
      'genres': newGenres,
      'rating': rating,
      'startDate': startDate,
      'endDate': endDate,
      'rated': rated,
    };

    // POST TO SERVER
    var res = await http.post(
      Uri.parse(kAddAnimeUrl),
      headers: jsonHeaderWithToken(pref.getString('token')),
      body: jsonEncode(data)
    );

    var parsedData = jsonDecode(res.body);

    if(res.statusCode != 200){
      showShortToast(parsedData['message']);
    }
    else{
      // ADD DATA TO THE ANIME HISTORY STREAM
      _animeHistories.add(AnimeHistoryModel(
        id: id,
        image: image,
        title: title
      ));
      _animeHistoryController?.sink.add(_animeHistories);
    }
  }

  Stream<bool> isAlreadyOnHistoryStream(int animeId, String userId) async* {
    // POST TO SERVER
    var res = await http.post(
      Uri.parse(kVerifyAnimeHistoryUrl),
      headers: kJsonHeader,
      body: jsonEncode({
        'id': animeId,
        'userId': userId
      })
    );

    if(res.statusCode == 200){
      yield true;
    }
    else{
      yield false;
    }
  }

  void removeFromHistory(int id) async {
    var pref = await SharedPreferences.getInstance();

    // DELETE REQUEST TO SERVER
    var res = await http.delete(
      Uri.parse(kDeleteAnimeUrl),
      headers: jsonHeaderWithToken(pref.getString('token') ?? ""),
      body: jsonEncode({'id': id})
    );

    if(res.statusCode != 200){
      showShortToast("Something went wrong. Please try again!");
    }
    else{
      // REMOVE DATA FROM ANIME HISTORY STREAM
      _animeHistories.removeWhere((element) => element.id == id);
      _animeHistoryController?.add(_animeHistories);
    }
  }

  void getAllHistory(String userId) async {
    // GET FROM SERVER
    var res = await http.get(
      Uri.parse(kAllAnimeHistoryUrl),
      headers: {'request-user-id': userId}
    );

    var parsedData = jsonDecode(res.body);
    List anime = parsedData['data'];

    if(res.statusCode == 200){
      // ADD DATA TO THE ANIME HISTORY STREAM
      _animeHistories = anime.map((e) => AnimeHistoryModel.fromJSON(e)).toList();
      _animeHistoryController?.sink.add(_animeHistories);
    }
  }

  void initResources(String userId){
    // INIT STREAM CONTROLLERS
    _animeHistoryController = BehaviorSubject<List<AnimeHistoryModel>>();
    _topAnimeController = BehaviorSubject<List<AnimeModel>>();
    _recommendationController = BehaviorSubject<List<AnimeModel>>();
    _seasonNowController = BehaviorSubject<List<AnimeModel>>();
    _seasonUpcomingController = BehaviorSubject<List<AnimeModel>>();

    // GET RESOURCES
    getAllHistory(userId);
    getTopAnime();
    getRecentAnimeRecommendations();
    getSeasonNow();
    getSeasonUpcoming();
  }

  // DISPOSE STREAM RESOURCES
  void disposeResources(){
    _animeHistoryController?.close();
    _topAnimeController?.close();
    _recommendationController?.close();
    _seasonNowController?.close();
    _seasonUpcomingController?.close();
    _animeHistoryController = null;
    _topAnimeController = null;
    _recommendationController = null;
    _seasonNowController = null;
    _seasonUpcomingController = null;
  }

  // GET TOP ANIME RANKINGS
  void getTopAnime() async {
    // GET DATA FROM SERVER
    var res = await http.get(Uri.parse(topAnimeUrl()));

    // DECODE JSON
    var parsedData = jsonDecode(res.body);

    List<AnimeModel> animes = [];

    // ADDING LIST BY LOOPING
    if(res.statusCode == 200){
      for(Map<String, dynamic> json in parsedData['data']){
        animes.add(AnimeModel.fromJSON(json));
      }
    }
    else{
      showShortToast("Something went wrong on top anime. Please try again later!");
    }

    _topAnimes = animes;
    
    // ADD DATA TO TOP ANIME STREAM
    _topAnimeController?.sink.add(animes);
  }

  // GET RECENT ANIME RECOMMENDATIONS
  void getRecentAnimeRecommendations() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // GET DATA FROM SERVER
    var res = await http.get(Uri.parse(recentAnimeRecommendationUrl()));

    // DECODE JSON
    var parsedData = jsonDecode(res.body);
    List resultList = parsedData['data'];

    List<AnimeModel> animes = [];
    List<int> ids = [];

    // ADDING LIST BY LOOPING
    if(res.statusCode == 200){
      for(Map<String, dynamic> result in resultList){
        List entries = result['entry'];

        for(Map<String, dynamic> json in entries){
          if(!ids.contains(json['mal_id'])){
            ids.add(json['mal_id']);
            animes.add(AnimeModel.fromJSON(json));
          }
        }
      }
    }
    else{
      showShortToast("Something went wrong on recommendations. Please try again later!");
    }

    _recommendationAnimes = animes;

    // ADD DATA ON ANIME RECOMMENDATION STREAM
    _recommendationController?.sink.add(animes);
  }

  // GET ANIME SEASON NOW
  void getSeasonNow() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // GET DATA FROM SERVER
    var res = await http.get(Uri.parse(seasonNowUrl()));
    
    // DECODE JSON
    var parsedData = jsonDecode(res.body);

    List<AnimeModel> animes = [];

    // ADDING LIST BY LOOPING
    if(res.statusCode == 200){
      for(Map<String, dynamic> json in parsedData['data']){
        animes.add(AnimeModel.fromJSON(json));
      }
    }
    else{
      showShortToast("Something went wrong on season now. Please try again later!");
    }

    _seasonNowAnimes = animes;

    // ADD DATA ON ANIME SEASON NOW STREAM
    _seasonNowController?.sink.add(animes);
  }

  // GET UPCOMING SEASON OF ANIME
  void getSeasonUpcoming() async {
    await Future.delayed(const Duration(seconds: 4));

    // GET DATA FROM SERVER
    var res = await http.get(Uri.parse(seasonUpcomingUrl()));

    // DECODE JSON
    var parsedData = jsonDecode(res.body);

    List<AnimeModel> animes = [];

    // ADDING LIST BY LOOPING
    if(res.statusCode == 200){
      for(Map<String, dynamic> json in parsedData['data']){
        animes.add(AnimeModel.fromJSON(json));
      }
    }
    else{
      showShortToast("Something went wrong on upcoming anime. Please try again later!");
    }

    _seasonUpcomingAnimes = animes;

    // ADD DATA ON ANIME SEASON UPCOMING STREAM
    _seasonUpcomingController?.sink.add(animes);
  }

  // SEARCH ANIME ON HISTORY
   void searchHistory(String query){
    _animeHistorySearchResults = _animeHistories.where((element) => element.title.toLowerCase().contains(query)).toList();
  }
}