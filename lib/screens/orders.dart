import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/ordersModel.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/screens/common/customOrdersCard.dart';

import 'common/topText.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _data;

  @override
  void initState() {
    super.initState();
    _data = true;
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
      // print(json.decode(response.body)["orders"] is String);
    } else if (response.statusCode == 404) {
      // no orders
      setState(() {
        _data = false;
      });
    } else
      throw Exception("Server error");
  }

  _dataOrNot() {
    if (_data == false)
      return Container(
        child: Center(
          child: Text("No Orders available!"),
        ),
      );
    else
      return Column(
        children: <Widget>[Expanded(child: _buildOrdersArray())],
      );
  }

  FutureBuilder _buildOrdersArray() {
    return FutureBuilder(
        future: _getOrderOfUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<OrderModel> ordersArr = snapshot.data;
            if (ordersArr.length > 0) {
              // sort the array according to time
              ordersArr.sort((a, b) =>
                  b.timestamp.toString().compareTo(a.timestamp.toString()));
              // build array
              return ListView.builder(
                  itemCount: ordersArr.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        CustomOrdersCard(
                          order: ordersArr[index],
                        ),
                        SizedBox(height: 30.0)
                      ],
                    );
                  });
            } else {
              return Container(
                child: Center(
                  child: Text("No orders available. Make one now!"),
                ),
              );
            }
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: ThemeColoursSeva().black,
                  strokeWidth: 4.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ThemeColoursSeva().grey),
                ),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: ThemeColoursSeva().black,
                size: 40.0,
              ),
              onPressed: () {
                // go to store list
                Navigator.pop(context);
                Navigator.pushNamed(context, '/stores');
              }),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TopText(txt: 'My Orders'),
          centerTitle: true,
        ),
      ),
      body: _dataOrNot(),
    );
  }
}
