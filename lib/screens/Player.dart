import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_project/Shared.dart';
import 'package:music_player_project/models/MusicModel.dart';
import 'package:music_player_project/widgets/ControlButtons.dart';
import 'package:music_player_project/widgets/DownloadImage.dart';
import 'package:music_player_project/widgets/SongName.dart';
import 'package:rxdart/rxdart.dart';

import '../main.dart';
import '../models/DurationState.dart';
import '../widgets/SingerName.dart';

class Player extends StatefulWidget {
  //Uri uri;required this.uri
  MusicModel music;

  Player({Key? key, required this.music}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  void initState() {
    super.initState();
    try {
      getSong(widget.music.song_path);
      //Uri uri = Uri.parse(widget.uri);
      Uri uri = Uri.parse(
          "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3");
      //duuni indexeer n duugaa taniad ijilhen bol solihgvi heweer n duugargaad uur bol solij duugargana
      // audioPlayer.setAudioSource(AudioSource.uri(
      //   uri,//widget.uri,
      //   tag: MediaItem(
      //     id: '1',
      //     album: "Public Domain",
      //     title: "Nature Sounds",
      //     artUri: Uri.parse(
      //         "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
      //   ),
      // ));
    } catch (e) {
      if (kDebugMode) {
        print("Error loading audio source: $e");
      }
    }
  }
  Future<Stream<DurationState>> getSong(url) async {
    String path = await Shared.db.downloadURL(url);
    await audioPlayer.setUrl(path).whenComplete((){ return durationState =
        Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
            audioPlayer.positionStream,
            audioPlayer.playbackEventStream,
            (position, playbackEvent) => DurationState(
                  progress: position,
                  buffered: playbackEvent.bufferedPosition,
                  total: playbackEvent.duration ?? duration,
                ));});
    return durationState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          "lib/assets/icon/logo.png",
          fit: BoxFit.fitHeight,
        ),
        backgroundColor: Colors.pink,
        automaticallyImplyLeading: false,
        title: Text("MusicPlayer"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.cancel,
                size: 30,
              ))
        ],
      ),
      body: Container(
        color: Colors.pinkAccent,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  color: Colors.red,
                  child: DownloadImage(path: widget.music.artist_image,width: MediaQuery.of(context).size.height * 0.4,),
                ),
              ),
              SizedBox(height: 10),
              SongName(
                name: widget.music.song_name,
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              SingerName(
                name: widget.music.artist_name,
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              SizedBox(height: 10),
              FutureBuilder<Stream<DurationState>>(
                  future: getSong(widget.music.song_path),
                  // a previously-obtained Future<String> or null
                  builder:
                      (BuildContext context, AsyncSnapshot<Stream<DurationState>> snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder<DurationState>(
                        stream: durationState,
                        builder: (context, snapshot) {
                          final durationState = snapshot.data;
                          return ProgressBar(
                            progress: durationState?.progress ?? Duration.zero,
                            buffered: durationState?.buffered ?? Duration.zero,
                            total: durationState?.total ?? Duration.zero,
                            progressBarColor: Colors.deepPurple,
                            baseBarColor: Colors.white.withOpacity(0.24),
                            bufferedBarColor: Colors.white54,
                            thumbColor: Colors.white,
                            barHeight: 10.0,
                            thumbRadius: 15.0,
                            onSeek: (duration) {
                              audioPlayer.seek(duration);
                            },
                          );
                        },
                      );
                    }else {
                        return SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        );
                    }
                  }),

              Expanded(child: ControlButtons(Pcontext: context,)),
            ],
          ),
        ),
      ),
    );
  }
}
