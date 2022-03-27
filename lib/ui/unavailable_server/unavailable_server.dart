import 'package:flutter/material.dart';

class UnavailableServer extends StatelessWidget {
  const UnavailableServer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/imgs/server_close.png"),
            Text(
              "Server is currently unavailable",
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            )
          ],
        )
      ),
    );
  }
}