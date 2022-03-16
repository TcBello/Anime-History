import 'package:anime_history/constants.dart';
import 'package:anime_history/provider/anime_provider.dart';
import 'package:anime_history/provider/user_provider.dart';
import 'package:anime_history/ui/home/home.dart';
import 'package:anime_history/ui/login/login.dart';
import 'package:anime_history/widgets/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main(){
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AnimeProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider())
      ],
      child: MaterialApp(
        // SPLASH SCREEN
        home: SplashScreen(
          backgroundColor: Colors.white,
          imageBackground: const AssetImage(kSplashScreenImage),
          useLoader: false,
          styleTextUnderTheLoader: const TextStyle(
            fontSize: 16,
          ),
          loadingTextPadding: EdgeInsets.zero,
          seconds: 5,
          title: Text("Anime History", style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.white),),
          loadingText: Text("TcBello", style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white, fontStyle: FontStyle.italic),),
          navigateAfterSeconds: const AuthWrapper(beforeAuth: Login(), afterAuth: Home()),
        ),
      ),
    );
  }
}