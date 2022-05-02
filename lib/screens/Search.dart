import 'package:flutter/material.dart';
import 'package:music_player_project/models/GenreModel.dart';
import 'package:music_player_project/widgets/genreButton.dart';

import '../Shared.dart';
import 'PlaylistPage.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late GenreModel genre;
  List<String> genres = [
    "Поп",
    "Рок",
    "Хип хоп",
    "Гадаад",
    "Нийтийн",
    "Ардын",
    "Электроник",
    "Хүүхдийн"
  ];
  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 50);
    double height = 80;
    return Container(
        padding: EdgeInsets.only(top: 20, right: 20, left: 20),
        color: Colors.deepPurpleAccent,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                children: [
                  Icon(Icons.search),
                  Expanded(
                      child: TextField(
                    textAlign: TextAlign.right,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      print("search button clicked");
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Дуу/уран бүтээлч',
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Жанр",
              style: TextStyle(fontSize: 30),
            ),
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                childAspectRatio: width / height,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 1,
                children: [
                  for(int i=0;i<8;i++)
                    GestureDetector(
                      onTap: (){
                        getGenre(genres[i]);
                      },
                      child: GenreButton(
                          genre: genres[i], width: width, height: height),
                    ),]
                )
              ),
          ],
        ));
  }
  Future<void> getGenre(String value)async{
    int a=1;
    if(value==genres[0]){
      a=1;
      genre=await Shared.db.getGenreData("1");
    }else if(value==genres[1]){
      a=2;
      genre=await Shared.db.getGenreData("2");
    }else if(value==genres[2]){
      a=3;
      genre=await Shared.db.getGenreData("3");
    }else if(value==genres[3]){
      a=4;
      genre=await Shared.db.getGenreData("4");
    }else if(value==genres[4]){
      a=5;
      genre=await Shared.db.getGenreData("5");
    }else if(value==genres[5]){
      a=6;
      genre=await Shared.db.getGenreData("6");
    }else if(value==genres[6]){
      a=7;
      genre=await Shared.db.getGenreData("7");
    }else if(value==genres[7]){
      a=8;
      genre=await Shared.db.getGenreData("8");
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => PlaylistPage(genre: genre,type:(a).toString())));
  }

}
