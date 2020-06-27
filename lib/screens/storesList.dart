import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/stores.dart';
import 'package:mvp/screens/common/customStoreListCard.dart';
import 'package:mvp/screens/common/topText.dart';
import 'package:mvp/screens/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoresScreen extends StatefulWidget {
  @override
  _StoresScreenState createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  final GlobalKey<ScaffoldState> _storesScreenKey =
      new GlobalKey<ScaffoldState>();

  String _username;
  String _email;

  Future<List<Store>> _fetchStores() async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String token = await p.getToken();
    String username = await p.getUsername();
    String id = await p.getId();
    String url = APIService.businessListAPI + "$id";
    Map<String, String> requestHeaders = {'x-auth-token': token};
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      setState(() {
        _username = username;
      });
      return jsonToStoreModel(response.body);
    } else {
      throw Exception('something is wrong');
    }
  }

  Future<String> _fetchUserAddress() async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String token = await p.getToken();
    String id = await p.getId();
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

  FutureBuilder _buildArrayFromFuture() {
    return FutureBuilder(
        future: _fetchStores(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Store> arr = snapshot.data;
            Store s = new Store();
            arr = s.checkAndArrange(arr);
            if (arr.length > 0) {
              return ListView.builder(
                  itemCount: arr.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        StoreListCard(
                          shopName: arr[index].name,
                          vegetablesOnly: arr[index].vegetables,
                          fruitsOnly: arr[index].fruits,
                          businessUserName: arr[index].username,
                          distance: arr[index].distance,
                        ),
                        SizedBox(height: 20.0)
                      ],
                    );
                  });
            } else
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(
                    child: Text(
                        "Oops! No stores near you. We are trying hard to add more stores everyday. Stay tuned!"),
                  ),
                ),
              );
          } else if (snapshot.hasError)
            return Text('${snapshot.error}');
          else
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Setting up your personal experience"),
                  SizedBox(
                    height: 20.0,
                  ),
                  CircularProgressIndicator(
                    backgroundColor: ThemeColoursSeva().black,
                    strokeWidth: 4.0,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ThemeColoursSeva().grey),
                  ),
                ],
              ),
            );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _storesScreenKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            title: TopText(
              txt: "Nearby Stores",
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            leading: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: ThemeColoursSeva().black,
                ),
                onPressed: () {
                  _storesScreenKey.currentState.openDrawer();
                }),
            elevation: 0,
            actions: <Widget>[
              Icon(
                Icons.person,
                color: Colors.black,
              )
            ],
          ),
        ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: DrawerHeader(
                    child: TopText(
                        txt: _username == null ? 'Username' : _username),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('My orders'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/orders');
                  },
                ),
                ListTile(
                  title: Text('Logout'),
                  onTap: () async {
                    // Navigator.pushNamed(context, '/orders');
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.clear();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login', (Route<dynamic> route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
        body: _buildArrayFromFuture(),
        floatingActionButton: FutureBuilder(
            future: _fetchUserAddress(),
            builder: (context, data) {
              if (data.hasData) {
                return Container(
                  height: 60.0,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Delivery Address:",
                            style: TextStyle(
                                fontFamily: "Raleway",
                                fontWeight: FontWeight.w700,
                                color: ThemeColoursSeva().black,
                                fontSize: 14.0),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              data.data,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GoogleLocationScreen(
                                      userEmail: _email,
                                    )),
                          );
                        },
                        child: Text(
                          "Change",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: ThemeColoursSeva().dkGreen,
                      )
                    ],
                  ),
                );
              } else
                return Container(
                  child: Text("Loading Address ...")
                );
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
