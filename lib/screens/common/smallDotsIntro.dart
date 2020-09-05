import 'package:flutter/material.dart';

class SmallDotsIntro extends StatefulWidget {
  final Color bg;
  final Key key;
  SmallDotsIntro({this.bg,this.key});

  @override
  _SmallDotsIntroState createState() => _SmallDotsIntroState();
}

class _SmallDotsIntroState extends State<SmallDotsIntro> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0,
      width: 20.0,
      decoration: BoxDecoration(color: widget.bg, shape: BoxShape.circle),
    );
  }
}
