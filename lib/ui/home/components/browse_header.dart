import 'package:flutter/material.dart';

class BrowseHeader extends StatelessWidget {
  const BrowseHeader({
    Key? key,
    required this.title,
    required this.onViewAll
  }) : super(key: key);

  final String title;
  final Function() onViewAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.headline6),
          TextButton(
            child: const Text("View All"),
            onPressed: onViewAll,
          )
        ],
      ),
    );
  }
}