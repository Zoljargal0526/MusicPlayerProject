import 'package:flutter/material.dart';

import '../Shared.dart';
import '../models/MusicModel.dart';
import '../widgets/DownloadImage.dart';
import '../widgets/MusicAppbar.dart';
import '../widgets/SingerName.dart';
import '../widgets/SongName.dart';
import 'Player.dart';
class MixPlayList extends StatefulWidget {
  List<String> mixList;
  String text="Монгол хит дуу";
  MixPlayList({Key? key,required this.mixList,this.text=""}) : super(key: key);

  @override
  State<MixPlayList> createState() => _MixPlayListState();
}
class _MixPlayListState extends State<MixPlayList> {

  @override
  Widget build(BuildContext context) {
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
              SongName(name: widget.text, height: 30),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView(scrollDirection: Axis.vertical, children: [
                  for (int i = 0; i < widget.mixList.length; i++)
                    if(i!=2) FutureBuilder<MusicModel>(
                      future: Shared.db.getMusicData(widget.mixList[i]),
                      builder: (BuildContext context,
                          AsyncSnapshot<MusicModel> snapshotM) {
                        if (snapshotM.hasData) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child:  GestureDetector(
                              onTap: () {
                                Shared.playinSongId=int.parse(widget.mixList[i]);
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
                                    color: Colors.pinkAccent),
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
}
