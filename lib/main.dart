import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:mvp/screens/auth/register.dart';
import 'package:mvp/screens/userProfile.dart';
// import 'package:mvp/models/cart.dart';
// import 'package:mvp/screens/location.dart';
// import 'package:mvp/screens/auth/login.dart';
// import 'package:mvp/screens/introScreen.dart';
// import 'package:mvp/screens/products.dart';
// import 'package:mvp/screens/storesList.dart';
// import 'package:provider/provider.dart';

void main() {
  runApp(SevaApp());
}

class SevaApp extends StatelessWidget {
  final LatLng _center = const LatLng(28.570860, 77.368949);
  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [ChangeNotifierProvider(create: (context) => CartModel())],
    //   child:
    //       MaterialApp(debugShowCheckedModeBanner: false, home: StoresScreen()),
    // );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserProfileScreen(coords: _center, userEmail: 'vk.rahul318@gmail.com',),
    );
  }
}
