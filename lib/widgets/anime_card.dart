// ignore_for_file: sized_box_for_whitespace

import 'package:anime_history/models/anime_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AnimeCard extends StatelessWidget {
  const AnimeCard({
    Key? key,
    required this.anime,
    required this.onPressed,
    this.hasLabel = false,
    this.label = ""
  }) : super(key: key);

  final AnimeModel anime;
  final Function() onPressed;
  final bool hasLabel;
  final String label;

  final double _imageHeight = 250;
  final double _imageWidth = 180;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: _imageWidth,
        child: Column(
          children: [
            // PICTURE
            Container(
              height: _imageHeight,
              width: _imageWidth,
              child: Stack(
                children: [
                  SizedBox(
                    height: _imageHeight,
                    width: _imageWidth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(imageUrl: anime.image, fit: BoxFit.cover,),
                    ),
                  ),
                  // STAR ICON
                  Visibility(
                    visible: hasLabel,
                    child: const Positioned(
                      right: 0,
                      child: Icon(Icons.star, color: Colors.yellow, size: 50,),
                    ),
                  ),
                  // LABEL
                  Visibility(
                    visible: hasLabel,
                    child: Positioned(
                      right: 16,
                      top: 18,
                      child: Container(
                        width: 18,
                        height: 18,
                        child: Center(child: Text(label, style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold),),),
                      ),
                    ),
                  )
                ],
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