import 'package:flutter/material.dart';

class AnimeRichText extends StatelessWidget {
  const AnimeRichText({
    Key? key,
    required this.title,
    required this.content
    }) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: "$title: ",
            style: Theme.of(context).textTheme.bodyText1
          ),
          TextSpan(
            text: content,
            style: Theme.of(context).textTheme.bodyText2
          )
        ]
      ),
    );
  }
}
