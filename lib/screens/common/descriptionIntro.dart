import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class DescriptionIntro extends StatefulWidget {
  final String img;
  final String descText;

  DescriptionIntro({this.img, this.descText});
  @override
  _DescriptionIntroState createState() => _DescriptionIntroState();
}

class _DescriptionIntroState extends State<DescriptionIntro> {
  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Image(image: AssetImage(widget.img)),
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: sWidth * 0.79,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              widget.descText,
              style: TextStyle(
                  fontSize: 15,
                  color: ThemeColoursSeva().dkGreen),
            ),
          ),
        ),
      ],
    );
  }
}
