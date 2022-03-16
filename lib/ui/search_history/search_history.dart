import 'package:anime_history/ui/search_history/components/result_history.dart';
import 'package:flutter/material.dart';

class SearchHistory extends SearchDelegate{
  @override
  List<Widget>? buildActions(BuildContext context) {
  }

  @override
  Widget? buildLeading(BuildContext context) {
  }

  @override
  Widget buildResults(BuildContext context) {
    return ResultHistory(query: query,);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    var theme = Theme.of(context).copyWith(
      textSelectionTheme: Theme.of(context).textSelectionTheme.copyWith(
        cursorColor: Colors.white
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        errorBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
      hintColor: Colors.grey[300],
      textTheme: Theme.of(context).textTheme.copyWith(
        headline6: const TextStyle(
          color: Colors.white,
          fontSize: 20
        )
      )
    );
    return theme;
  }

  @override
  InputDecorationTheme? get searchFieldDecorationTheme{
    return const InputDecorationTheme(
      border: InputBorder.none,
      errorBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
    );
  }
}