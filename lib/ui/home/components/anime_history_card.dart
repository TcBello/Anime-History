import 'package:anime_history/models/anime_history_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AnimeHistoryCard extends StatelessWidget {
  const AnimeHistoryCard({
    Key? key,
    required this.anime,
    required this.onPressed
  }) : super(key: key);

  final AnimeHistoryModel anime;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      // ignore: sized_box_for_whitespace
      child: Container(
        width: 180,
        child: Column(
          children: [
            // PICTURE
            // ignore: sized_box_for_whitespace
            Container(
              height: 250,
              width: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(imageUrl: anime.image, fit: BoxFit.cover,),
              ),
            ),
            const SizedBox(height: 10,),
            // TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                anime.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1
              ),
            )
          ],
        ),
      ),
    );
  }
}