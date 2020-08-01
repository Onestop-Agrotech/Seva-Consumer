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
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Offers and Discount",
                  style: TextStyle(
                      color: ThemeColoursSeva().dkGreen, fontSize: 27),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Theme(
                        data: ThemeData(
                            primaryColor: Colors.greenAccent,
                            primaryColorDark: Colors.deepOrangeAccent),
                        child: Container(
                          width: 200,
                          child: TextField(
                              decoration: InputDecoration(
                            filled: true,
                            fillColor: ThemeColoursSeva().pallete3,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal)),
                            // hintText: 'Tell us about yourself',
                            // helperText: 'helper text',
                            labelText: 'Promo Code',
                          )),
                        )),
                    RaisedButton(
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: new BorderRadius.circular(10.0)),
                      color: Colors.white,
                      onPressed: () {},
                      child: Text(
                        "Apply",
                        style: TextStyle(
                            color: ThemeColoursSeva().dkGreen, fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            for (int i = 0; i < categories.length; i++)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 200.0,
                    height: 70.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: ThemeColoursSeva().dkGreen,
                      onPressed: () {
                        setState(() {
                          tapped = i;
                        });
                      },
                      child: Text(
                        categories[i],
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
      )),
    );
  }
}
