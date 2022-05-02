import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player_project/models/GenreModel.dart';
import 'package:music_player_project/widgets/SongName.dart';

import '../screens/PlaylistPage.dart';
import 'DownloadImage.dart';
import 'SingerName.dart';

class PlaylistContainer extends StatelessWidget {
  bool isPlaylistItem = false;
  GenreModel genre;
  String type;
  PlaylistContainer({Key? key,
    required this.genre,
    this.type="",
    this.isPlaylistItem = false,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = isPlaylistItem
        ? MediaQuery
        .of(context)
        .size
        .width * 0.40
        : 80;
    double fontSize = 20;
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => PlaylistPage(genre: genre,type:type)));
        },
        child: Container(
          width: width,
          height: width + 40,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: DownloadImage(path: genre.genre_icon,width: width,),
              ),
              SongName(name: genre.genre_name, height: fontSize),
              SingerName(name: "дуу", height: fontSize),
            ],
          ),
        ),
      ),
    );
  }
}
