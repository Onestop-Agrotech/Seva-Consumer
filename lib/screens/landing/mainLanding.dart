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
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvp/bloc/bestsellers_bloc/bestsellers_bloc.dart';
import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/domain/bestsellers_repository.dart';
import 'package:mvp/screens/common/common_functions.dart';
import 'package:mvp/screens/common/customappBar.dart';
import 'package:mvp/screens/common/sidenavbar.dart';
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
import 'package:mvp/screens/landing/graphics/darkBG.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:shimmer/shimmer.dart';
import 'graphics/lightBG.dart';

class MainLandingScreen extends StatefulWidget {
  @override
  _MainLandingScreenState createState() => _MainLandingScreenState();
}

class _MainLandingScreenState extends State<MainLandingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BestsellersBloc apiBloc;
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
        appBar: CustomAppBar(
          height: 120,
          scaffoldKey: _scaffoldKey,
          email: _email,
        ),
        drawer: SizedBox(
            width: width * 0.5,

            /// Side Drawer visible after login
            child: Sidenav(
              height: height,
              width: width,
              username: _username,
              referralCode: _referralCode,
            )),
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
                                    fontSize: 2.7 * SizeConfig.textMultiplier),
                              ),
                            ),
                          ],
                        ),

                        // carousel with indicator
                        Container(
                          height: 23.0 * SizeConfig.heightMultiplier,
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
                                                  referralCode: _referralCode);
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
                        HelperFunctions.commonText(
                            height, "Best Sellers", "", context),
                        SizedBox(height: 9.0),
                        BlocBuilder<BestsellersBloc, BestsellersState>(
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
                        HelperFunctions.commonText(
                            height, "Categories", "", "SEE ALL"),
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
      ),
    );
  }
}
