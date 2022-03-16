import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  const PopupDialog({
    Key? key,
    required this.title,
    required this.onDeny,
    required this.onAccept
    }) : super(key: key);

    final String title;
    final Function() onDeny;
    final Function() onAccept;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // TITLE
      title: Text(title),
      actions: [
        // NO BUTTON
        TextButton(
          child: const Text("NO"),
          onPressed: onDeny,
          style: ButtonStyle(textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.button)),
        ),
        // YES BUTTON
        TextButton(
          child: const Text("YES"),
          onPressed: onAccept,
          style: ButtonStyle(textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.button)),
        )
      ],
    );
  }
}