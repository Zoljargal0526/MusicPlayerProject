import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../Shared.dart';

class DownloadImage extends StatelessWidget {
  String path = "";
  double width = 80;
  DownloadImage({
    Key? key,
    this.path = "",
    this.width = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Shared.db.downloadURL(path),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return Image.network(
              snapshot.data!,
              width: width,
              height: width,
              fit: BoxFit.cover,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Container();
        });
  }
}

