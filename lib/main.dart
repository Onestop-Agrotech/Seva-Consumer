// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.5.0
// Date-{27-09-2020}

///
/// @fileoverview Main Dart File : All routes and landing screen are defined here.
///

import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mvp/bloc/bestsellers_bloc/bestsellers_bloc.dart';
import 'package:mvp/bloc/search_bloc/search_bloc.dart';
import 'package:mvp/classes/storeProducts_box.dart';
import 'package:mvp/domain/bestsellers_repository.dart';
import 'package:mvp/domain/product_repository.dart';
import 'package:mvp/domain/search_repository.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/models/users.dart';
import 'package:mvp/screens/auth/login.dart';
import 'package:mvp/screens/auth/register.dart';
import 'package:mvp/screens/errors/notServing.dart';
import 'package:mvp/screens/landing/mainLanding.dart';
import 'package:mvp/screens/orders/ordersScreen.dart';
import 'package:mvp/screens/shoppingCart/shoppingCartNew.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:mvp/static_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'bloc/products_bloc/productsapi_bloc.dart';

Future main() async {
  await DotEnv().load('.env');
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(DetailsAdapter());
  Hive.registerAdapter(QuantityAdapter());
  Hive.registerAdapter(AllowedQuantityAdapter());
  Hive.registerAdapter(StoreProductAdapter());

  runApp(SevaApp());
}

class SevaApp extends StatefulWidget {
  @override
  _SevaAppState createState() => _SevaAppState();
}

class _SevaAppState extends State<SevaApp> {
  /// platform client for invoking in-app updates
  static const platform = const MethodChannel('update_app');

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    /// check for update, if one exists, then perform the update
    /// else just continue with app
    /// Only supported for android
    if (Platform.isAndroid) {
      platform.invokeMethod("checkForUpdate");
    }
  }

  @override
  void dispose() async {
    final SPBox s = await SPBox.getSPBoxInstance();
    await s.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NewCartModel()),
        BlocProvider(
          create: (BuildContext context) =>
              ProductsapiBloc(ProductRepositoryImpl()),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              BestsellersBloc(BestSellerRepositoryImpl()),
        ),
        BlocProvider(
          create: (BuildContext context) => SearchBloc(SearchRepositoryImpl()),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                // home: LoadingScreen(),
                home: StaticPage(),
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
