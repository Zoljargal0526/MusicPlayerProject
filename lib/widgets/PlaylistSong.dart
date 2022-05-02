import 'package:flutter/material.dart';
import 'package:music_player_project/models/MusicModel.dart';
import 'package:music_player_project/widgets/SingerName.dart';
import 'package:music_player_project/widgets/SongName.dart';

import '../screens/Player.dart';
import 'DownloadImage.dart';

class PlaylistSong extends StatefulWidget {
  MusicModel music;

  PlaylistSong({Key? key, required this.music}) : super(key: key);

  @override
  State<PlaylistSong> createState() => _PlaylistSongState();
}

class _PlaylistSongState extends State<PlaylistSong> {
  @override
  Widget build(BuildContext context) {
    print(widget.music.toString());
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Player(music: widget.music)));
        },
        child: Row(mainAxisSize:MainAxisSize.max,children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(width: 100,height: 60,),
              // DownloadImage(
              //   path: widget.music.artist_image,
              // ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("aa"),
                  //SingerName(name: widget.music.artist_name, height: 20),
                  SizedBox(
                    width: 20,
                  ),
                  Text("bb"),
                  //SongName(name: widget.music.song_name, height: 20),
                ],
              ),
            )
          ]),
        ),

    );
  }
}
