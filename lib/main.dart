import 'package:flutter/material.dart';
import 'package:mvp/models/cart.dart';
import 'package:mvp/screens/auth/login.dart';
import 'package:mvp/screens/auth/register.dart';
import 'package:mvp/screens/landing/mainLanding.dart';
// import 'package:mvp/screens/common/customProductCard.dart';
// import 'package:mvp/screens/common/productCard.dart';
// import 'package:mvp/screens/loading.dart';
import 'package:mvp/screens/orders.dart';
import 'package:mvp/screens/payments.dart';
import 'package:mvp/screens/products.dart';
import 'package:mvp/screens/promocodescreen.dart';
import 'package:mvp/screens/shoppingCartNew.dart';
import 'package:mvp/screens/storeProductList.dart';
import 'package:mvp/screens/storesList.dart';
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
      providers: [ChangeNotifierProvider(create: (context) => CartModel())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PromoCodeScreen(),
        routes: {
          "/register": (context) => RegisterScreen(),
          "/login": (context) => LoginScreen(),
          "/orders": (context) => OrdersScreen(),
          "/main": (context) => MainLandingScreen(),
          "/stores": (context) => StoresScreen(),
          "/storesProducts": (context) => StoreProductsScreen(),
          "/payment": (context) => Payments()
        },
      ),
    );
  }
}
