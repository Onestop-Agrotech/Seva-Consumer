import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class InputTextField extends StatelessWidget {

  final TextEditingController eC;
  final String lt;
  final bool pwdType;

  InputTextField({this.eC, this.lt, this.pwdType=false});  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
          child: Text(
            lt,
            style: TextStyle(
                fontFamily: "Raleway",
                color: ThemeColoursSeva().black,
                fontSize: 18.0,
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.0),
            border: Border.all(
                style: BorderStyle.solid, color: ThemeColoursSeva().dkGreen),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: eC,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              obscureText: pwdType,
            ),
          ),
        ),
      ],
    );
  }
}
