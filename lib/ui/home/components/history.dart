import 'package:anime_history/models/anime_history_model.dart';
import 'package:anime_history/provider/anime_provider.dart';
import 'package:anime_history/provider/user_provider.dart';
import 'package:anime_history/ui/anime/anime.dart';
import 'package:anime_history/ui/home/components/anime_history_card.dart';
import 'package:anime_history/ui/profile/profile.dart';
import 'package:anime_history/ui/search_history/search_history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class History extends StatelessWidget {
  const History({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final anime = context.read<AnimeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Consumer<UserProvider>(
            builder: (context, user, child) {
              // PROFILE BUTTON
              return MaterialButton(
                padding: EdgeInsets.zero,
                child: CircleAvatar(
                  backgroundImage: user.avatar != null
                    ? NetworkImage(user.avatar!)
                    : null,
                  backgroundColor: Colors.white,
                  child: user.avatar == null
                    ? const Icon(Icons.person, color: Colors.black,)
                    : null,
                ),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()))
              );
            }
          ),
        ),
        actions: [
          // SEARCH BUTTON
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: SearchHistory())
          ),
        ],
      ),
      body: SingleChildScrollView(
        // ignore: sized_box_for_whitespace
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<List<AnimeHistoryModel>>(
            stream: anime.allHistoryStream,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                var animeHistory = snapshot.data!;
      
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 20,
                    children: List.generate(animeHistory.length, (index) => AnimeHistoryCard(
                      anime: animeHistory[index],
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Anime(id: animeHistory[index].id)))),
                    )
                  ),
                );
              }
              else{
                return Container();
              }
            },
          )
        ),
      ),
    );
  }
}