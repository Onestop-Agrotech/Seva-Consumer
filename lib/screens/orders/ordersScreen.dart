import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/ordersModel.dart';
import 'package:mvp/screens/orders/orderCards.dart';
import 'package:http/http.dart' as http;

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

  _getOrderOfUser() async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String id = await p.getId();
    String token = await p.getToken();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 27.0,
          color: Colors.black,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "My Orders",
              style: TextStyle(
                  color: ThemeColoursSeva().dkGreen,
                  fontSize: 25.0,
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
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
