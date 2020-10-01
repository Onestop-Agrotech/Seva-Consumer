// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.5.0
// Date-{27-09-2020}

///
///@fileoverview MainLanding Widget : This is the main landing screen after the user
///is logged in.
///
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/screens/productsNew/newUI.dart';
import 'package:mvp/screens/orders/ordersScreen.dart';
import 'package:mvp/screens/shoppingCart/shoppingCartNew.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/common/topText.dart';
import 'package:mvp/screens/landing/common/featuredCards.dart';
import 'package:mvp/screens/landing/common/showCards.dart';
import 'package:mvp/screens/landing/graphics/darkBG.dart';
import 'package:mvp/screens/location.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'graphics/lightBG.dart';

class MainLandingScreen extends StatefulWidget {
  @override
  _MainLandingScreenState createState() => _MainLandingScreenState();
}

class _MainLandingScreenState extends State<MainLandingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //Todo: Screen Visible after login

  // This Array is populated by the data that is visible on
  // each caraousel
  var texts = [
    "Free Deliveries and no minimum order!\n" + "\nOrder Now.",
    "Share your referral code with friends to get Rs 25 cashback",
    "Super fast delivery within 45 minutes!",
    "Order Now and support your local stores."
  ];

  // This Array is populated by the categories card data
  List<StoreProduct> categories = [];

  // static categories
  StoreProduct d;
  StoreProduct e;
  StoreProduct f;
  String _email;
  String _username;
  Timer x;
  FirebaseMessaging _fcm;
  int _current = 0;
  String _mobileNumber;
  String _referralCode;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  initState() {
    super.initState();
    // Populating the categories array
    d = new StoreProduct(
      name: "Vegetables",
      pictureURL:
          "https://storepictures.theonestop.co.in/products/all-vegetables.jpg",
    );
    e = new StoreProduct(
      name: "Fruits",
      pictureURL: "https://storepictures.theonestop.co.in/new2/AllFruits.jpg",
    );
    f = new StoreProduct(
      name: "Daily Essentials",
      pictureURL:
          "https://storepictures.theonestop.co.in/illustrations/supermarket.png",
    );
    categories.add(d);
    categories.add(e);
    categories.add(f);
    getUsername();
    _fcm = new FirebaseMessaging();
    _saveDeviceToken();
    x = new Timer.periodic(Duration(seconds: 10), (Timer t) => setState(() {}));
  }

  @override
  void dispose() async {
    super.dispose();
    x.cancel();
  }

  /// Get the token, save it to the database for current user
  _saveDeviceToken() async {
    final p = await Preferences.getInstance();
    // Get the current user
    String uid = await p.getData("id");
    String token = await p.getData("token");

    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      Map<String, String> requestHeaders = {'x-auth-token': token};
      Map<String, String> body = {
        "collection": "Consumer tokens",
        "token": "$fcmToken",
        "userId": "$uid"
      };
      String url = APIService.setDeviceTokenInFirestore;
      var response = await http.post(url, headers: requestHeaders, body: body);
      if (response.statusCode == 200) {
        /// ("SUCCESS");
      } else {
        /// ("FAILURE TO SET");
      }
    }
  }

  // To get the username of the person logged in
  // from local storage
  getUsername() async {
    final preferences = await Preferences.getInstance();
    final username = preferences.getData("username");
    final mobile = preferences.getData("mobile");
    setState(() {
      _username = username;
      _mobileNumber = mobile;
      _referralCode =
          "${_username[0].toUpperCase()}${_mobileNumber.substring(5, 10)}${_username[_username.length - 1].toUpperCase()}";
    });
  }

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

  // fetches the best selling products for a particular hub
  Future<List<StoreProduct>> _fetchBestSellers() async {
    final p = await Preferences.getInstance();
    String token = await p.getData("token");
    String hub = await p.getData("hub");

    Map<String, String> requestHeaders = {'x-auth-token': token};
    String url = APIService.getBestSellers(hub);
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      return jsonToStoreProductModel(response.body);
    } else {
      throw Exception('something is wrong');
    }
  }

  //This function shows the user's address in a dialog box
  // and the user can edit the address from their also
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
                      Navigator.of(context).push(CupertinoPageRoute<Null>(
                          builder: (BuildContext context) {
                        return GoogleLocationScreen(
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

  //Common Card widget for both the best sellers and Categories
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
                    return Padding(
                      padding: const EdgeInsets.only(left: 6.0, right: 12.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: ShowCards(
                              sp: itemsList[index],
                              store: store,
                              index: index,
                            ),
                          ),
                        ],
                      ),
                    );
                  }))
        ],
      ),
    );
  }

// Common text widget for both bestsellers and categories
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
                fontSize: 2.5 * SizeConfig.textMultiplier),
          ),
          GestureDetector(
            onTap: () {
              if (leftText == "Categories")
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductsUINew(tagFromMain: 0)),
                );
            },
            child: Text(
              rightText,
              style: TextStyle(
                  color: ThemeColoursSeva().dkGreen,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

// animated Route to Shoppingcart screen
  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          ScaleTransition(
        scale: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        child: child,
      ),
    );
  }

// Cart icon visible at the top left corner
  _renderCartIcon() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          child: IconButton(
              color: ThemeColoursSeva().black,
              iconSize: 30.0,
              icon: Icon(Icons.shopping_basket),
              onPressed: () {
                // Handle shopping cart
                Navigator.of(context).push(_createRoute(ShoppingCartNew()));

                // Navigator.pushNamed(context, '/shoppingCartNew');
              }),
        ),
        Positioned(
          left: 28.0,
          top: 10.0,
          child: _checkCartItems(),
        ),
      ],
    );
  }

// This function checks whether there is any item
// in the cart or not
  Widget _checkCartItems() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      height: 22.0,
      decoration: BoxDecoration(
        color: ThemeColoursSeva().pallete1,
        shape: BoxShape.circle,
      ),
      child: Consumer<NewCartModel>(
        builder: (context, cart, child) {
          return Center(
            child: Text(
              cart.totalItems == null ? '0' : cart.totalItems.toString(),
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

// shimmer layout before page loads
  _shimmerLayout(height, width) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          for (int i = 0; i < 3; i++)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              height: height * 0.20,
              width: width * 0.27,
            )
        ],
      ),
    );
  }

  /// show referral instructions with an
  /// Alert dialog
  showReferralInstructions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Referral Code $_referralCode"),
            content: Text(
                "1️⃣ Share your code with friends.\n\n2️⃣ Ask them to order on the app\n\n3️⃣ Tell them to share your code and their order number on our WhatsApp number +918595179521 (with their registered number) \n\n4️⃣ You and your buddy receive Rs 25 each cashback on your orders! Yay 🥳  🎉 \n\nThis Whatsapp sharing is temporary. We're building a cool referral system!\n\nOrder amount must be above Rs 50\n\nOnly valid once per friend"),
            actions: [
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
                color: ThemeColoursSeva().pallete1,
              ),
              SizedBox(width: 20.0),
              RaisedButton(
                onPressed: () {
                  String msg = ''' 
                  Hi, here's my referral code - $_referralCode\n1️⃣ Order on the Seva App.\n2️⃣ Share your order number and my referral code on +918595179521(Seva Business Whatsapp)\n3️⃣ We both receive Rs 25 cashback each on orders above Rs 50!\nIf you don't have the app, get it now on https://bit.ly/Seva_Android_App
                  ''';
                  Share.share(msg);
                },
                child: Text(
                  "Share",
                  style: TextStyle(color: Colors.white),
                ),
                color: ThemeColoursSeva().dkGreen,
              ),
            ],
          );
        });
  }

  /// This function gives out index and value
  /// instead of just value (like map), so this is
  /// an extension of map iterable func
  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    // height and width if the device
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: SizedBox(
        width: width * 0.5,

        /// Side Drawer visible after login
        child: Drawer(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: height * 0.15,
                width: width * 0.5,
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
                  Navigator.of(context).push(
                      CupertinoPageRoute<Null>(builder: (BuildContext context) {
                    return NewOrdersScreen();
                  }));
                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () async {
                  // clearing the data from hive
                  await Hive.deleteFromDisk();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', (Route<dynamic> route) => false);
                },
              ),
              ListTile(
                title: Text('Help'),
                subtitle: Text("Reach us on whatsapp"),
                onTap: () async {
                  var url = DotEnv().env['MSG_URL'];
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              ListTile(
                title: Text('Your referral code'),
                subtitle: Text(_referralCode == null ? "" : _referralCode),
                onTap: () {
                  showReferralInstructions();
                },
              ),
              ListTile(
                title: Text('Share app'),
                onTap: () {
                  String msg = ''' 
                  Order Fresh Fruits 🍎 🍐 🍊, Vegetables 🥦 🥕 🧅 and Daily Essentials 🥚 🥛 only on Seva.\nIf you don't like what we bring, we assure you 100% instant refund.\nDownload the app now for free delivery within 45 minutes.\nAndroid app available now:\nhttps://bit.ly/Seva_Android_App
                  ''';
                  Share.share(msg);
                },
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text('App version - Beta'),
                      subtitle: Text("0.5.1"),
                      onTap: null,
                    ),
                  ),
                ),
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
              child: SafeArea(
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
                                fontSize: 3.70 * SizeConfig.textMultiplier,
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
                              _renderCartIcon(),
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
                                  fontSize: 2.9 * SizeConfig.textMultiplier),
                            ),
                          ),
                        ],
                      ),

                      // carousel with indicator
                      Container(
                        height: height * 0.2,
                        width: double.infinity,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: CarouselSlider(
                                items: mapIndexed(
                                    texts,
                                    (index, item) => Builder(
                                          builder: (BuildContext context) {
                                            return FeaturedCards(
                                              textToDisplay: item,
                                              index: index,
                                              showInstructions:
                                                  showReferralInstructions,
                                            );
                                          },
                                        )).toList(),
                                options: CarouselOptions(
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                  height: SizeConfig.heightMultiplier * 24,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 0.8,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 4),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 600),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: false,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            ),

                            /// text visible in the carousel card
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: texts.map((url) {
                                int index = texts.indexOf(url);
                                return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _current == index
                                        ? Color.fromRGBO(0, 0, 0, 0.9)
                                        : Color.fromRGBO(0, 0, 0, 0.4),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      commonText(height, "Best Sellers", ""),
                      SizedBox(height: 9.0),

                      /// Getting the best sellers of the
                      /// particular hub
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
                            return Shimmer.fromColors(
                              highlightColor: Colors.white,
                              baseColor: Colors.grey[300],
                              child: Container(
                                child: _shimmerLayout(height, width),
                              ),
                            );
                          }),
                      commonText(height, "Categories", "SEE ALL"),
                      SizedBox(height: 9.0),
                      commonWidget(height, categories, false),
                      SizedBox(height: 9.0)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
