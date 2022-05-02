import 'package:flutter/material.dart';
import 'package:music_player_project/screens/MixPlayList.dart';
import 'package:music_player_project/widgets/MixContainer.dart';

class MixPage extends StatefulWidget {
  const MixPage({Key? key}) : super(key: key);

  @override
  State<MixPage> createState() => _MixPageState();
}

class _MixPageState extends State<MixPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
      color: Colors.deepPurpleAccent,
      child: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MixPlayList( text: "Монгол хит дуу",mixList: ["80", "71", "1," ,"31", "37", "9", "10", "3", "5", "48"],)));
                },
                child: MixContainer(
                  text: "Монгол хит дуу",
                  url: "https://i.ytimg.com/vi/PO0vpohz53M/maxresdefault.jpg",
                )),
            SizedBox(
              height: 20,
            ),
            MixContainer(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
