import 'package:anime_history/constants.dart';
import 'package:anime_history/widgets/load_popup.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

String searchUrl(String title, {String page = "1"}) => "$kBaseApi/anime?q=$title";

String fullDetailUrl(int id) => "$kBaseApi/anime/$id";

String topAnimeUrl() => "$kBaseApi/top/anime";

String recentAnimeRecommendationUrl() => "$kBaseApi/recommendations/anime";

String seasonNowUrl() => "$kBaseApi/seasons/now";

String seasonUpcomingUrl() => "$kBaseApi/seasons/upcoming";

// SHOW A SHORT TOAST
void showShortToast(String msg) async{
  await Fluttertoast.cancel();
  Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT);
}

// JSON HEADER
Map<String, String> jsonHeaderWithToken(String? token) => {
  'Content-type': 'application/json',
  'Accept': 'application/json',
  'authorization': token ?? ""
};

// SHOW LOAD POPUP
void showLoad(BuildContext context){
  showDialog(
    context: context,
    builder: (context) => const LoadPopup(),
    barrierDismissible: false
  );
}