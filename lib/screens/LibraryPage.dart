import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player_project/main.dart';
import 'package:music_player_project/widgets/SongName.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Shared.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    super.initState();
    getSongs();
  }

  Future<String> getSongs() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    Directory dir = Directory('/storage/emulated/0/Download/');
    //String mp3Path = dir.toString();
    List<FileSystemEntity> _files;
    //List<FileSystemEntity> _songs = [];
    _files = dir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3') && Shared.songs.contains(path) == false) {
        Shared.songs.add(path);
        return path;
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      color: Colors.deepPurpleAccent,
      child: Container(
        color: Colors.deepPurple,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(child: SongName(name: "Миний сан", height: 50)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        getSongs();
                      });
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 35,
                    ))
              ],
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: FutureBuilder(
                    future: getSongs(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: Shared.songs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                    color: Colors.grey,
                                    border: Border.all(
                                        color: Colors.yellow,
                                        width: 1,
                                        style: BorderStyle.solid)),
                                child: ListTile(
                                  onTap: () {
                                    playSong(Shared.songs[index]);
                                  },
                                  textColor: Colors.black,
                                  leading: const Icon(
                                    Icons.music_note,
                                    color: Colors.yellow,
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.yellow,
                                    ),
                                    onPressed: () {
                                      deleteFile(Shared.songs[index]);
                                    },
                                  ),
                                  title: Text(splitPath(Shared.songs[index])),
                                ),
                              );
                            });
                      } else {
                        return const Center(
                          child: Text("No music data"),
                        );
                      }
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  playSong(String path) async {
    if (audioPlayer.playing) {
      audioPlayer.stop();
    }
    await audioPlayer.setFilePath(path);
    audioPlayer.play();
  }

  String splitPath(String path) {
    List<String> p = path.split('/');
    p.last = p.last
        .split('.')
        .first;
    return p.last;
  }

  Future<void> deleteFile(String path) async {
    try {
      final file = File(path);
      await file.delete();
      Shared.songs.remove(path);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Хүсэлт амжилттай"), backgroundColor: Colors.green,));
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Хүсэлт амжилтгүй"), backgroundColor: Colors.red,));
    }
  }

}
