import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class FeaturedCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      // fallback height
      height: height * 0.2,
      width: width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: ThemeColoursSeva().pallete1,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Text(
          "Hello from the other side wohoo! What can I say I am really grateful@! A super long text haha!",
          style: TextStyle(color: Colors.white, fontSize: 19.0),
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}
