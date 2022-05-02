import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class AssetPlayer extends StatefulWidget {
  const AssetPlayer({Key? key}) : super(key: key);

  @override
  State<AssetPlayer> createState() => _AssetPlayerState();
}

class _AssetPlayerState extends State<AssetPlayer> {
  final player = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
  @override
  void initState() {
    player.onPlayerStateChanged.listen((state) {setState(() {
      isPlaying = state ==PlayerState.PLAYING;
    });});
    player.onDurationChanged.listen((newDuration) {
      print("$newDuration duration");
      setState(() {
      duration = newDuration;
    });});
    player.onAudioPositionChanged.listen((newPosition) {setState(() {
      position = newPosition;
    });});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: 350,
                child: Center(
                  child: Text("Image area"),
                ),
              ),
            ),
            Text("Song Name"),
            Text("Singer Name"),
            /*Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {},
            ),*/

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(position.inSeconds.toString()),
                Text(duration.inSeconds.toString()),
              ],
            ),
            CircleAvatar(
              radius: 35,
              child: IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 50,
                  onPressed: () async {
                    isPlaying=!isPlaying;
                    if (!isPlaying) {
                      await player.pause();
                    } else {
                      await player.play("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3");
                      print("playing path:https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3");
                    }
                    setState(() {});
                  }),
            )
          ],
        ),
      ),
    );
  }
}
