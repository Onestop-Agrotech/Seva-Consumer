// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{03-09-2020}

///
/// @fileoverview Main Dart File : All routes and landing screen are defined here.
///

import 'package:flutter/material.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/screens/auth/login.dart';
import 'package:mvp/screens/auth/register.dart';
import 'package:mvp/screens/errors/notServing.dart';
import 'package:mvp/screens/landing/mainLanding.dart';
import 'package:mvp/screens/loading.dart';
import 'package:mvp/screens/orders/ordersScreen.dart';
import 'package:mvp/screens/shoppingCart/shoppingCartNew.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(SevaApp());
}

class SevaApp extends StatefulWidget {
  @override
  _SevaAppState createState() => _SevaAppState();
}

class _SevaAppState extends State<SevaApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => NewCartModel())],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: LoadingScreen(),
                routes: {
                  "/register": (context) => RegisterScreen(),
                  "/login": (context) => LoginScreen(),
                  "/main": (context) => MainLandingScreen(),
                  "/shoppingCartNew": (context) => ShoppingCartNew(),
                  "/ordersNew": (context) => NewOrdersScreen(),
                  "/notServing": (context) => NotServing()
                },
              );
            },
          );
        },
      ),
    );
  }
}
