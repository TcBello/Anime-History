// ignore_for_file: sized_box_for_whitespace

import 'package:anime_history/models/detail_model.dart';
import 'package:anime_history/ui/anime/components/background_text.dart';
import 'package:flutter/material.dart';

class AnimeWrap extends StatelessWidget {
  const AnimeWrap({
    Key? key,
    required this.spacing,
    required this.detailModelList,
    required this.title,
    required this.size
  }) : super(key: key);

  final double spacing;
  final List<DetailModel> detailModelList;
  final String title;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.9,
      child: detailModelList.isNotEmpty
      ? Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: List.generate(detailModelList.length, (index) => index == 0
          ? Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text("$title: ", style: Theme.of(context).textTheme.bodyText1,),
              BackgroundText(text: detailModelList[index].name)
            ],
          )
          : BackgroundText(text: detailModelList[index].name)
        )
      )
      : Text("$title: "),
    );
  }
}