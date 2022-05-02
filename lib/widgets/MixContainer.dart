import 'package:flutter/material.dart';

class MixContainer extends StatelessWidget {
  String url="https://i.servimg.com/u/f41/17/41/10/34/music_10.jpg";
  String text="Mix";
  MixContainer({Key? key,this.url="https://i.servimg.com/u/f41/17/41/10/34/music_10.jpg",this.text="Mix"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 80;
    double height = MediaQuery.of(context).size.height * 0.35+5;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      child: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.red,child: Image.network(url,fit: BoxFit.cover,),)),
            Positioned(top: 10,left: 10,child: Text(text,style: TextStyle(color: Colors.amberAccent,fontSize: 40,fontWeight: FontWeight.bold),)),
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 60,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
