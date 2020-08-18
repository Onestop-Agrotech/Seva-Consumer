import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/common/topText.dart';
import 'package:mvp/screens/landing/common/featuredCards.dart';
import 'package:mvp/screens/landing/common/showCards.dart';
import 'package:mvp/screens/landing/graphics/darkBG.dart';
import 'package:mvp/screens/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'graphics/lightBG.dart';

class MainLandingScreen extends StatefulWidget {
  @override
  _MainLandingScreenState createState() => _MainLandingScreenState();
}

class _MainLandingScreenState extends State<MainLandingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var texts = [
    "Free Delivery on your first 3 orders.\n" + "\nOrder Now!",
    "Get a cashback of Rs 30 on your 4th order!"
  ];
  List<StoreProduct> categories = [];
  // static categories
  StoreProduct d;
  StoreProduct e;
  StoreProduct f;
  String _email;
  String _username;
  Timer x;

  @override
  initState() {
    super.initState();
    d = new StoreProduct(
      name: "Vegetables",
      pictureUrl:
          "https://storepictures.theonestop.co.in/illustrations/vegetable.png",
    );
    e = new StoreProduct(
      name: "Fruits",
      pictureUrl:
          "https://storepictures.theonestop.co.in/illustrations/viburnum-fruit.png",
    );
    f = new StoreProduct(
      name: "Daily Essentials",
      pictureUrl:
          "https://storepictures.theonestop.co.in/illustrations/supermarket.png",
    );
    categories.add(d);
    categories.add(e);
    categories.add(f);
    getUsername();
    x = new Timer.periodic(Duration(seconds: 10), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    x.cancel();
    super.dispose();
  }

  getUsername() async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    var x = await p.getUsername();
    setState(() {
      _username = x;
    });
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

  Future<List<StoreProduct>> _fetchBestSellers() async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String token = await p.getToken();
    Map<String, String> requestHeaders = {'x-auth-token': token};
    String url = APIService.getBestSellersAPI;
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      return jsonToStoreProductModel(response.body);
    } else {
      throw Exception('something is wrong');
    }
  }

  _showLocation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoogleLocationScreen(
                                  userEmail: _email,
                                )),
                      );
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

  Widget commonWidget(height, itemsList, store) {
    return Container(
      height: height * 0.22,
      child: Row(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: itemsList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: ShowCards(
                            sp: itemsList[index],
                            store: store,
                            index: index,
                          ),
                        ),
                      ],
                    );
                  }))
        ],
      ),
    );
  }

  Widget commonText(height, leftText, rightText) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            leftText,
            style: TextStyle(
                color: ThemeColoursSeva().dkGreen,
                fontWeight: FontWeight.w900,
                fontSize: 17.0),
          ),
          Text(
            rightText,
            style: TextStyle(
                color: ThemeColoursSeva().dkGreen,
                fontSize: 15.0,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: DrawerHeader(
                  child:
                      TopText(txt: _username != null ? _username : "Username"),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
              ListTile(
                title: Text('My orders'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/ordersNew');
                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () async {
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
      body: Stack(
        children: <Widget>[
          CustomPaint(
            painter: LightBlueBG(),
            child: Container(),
          ),
          CustomPaint(
            painter: DarkColourBG(),
            child: Container(),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                          iconSize: 28.0,
                        ),
                        Text(
                          "Welcome",
                          style: TextStyle(
                              color: ThemeColoursSeva().dkGreen,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.location_on),
                              onPressed: () {
                                _showLocation();
                              },
                              iconSize: 28.0,
                            ),
                            IconButton(
                              icon: Icon(Icons.shopping_basket),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, "/shoppingCartNew");
                              },
                              iconSize: 28.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            "Featured",
                            style: TextStyle(
                                color: ThemeColoursSeva().dkGreen,
                                fontWeight: FontWeight.w900,
                                fontSize: 17.0),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: height * 0.2,
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              itemCount: 2,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: FeaturedCards(
                                        textToDisplay: texts[index],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 9.0),
                    commonText(height, "Best Sellers", ""),
                    SizedBox(height: 9.0),
                    FutureBuilder(
                        future: _fetchBestSellers(),
                        builder: (builder, snapshot) {
                          if (snapshot.hasData) {
                            List<StoreProduct> bestSellers = snapshot.data;
                            if (bestSellers.length > 0) {
                              return commonWidget(height, bestSellers, true);
                            } else
                              return Container(
                                child:
                                    Center(child: Text("No products found!")),
                              );
                          }
                          return Container();
                        }),
                    SizedBox(height: 9.0),
                    commonText(height, "Categories", ""),
                    SizedBox(height: 9.0),
                    commonWidget(height, categories, false),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
