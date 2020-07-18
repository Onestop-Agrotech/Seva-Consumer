import 'package:flutter/material.dart';
import 'package:mvp/models/cart.dart';
import 'package:mvp/screens/auth/login.dart';
import 'package:mvp/screens/auth/register.dart';
import 'package:mvp/screens/loading.dart';
import 'package:mvp/screens/orders.dart';
import 'package:mvp/screens/payments.dart';
import 'package:mvp/screens/storeProductList.dart';
import 'package:mvp/screens/storesList.dart';
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
      providers: [ChangeNotifierProvider(create: (context) => CartModel())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoadingScreen(),
        routes: {
          "/register": (context) => RegisterScreen(),
          "/login": (context) => LoginScreen(),
          "/orders": (context) => OrdersScreen(),
          "/stores": (context) => StoresScreen(),
          "/storesProducts": (context) => StoreProductsScreen(),
          "/payment": (context) => Payments()
        },
      ),
    );
  }
}
