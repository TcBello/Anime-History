import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  const Detail({
    Key? key,
    this.padding = const EdgeInsets.only(top: 10),
    required this.child
  }) : super(key: key);

  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}