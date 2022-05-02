import 'package:flutter/material.dart';
import 'package:music_player_project/Shared.dart';
import 'package:music_player_project/models/GenreModel.dart';
import 'package:music_player_project/models/MusicModel.dart';
import 'package:music_player_project/widgets/BannerContainer.dart';
import 'package:music_player_project/widgets/PlaylistContainer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MusicModel music = MusicModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurpleAccent,
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    for (int i = 1; i <= 8; i++)
                      FutureBuilder<GenreModel>(
                        future: Shared.db.getGenreData(i.toString()),
                        builder: (BuildContext context,
                            AsyncSnapshot<GenreModel> snapshot) {
                          if (snapshot.hasData) {
                            return PlaylistContainer(
                              genre: snapshot.data??GenreModel(),
                              type: i.toString(),
                            );
                          } else {
                            return SizedBox(
                              width: 100,
                              height: 60,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
                      ),
                  ])),
              SizedBox(
                height: 20,
              ),
              BannerContainer(),
            ],
          )),
    );
  }
}
