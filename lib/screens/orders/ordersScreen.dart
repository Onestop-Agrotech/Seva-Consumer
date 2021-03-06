// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview OrderScreen Widget :
///

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mvp/classes/prefrenses.dart';
import 'dart:convert';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/ordersModel.dart';
import 'package:mvp/screens/orders/orderCards.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class NewOrdersScreen extends StatefulWidget {
  @override
  _NewOrdersScreenState createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> {
  Timer x;
  @override
  initState() {
    super.initState();
    x = new Timer.periodic(Duration(seconds: 60), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    x.cancel();
    super.dispose();
  }

// shimmer layout before page loads
  _shimmerLayout(width, height) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 10),
        for (int i = 0; i < 6; i++)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              width: height * 0.45,
              height: height * 0.18,
            ),
          )
      ],
    );
  }

  _getOrderOfUser() async {
    final p = await Preferences.getInstance();
    String id = await p.getData("id");
    String token = await p.getData("token");
    String url = APIService.ordersAPI + "$id";
    Map<String, String> requestHeaders = {'x-auth-token': token};
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      // got orders
      return toOrdersFromJson(json.decode(response.body)["orders"]);
    } else if (response.statusCode == 404) {
      // no orders
      return [];
    } else
      throw Exception("Server error");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "My Orders",
              style: TextStyle(
                  color: ThemeColoursSeva().pallete1,
                  fontWeight: FontWeight.w500),
            ),
            Container(
              width: 20.0,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _getOrderOfUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<OrderModel> orders = snapshot.data;
              orders.sort((a, b) =>
                  b.time.orderTimestamp.compareTo(a.time.orderTimestamp));
              if (orders.length > 0) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: orders.length,
                    itemBuilder: (builder, index) {
                      return OrdersCard(order: orders[index]);
                    });
              } else
                return Container(
                  child: Center(
                      child: Text(
                    "No orders. Make one now!",
                    style: TextStyle(
                        color: ThemeColoursSeva().pallete1,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  )),
                );
            } else if (snapshot.hasError) {
              return Container(
                child: Center(
                    child: Text(
                  "Oops! Encountered an error. Please login again.",
                  style: TextStyle(
                      color: ThemeColoursSeva().pallete1,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                )),
              );
            } else {
              return Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey[300],
                child: Container(
                  child: _shimmerLayout(width, height),
                ),
              );
            }
          }),
    );
  }
}
