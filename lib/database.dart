
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:music_player_project/models/GenreModel.dart';
import 'package:music_player_project/models/MusicModel.dart';
import 'package:path_provider/path_provider.dart';

class Database{
  late FirebaseDatabase database;
  late DatabaseReference ref;

  late FirebaseStorage storagef;
  late Reference refs;

  late MusicModel music;
  late GenreModel genre;
  Database() {
    Firebase.initializeApp().whenComplete(() async {
      database = FirebaseDatabase.instanceFor(app: await Firebase.initializeApp(),databaseURL: "https://musicplayerhuree-default-rtdb.asia-southeast1.firebasedatabase.app");
    });
    storagef = FirebaseStorage.instance;
  }


  Future<String> downloadURL(String path) async {
    String downloadURL = await storagef.ref(path).getDownloadURL();
    return downloadURL;
  }
  Future<MusicModel> getMusicData(String index) async {
    //ref = FirebaseDatabase.instance.ref("media_items");
    ref = await FirebaseDatabase.instanceFor(app:await Firebase.initializeApp(),databaseURL: "https://musicplayerhuree-default-rtdb.asia-southeast1.firebasedatabase.app").ref("media_items");
    var data = await ref.child(index).once();
    music = MusicModel(artist_name: "",artist_image: "",song_length: "",song_name: "",song_path: "",genre_name: "");
    var refData = data.snapshot.value as Map? ?? {};
    print(refData);
    if (refData.isNotEmpty) {
      music.artist_name = refData["artist_name"];
      music.artist_image = refData["artist_image"];
      music.song_name = refData["song_name"];
      music.song_length = refData["length"];
      music.song_path = refData["song_path"];
      music.genre_name = refData["genre_name"];
      return music;
    }else{
      return music;
    }

  }
  Future<GenreModel> getGenreData(String index) async {
    //ref= database.ref("genres");
    //ref =await FirebaseDatabase.instance.ref("genres");
    ref = await FirebaseDatabase.instanceFor(app:await Firebase.initializeApp(),databaseURL: "https://musicplayerhuree-default-rtdb.asia-southeast1.firebasedatabase.app").ref("genres");
    var data = await ref.child(index).once();
    genre = GenreModel(genre_icon: "",genre_name: "");
    var refData = data.snapshot.value as Map? ?? {};
    if (refData.isNotEmpty) {
      genre.genre_name = refData["genre_name"];
      genre.genre_icon = refData["genre_icon"];
      return genre;
    }
    return genre;
  }


}
