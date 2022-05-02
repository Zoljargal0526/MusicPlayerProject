import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SongName extends StatelessWidget {
  String name;
  double height;

  SongName({Key? key, required this.name, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: double.infinity,
        child: AutoSizeText(
          name,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: const TextStyle(color: Colors.white, fontSize: 40),
        ));
  }
}
