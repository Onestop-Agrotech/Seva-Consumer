import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/common/cartIcon.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Account",
          style: TextStyle(
              color: ThemeColoursSeva().pallete1, fontWeight: FontWeight.w500),
        ),
        backgroundColor: ThemeColoursSeva().pallete3,
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [CartIcon()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: ThemeColoursSeva().pallete3),
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                    child: Column(
                  children: [
                    Icon(
                      Icons.supervised_user_circle_outlined,
                      color: Colors.black54,
                      size: 70,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Name",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "MPbile",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Pjone",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
