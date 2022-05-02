import 'package:flutter/material.dart';
class MusicAppbar extends StatelessWidget with PreferredSizeWidget{
  const MusicAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      actions: [
        Expanded(
            child: Container(
              color: Colors.deepPurpleAccent,
              child: ClipRRect(
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(20)),
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                  color: Colors.deepPurple,
                  child: Row(
                    children: [
                      Image.asset(
                        "lib/assets/icon/logo.png",
                        fit: BoxFit.fitHeight,
                      ),
                      Text("Music",style: TextStyle(fontSize: 30)),
                    ],
                  ),
                ),
              ),
            ))
      ],
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
