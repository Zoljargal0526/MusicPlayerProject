import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_project/Shared.dart';
import 'package:music_player_project/screens/Home.dart';
import 'package:music_player_project/screens/LibraryPage.dart';
import 'package:music_player_project/screens/MixPage.dart';
import 'package:music_player_project/screens/Search.dart';
import 'package:music_player_project/widgets/MusicAppbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database.dart';
import 'models/DurationState.dart';

late AudioHandler audioHandler;
late AudioPlayer audioPlayer;
Duration duration = Duration.zero;
late Stream<DurationState> durationState;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Shared.prefs = await SharedPreferences.getInstance();
  Firebase.initializeApp().whenComplete((){
    Shared.db = Database();
    _init().then((value) => runApp(MyApp()));
  });

}

Future<void> _init() async {
  audioPlayer = AudioPlayer();
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.speech());

  audioPlayer.playbackEventStream.listen((event) {},
      onError: (Object e, StackTrace stackTrace) {
    if (kDebugMode) {
      print('A stream error occurred: $e');
    }
  });

}

final PageController controller = PageController();

class MyApp extends StatefulWidget {
  static int selectedIndex = 0;

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {

    //WidgetsBinding.instance?.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    super.initState();
  }

  void onItemTapped(int index) {
    setState(() {
      MyApp.selectedIndex = index;
      controller.jumpToPage(MyApp.selectedIndex);
    });
  }
/*
  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      audioPlayer.stop();
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: const MusicAppbar(),
        body: PageView(
          onPageChanged: (int page) {
            MyApp.selectedIndex = page;
            setState(() {});
          },
          controller: controller,
          children: const <Widget>[
            HomePage(),
            Search(),
            MixPage(),
            LibraryPage(),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.deepPurpleAccent,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.deepPurple,
              selectedItemColor: Colors.amberAccent,
              unselectedItemColor: Colors.black,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.headset),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.video_library_outlined),
                  label: 'Mix',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.my_library_music_rounded),
                  label: 'Library',
                ),
              ],
              currentIndex: MyApp.selectedIndex,
              onTap: onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}
