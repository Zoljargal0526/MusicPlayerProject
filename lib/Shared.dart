import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';

class Shared {
  static late final SharedPreferences prefs;
  static late final Database db;
  static late final List<String> songs = List.empty(growable: true);
  static late int playinSongId=0;
}
