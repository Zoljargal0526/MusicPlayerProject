import 'package:flutter/material.dart';
class BannerContainer extends StatelessWidget {
  const BannerContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        width: double.infinity,
        color: Colors.red,
        height: 200,
        child: Image.network("https://c4.wallpaperflare.com/wallpaper/500/442/354/outrun-vaporwave-hd-wallpaper-preview.jpg",fit: BoxFit.cover,),
      ),
    );
  }
}
