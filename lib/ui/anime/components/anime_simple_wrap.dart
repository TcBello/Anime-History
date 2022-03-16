// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class AnimeSimpleWrap extends StatelessWidget {
  const AnimeSimpleWrap({
    Key? key,
    required this.spacing,
    required this.list,
    required this.title,
    required this.size
  }) : super(key: key);

  final double spacing;
  final List<String> list;
  final String title;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.9,
      child: list.isNotEmpty
      ? Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: List.generate(list.length, (index) => index == 0
          ? RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(text: "$title: ", style: Theme.of(context).textTheme.bodyText1),
                TextSpan(text: list[index])
              ]
            )
          )
          : Text(list[index])
        )
      )
      : Text("$title: ", style: Theme.of(context).textTheme.bodyText1,),
    );
  }
}