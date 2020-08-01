import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class PromoCodeScreen extends StatefulWidget {
  @override
  _PromoCodeScreenState createState() => _PromoCodeScreenState();
}

class _PromoCodeScreenState extends State<PromoCodeScreen> {
  List categories = ['Vegetables', 'Fruits', 'Daily Essentials'];
  int tapped;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 20),
              Text("Apply Promo Code"),
              SizedBox(height: 20),
              new Theme(
                  data: new ThemeData(
                      primaryColor: Colors.greenAccent,
                      primaryColorDark: Colors.deepOrangeAccent),
                  child: Container(
                    width: 200,
                    child: new TextField(
                        decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)),
                      // hintText: 'Tell us about yourself',
                      // helperText: 'helper text',
                      labelText: 'Promo Code',
                    )),
                  )),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: 20),
              for (int i = 0; i < categories.length; i++)
                ButtonTheme(
                  minWidth: 200.0,
                  height: 70.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    color:
                        tapped == i ? ThemeColoursSeva().dkGreen : Colors.white,
                    onPressed: () {
                      setState(() {
                        tapped = i;
                      });
                    },
                    child: Text(
                      categories[i],
                      style: TextStyle(
                          color: tapped == i
                              ? Colors.white
                              : ThemeColoursSeva().dkGreen),
                    ),
                  ),
                ),
            ],
          )
        ],
      )),
    );
  }
}
