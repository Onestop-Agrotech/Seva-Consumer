// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.5.0
// Date-{27-09-2020}

///
///@fileoverview MainLanding Widget : This is the main landing screen after the user
///is logged in.
///
import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvp/bloc/bestsellers_bloc/bestsellers_bloc.dart';
import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/domain/bestsellers_repository.dart';
import 'package:mvp/screens/common/common_functions.dart';
import 'package:mvp/screens/common/sidenavbar.dart';
import 'package:mvp/screens/googleMapsPicker.dart';
import 'package:mvp/screens/notifications/messageHandler.dart';
import 'package:mvp/static-data/categories.dart';
import 'package:mvp/static-data/featured.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/landing/common/featuredCards.dart';
import 'package:mvp/screens/landing/common/showCards.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:shimmer/shimmer.dart';

class MainLandingScreen extends StatefulWidget {
  @override
  _MainLandingScreenState createState() => _MainLandingScreenState();
}

class _MainLandingScreenState extends State<MainLandingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BestsellersBloc apiBloc;

  String _email;
  String _address;
  String _username;
  Timer x;
  FirebaseMessaging _fcm;
  int _current = 0;
  String _mobileNumber;
  String _referralCode;

  /// safer way to intialise the bloc
  /// and also dispose it properly
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    apiBloc = BlocProvider.of<BestsellersBloc>(context);
    apiBloc.add(GetBestSellers());
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  initState() {
    super.initState();
    if (catArray[catArray.length - 1].imgURL == "") catArray.removeLast();
    getUsername();
    _fcm = new FirebaseMessaging();
    _saveDeviceToken();
    initFCM();
    x = new Timer.periodic(Duration(seconds: 10), (Timer t) => setState(() {}));
  }

  @override
  void dispose() async {
    super.dispose();
    x.cancel();
  }

//  pull to refresh
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    apiBloc.add(GetBestSellers());

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
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
        /// must retry here
      }
    }
  }

  initFCM() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        InAppMessageHandler m =
            new InAppMessageHandler(message: message, context: context);
        m.newUpdateAlert();
      },
      onLaunch: (Map<String, dynamic> message) async {
        // _serialiseAndNavigate(message);
      },
      onResume: (Map<String, dynamic> message) async {
        InAppMessageHandler m =
            new InAppMessageHandler(message: message, context: context);
        var notificationData = message['data'];
        var view = notificationData['view'];
        if (view == "new_update") m.newUpdate();
      },
    );
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
                color: ThemeColoursSeva().dkGreen,
                fontWeight: FontWeight.w500),
          ),
          content: Container(
            height: 160.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    _address,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: ThemeColoursSeva().pallete1,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.25),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute<Null>(
                          builder: (context) => GoogleMapsPicker(
                            userEmail: _email,
                          ),
                        ),
                      );
                    },
                    child: Text("Change"),
                    color: ThemeColoursSeva().pallete1,
                    textColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // To get the username of the person logged in
  // from local storage
  getUsername() async {
    final preferences = await Preferences.getInstance();
    final username = preferences.getData("username");
    final mobile = preferences.getData("mobile");
    final email = preferences.getData("email");
    setState(() {
      _email = email;
      _username = username;
      _mobileNumber = mobile;
      _referralCode =
          "${_username[0].toUpperCase()}${_mobileNumber.substring(5, 10)}${_username[_username.length - 1].toUpperCase()}";
    });
  }

  //Common Card widget for both the best sellers and Categories
  Widget commonWidget(height, itemsList, store) {
    return Container(
      height: height * 0.15,
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
                                sp: store ? itemsList[index] : null,
                                store: store,
                                index: index,
                                cat: !store ? itemsList[index] : null),
                          ),
                        ],
                      ),
                    );
                  }))
        ],
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
              height: height * 0.11,
              width: width * 0.26,
            )
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    BlocProvider(
      create: (BuildContext context) =>
          BestsellersBloc(BestSellerRepositoryImpl()),
    );
    // height and width if the device
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ThemeColoursSeva().pallete4,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.menu),
            color: ThemeColoursSeva().dkGreen,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
            iconSize: 28.0,
          ),
          title: FutureBuilder(
              future: _fetchUserAddress(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _address = snapshot.data;
                  return Text(
                    snapshot.data,
                    style: TextStyle(color: ThemeColoursSeva().black, fontSize: 13.0),
                    overflow: TextOverflow.ellipsis,
                  );
                } else
                  return Container();
              }),
          actions: [
            IconButton(
              icon: Icon(Icons.location_on_sharp),
              color: ThemeColoursSeva().dkGreen,
              onPressed: () {
                _showLocation(context);
              },
              iconSize: 28.0,
            )
          ],
        ),
        drawer: SizedBox(
            width: width * 0.5,
            child: Sidenav(
              height: height,
              width: width,
              username: _username,
              referralCode: _referralCode,
            )),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: SmartRefresher(
                    enablePullDown: true,
                    // enablePullUp: true,
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus mode) {
                        if (mode == LoadStatus.loading) {
                          CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          Text("Load Failed!Please retry!");
                        }
                        return Container();
                      },
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView(
                      children: <Widget>[
                        // carousel with indicator
                        Container(
                          height: 26.0 * SizeConfig.heightMultiplier,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: ThemeColoursSeva().pallete4,
                              borderRadius: BorderRadius.only(
                                bottomRight:Radius.elliptical(30.0, 20.0),
                                bottomLeft:Radius.elliptical(30.0, 20.0),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: CarouselSlider(
                                    items: mapIndexed(
                                        featuredArr,
                                        (index, item) => Builder(
                                              builder: (BuildContext context) {
                                                return FeaturedCards(
                                                    featuredItem: item,
                                                    index: index,
                                                    referralCode:
                                                        _referralCode);
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
                                      autoPlayInterval: Duration(seconds: 6),
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 600),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: false,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      mapIndexed(featuredArr, (index, item) {
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
                        ),
                        SizedBox(height: 12.0),
                        HelperFunctions.commonText(
                            height, "Best Sellers", "", context),
                        SizedBox(height: 9.0),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: BlocBuilder<BestsellersBloc, BestsellersState>(
                            builder: (context, state) {
                              if (state is BestSellersInitial ||
                                  state is BestSellersLoading) {
                                return Shimmer.fromColors(
                                  highlightColor: Colors.white,
                                  baseColor: Colors.grey[300],
                                  child: Container(
                                    child: _shimmerLayout(height, width),
                                  ),
                                );
                              } else if (state is BestSellersLoaded) {
                                List<StoreProduct> arr = state.bestsellers;
                                arr.sort((a, b) => a.name.compareTo(b.name));
                                return commonWidget(height, arr, true);
                              } else if (state is BestSellersError) {
                                return Center(
                                    child: Text(
                                  state.msg,
                                  style: TextStyle(
                                      color: ThemeColoursSeva().dkGreen,
                                      fontSize: 2 * SizeConfig.textMultiplier),
                                ));
                              } else
                                return Container(
                                  child:
                                      Center(child: Text("No products found!")),
                                );
                            },
                          ),
                        ),
                        HelperFunctions.commonText(
                            height, "Categories", "", context),
                        SizedBox(height: 9.0),
                        Row(
                          children: List.generate(
                            3,
                            (index) => ShowCards(
                              store: false,
                              index: 0,
                              sp: null,
                              cat: catArray[index],
                            ),
                          ),
                        ),
                        Row(
                            children: List.generate(
                          2,
                          (index) => ShowCards(
                            store: false,
                            index: 0,
                            sp: null,
                            cat: catArray[index + 3],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
