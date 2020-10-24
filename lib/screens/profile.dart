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
                      style: TextStyle(
                          fontSize: 20, color: ThemeColoursSeva().pallete1),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Mobile",
                      style: TextStyle(
                          fontSize: 14, color: ThemeColoursSeva().pallete1),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Phone",
                      style: TextStyle(
                          fontSize: 14, color: ThemeColoursSeva().pallete1),
                    )
                  ],
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      title: Text('My Orders'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('VIEW ALL ORDERS'),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      title: Text('Location'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('VIEW MY LOCATION'),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
