import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:music_player_project/models/GenreModel.dart';
import 'package:music_player_project/widgets/MusicAppbar.dart';
import 'package:music_player_project/widgets/PlaylistContainer.dart';
import 'package:music_player_project/widgets/PlaylistSong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Shared.dart';
import '../models/MusicModel.dart';
import '../widgets/DownloadImage.dart';
import '../widgets/SingerName.dart';
import '../widgets/SongName.dart';
import 'Player.dart';

class PlaylistPage extends StatefulWidget {
  GenreModel genre;
  String type;

  PlaylistPage({Key? key, required this.genre, this.type = ""})
      : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

late List<MusicModel> musics;

class _PlaylistPageState extends State<PlaylistPage> {
  Map<int, double> downloadProgress = {};

  @override
  void initState() {
    musics = List.empty(growable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int min = int.parse(widget.type) * 10;
    return Scaffold(
        appBar: MusicAppbar(),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.deepPurpleAccent,
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            PlaylistContainer(
              isPlaylistItem: true,
              genre: widget.genre,
            ),
            Expanded(
              child: ListView(scrollDirection: Axis.vertical, children: [
                for (int i = min-9; i <= min; i++)
                    FutureBuilder<MusicModel>(
                      future: Shared.db.getMusicData(i.toString()),
                      builder: (BuildContext context,
                          AsyncSnapshot<MusicModel> snapshotM) {
                        if (snapshotM.hasData) {
                          MusicModel? music = snapshotM.data;
                          if (music != null && musics.length <= 10)
                            musics.add(music);
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: GestureDetector(
                              onTap: () {
                                Shared.playinSongId=i;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Player(music: snapshotM.data!)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.grey),
                                child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(20)),
                                        child: DownloadImage(
                                          path: snapshotM
                                                  .data?.artist_image ??
                                              "",
                                          width: 100,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //if(musics[0]!=null)
                                            SingerName(
                                                name: snapshotM.data
                                                        ?.artist_name ??
                                                    "",
                                                height: 40),
                                            SongName(
                                                name: snapshotM
                                                        .data?.song_name ??
                                                    "",
                                                height: 40),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            if (snapshotM.data != null)
                                              downloadFile(
                                                  i,
                                                  snapshotM.data!);
                                          },
                                          icon: Icon(
                                            Icons.download,
                                            size: 35,
                                            color: Colors.white,
                                          )),
                                    ]),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox(
                            width: double.maxFinite,
                            height: 60,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
              ]),
            ),
          ]),
        ));
  }
  Future downloadFile(int index, MusicModel music,) async {

    var StorageStatus = await Permission.storage.status;
    var AccessMediaStatus = await Permission.accessMediaLocation.status;
    var ExternalStatus = await Permission.manageExternalStorage.status;
    if (!StorageStatus.isGranted) {
      await Permission.storage.request();
    }
    if (!AccessMediaStatus.isGranted) {
      await Permission.accessMediaLocation.request();
    }
    if (!ExternalStatus.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    final url = await Shared.db.downloadURL(music.song_path);
    //final exdir = await getExternalStorageDirectory();
    Directory dir = Directory('/storage/emulated/0/Download/');
    final path = '${dir.path}/${music.artist_name}-${music.song_name}.mp3';
    //print(path);
    await Dio().download(url, path);

    /*
    final tempDir = await getTemporaryDirectory();

    print(path);*/
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Амжилттай татлаа"),backgroundColor: Colors.green,));
    //   final dir = await getApplicationDocumentsDirectory();
    //   final file = File('${dir.path}/${ref.name}');
    //   await ref.writeToFile(file);
  }
}
