import 'package:flutter/material.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/screens/auth/login.dart';
import 'package:mvp/screens/auth/register.dart';
import 'package:mvp/screens/landing/mainLanding.dart';
import 'package:mvp/screens/orders.dart';
import 'package:mvp/screens/orders/ordersScreen.dart';
import 'package:mvp/screens/shoppingCart/shoppingCartNew.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:in_app_update/in_app_update.dart';

void main() {
  runApp(SevaApp());
}

class SevaApp extends StatefulWidget {
  @override
  _SevaAppState createState() => _SevaAppState();
}

class _SevaAppState extends State<SevaApp> {
  AppUpdateInfo _updateInfo;

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) => print(e));
    if (_updateInfo?.updateAvailable == true) {
      InAppUpdate.performImmediateUpdate().catchError((e) => print(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => NewCartModel())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainLandingScreen(),
        routes: {
          "/register": (context) => RegisterScreen(),
          "/login": (context) => LoginScreen(),
          "/orders": (context) => OrdersScreen(),
          "/main": (context) => MainLandingScreen(),
          "/shoppingCartNew": (context) => ShoppingCartNew(),
          "/ordersNew": (context) => NewOrdersScreen()
        },
      ),
    );
  }
}
