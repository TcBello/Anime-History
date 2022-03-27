import 'package:anime_history/provider/user_provider.dart';
import 'package:anime_history/ui/unavailable_server/unavailable_server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({
    Key? key,
    required this.beforeAuth,
    required this.afterAuth
  }) : super(key: key);

  final Widget beforeAuth;
  final Widget afterAuth;

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  UserProvider? userProvider;

  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    userProvider?.initAuth();
    super.initState();
  }

  @override
  void dispose() {
    userProvider?.disposeAuth();
    userProvider = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var user = context.read<UserProvider>();

    return StreamBuilder<AuthStatus>(
      stream: user.authStream,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          if(snapshot.data == AuthStatus.valid){
            // HOME UI
            return widget.afterAuth;
          }
          else if(snapshot.data == AuthStatus.invalid){
            // LOGIN UI
            return widget.beforeAuth;
          }
          else{
            return const UnavailableServer();
          }
        }
        else{
          // LOADING
          return Container(
            width: size.width,
            height: size.height,
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator(),),
          );
        }
      },
    );
  }
}