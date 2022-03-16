import 'package:flutter/material.dart';

class BackgroundText extends StatelessWidget {
  const BackgroundText({
    Key? key,
    required this.text,
    this.color = Colors.blue
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Text(text, style: const TextStyle(color: Colors.white),),
    );
  }
}