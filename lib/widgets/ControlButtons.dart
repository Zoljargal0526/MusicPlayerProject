import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_project/models/MusicModel.dart';
import 'package:music_player_project/screens/Player.dart';

import '../Shared.dart';
import '../main.dart';
import 'ShowSliderDialog.dart';

class ControlButtons extends StatelessWidget {
  double bigIconSize = 60;
  double smallIconSize = 30;
  BuildContext Pcontext;
  bool repeat = false;
  bool shuffle = false;

  ControlButtons({Key? key, required this.Pcontext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.volume_up),
              iconSize: smallIconSize,
              onPressed: () {
                showSliderDialog(
                  context: context,
                  title: "Adjust volume",
                  divisions: 10,
                  min: 0.0,
                  max: 1.0,
                  value: audioPlayer.volume,
                  stream: audioPlayer.volumeStream,
                  onChanged: audioPlayer.setVolume,
                );
              },
            ),
            StreamBuilder<double>(
              stream: audioPlayer.speedStream,
              builder: (context, snapshot) => IconButton(
                iconSize: smallIconSize,
                icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  showSliderDialog(
                    context: context,
                    title: "Adjust speed",
                    divisions: 10,
                    min: 0.5,
                    max: 1.5,
                    value: audioPlayer.speed,
                    stream: audioPlayer.speedStream,
                    onChanged: audioPlayer.setSpeed,
                  );
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.shuffle_rounded,
                color: Colors.black,
              ),
              iconSize: smallIconSize,
              onPressed: () {
                if (shuffle) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Shuffle mode disabled")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Shuffle mode enabled")));
                }
                shuffle=!shuffle;

                //player.seekToNext();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.skip_previous_rounded,
                color: Colors.white,
              ),
              iconSize: bigIconSize,
              onPressed: () {
                goBack();
                //player.seekToNext();
              },
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40,
              child: StreamBuilder<PlayerState>(
                stream: audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      width: bigIconSize,
                      height: bigIconSize,
                      child: CircularProgressIndicator(),
                    );
                  } else if (playing != true) {
                    return IconButton(
                      icon: Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                      ),
                      iconSize: bigIconSize,
                      onPressed: audioPlayer.play,
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                      icon: Icon(
                        Icons.pause,
                        color: Colors.black,
                      ),
                      iconSize: bigIconSize,
                      onPressed: audioPlayer.pause,
                    );
                  } else {
                    return IconButton(
                      icon: Icon(
                        Icons.replay,
                        color: Colors.black,
                      ),
                      iconSize: bigIconSize,
                      onPressed: () => audioPlayer.seek(Duration.zero),
                    );
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.skip_next,
                color: Colors.white,
              ),
              iconSize: bigIconSize,
              onPressed: () {
                goNext();
                //player.seekToNext();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.repeat,
                color: Colors.black,
              ),
              iconSize: smallIconSize,
              onPressed: () {
                if (repeat) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Repeat mode disabled")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Repeat mode enabled")));
                }
                repeat=!repeat;
                //player.seekToNext();
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> goNext() async {
    if (Shared.playinSongId % 10 != 0) {
      audioPlayer.stop();
      Shared.playinSongId += 1;
      MusicModel music =
          await Shared.db.getMusicData(Shared.playinSongId.toString());
      if (music.artist_name.isNotEmpty) {
        Navigator.pushReplacement(
            Pcontext, MaterialPageRoute(builder: (_) => Player(music: music)));
      }
    }
  }

  Future<void> goBack() async {
    if (Shared.playinSongId % 10 != 1) {
      audioPlayer.stop();
      Shared.playinSongId -= 1;
      MusicModel music =
          await Shared.db.getMusicData(Shared.playinSongId.toString());
      if (music.artist_name.isNotEmpty) {
        Navigator.pushReplacement(
            Pcontext, MaterialPageRoute(builder: (_) => Player(music: music)));
      }
    }
  }
}
