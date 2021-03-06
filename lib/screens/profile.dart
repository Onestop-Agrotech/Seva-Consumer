import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/common/cartIcon.dart';
import 'package:mvp/screens/googleMapsPicker.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/screens/orders/ordersScreen.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

class Profile extends StatefulWidget {
  final String username;
  final String mobile;
  final String email;
  Profile({this.username, this.mobile, this.email});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _email;

  //To get the address of the user address on clicking the
  // location icon
  Future<String> _fetchUserAddress() async {
    final p = await Preferences.getInstance();
    String token = await p.getData("token");
    String id = await p.getData("id");
    Map<String, String> requestHeaders = {'x-auth-token': token};
    String url = APIService.getAddressAPI + "$id";
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      // got address
      _email = json.decode(response.body)["email"];
      return (json.decode(response.body)["address"]);
    } else {
      throw Exception('something is wrong');
    }
  }

  //This function shows the user's address in a dialog box
  // and the user can edit the address from their also
  _showLocation(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Delivery Address:",
            style: TextStyle(
                fontSize: 17.0,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
          content: FutureBuilder(
              future: _fetchUserAddress(),
              builder: (context, data) {
                if (data.hasData) {
                  return StatefulBuilder(builder: (context, setState) {
                    return Container(
                      height: 120.0,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              data.data,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          SizedBox(height: 30.0),
                        ],
                      ),
                    );
                  });
                } else
                  return Container(child: Text("Loading Address ..."));
              }),
          actions: <Widget>[
            FutureBuilder(
              future: _fetchUserAddress(),
              builder: (context, data) {
                if (data.hasData) {
                  return RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(CupertinoPageRoute<Null>(
                          builder: (BuildContext context) {
                        return GoogleMapsPicker(
                          userEmail: _email,
                        );
                      }));
                    },
                    child: Text("Change"),
                    color: ThemeColoursSeva().pallete1,
                    textColor: Colors.white,
                  );
                } else
                  return Container();
              },
            ),
          ],
        );
      },
    );
  }

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
        elevation: 1.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [CartIcon()],
      ),
      // This is for the scrolling effect
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
                      Icons.account_circle,
                      color: Colors.black54,
                      size: 70,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.username,
                      style: TextStyle(
                          fontSize: 2.4 * SizeConfig.textMultiplier,
                          color: ThemeColoursSeva().pallete1),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.mobile,
                      style: TextStyle(
                          fontSize: 2.1 * SizeConfig.textMultiplier,
                          color: ThemeColoursSeva().pallete1),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.email,
                      style: TextStyle(
                          fontSize: 2.1 * SizeConfig.textMultiplier,
                          color: ThemeColoursSeva().pallete1),
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
                          onPressed: () {
                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return NewOrdersScreen();
                            }));
                          },
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
                          onPressed: () {
                            _showLocation(context);
                          },
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
                    ListTile(
                      title: Center(
                        child: TextButton(
                          child: const Text('Logout'),
                          onPressed: () async {
                            // clearing the data from hive
                            await Hive.deleteFromDisk();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (Route<dynamic> route) => false);
                          },

                          /* ... */
                        ),
                      ),
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
