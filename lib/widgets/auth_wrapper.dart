import 'package:anime_history/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({
    Key? key,
    required this.beforeAuth,
    required this.afterAuth
  }) : super(key: key);

  final Widget beforeAuth;
  final Widget afterAuth;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<UserProvider>(
      builder: (context, user, child) {
        return FutureBuilder<bool>(
          future: user.auth(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if(snapshot.data!){
                // HOME UI
                return afterAuth;
              }
              else{
                // LOGIN UI
                return beforeAuth;
              }
            }
            else if(snapshot.connectionState == ConnectionState.waiting){
              // LOADING
              return Container(
                width: size.width,
                height: size.height,
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator(),),
              );
            }
            else{
              // SERVER IS UNAVAILABLE UI
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
          },
        );
      }
    );
  }
}