import 'package:flutter/material.dart';

class GenreButton extends StatelessWidget {
  String genre;
  double width;
  double height;
  GenreButton({Key? key, this.genre = "", this.width=0,this.height=0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white.withOpacity(0.5),),
      width: width,
      height: height,
      child: FittedBox(child: Text(genre)),
    );
  }
}
