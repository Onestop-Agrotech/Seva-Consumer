// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview loading widget : loader for placing an order.
///

import 'package:flutter/material.dart';
import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/ordersModel.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/screens/common/progressIndicator.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvp/constants/apiCalls.dart';

class OrderLoader extends StatefulWidget {
  final String paymentId;
  OrderLoader({@required this.paymentId});

  @override
  _OrderLoaderState createState() => _OrderLoaderState();
}

class _OrderLoaderState extends State<OrderLoader> {
  bool _postOnce;

  @override
  initState() {
    super.initState();
    _postOnce = true;
  }

  // post the order
  _postDataToServer(responseId, newCart) async {
    _postOnce = false;
    final p = await Preferences.getInstance();
    String userId = await p.getData("id");
    String token = await p.getData("token");
    String hubid = await p.getData("hub");
    String url = APIService.ordersAPI + "new/$userId/$hubid";
    Map<String, String> requestHeaders = {'x-auth-token': token};
    // make the body
    OrderModel newOrder = new OrderModel(
        orderType: "delivery",
        finalItemsPrice: "${newCart.getCartTotalPrice()}",
        paymentType: "online",
        deliveryPrice: "0",
        paymentTransactionId: responseId);
    newOrder.customerFinalPrice =
        "${double.parse(newOrder.deliveryPrice) + double.parse(newOrder.finalItemsPrice)}";
    List<Item> itemList = [];
    for (int i = 0; i < newCart.totalItems; i++) {
      String q = "";
      if (newCart.items[i].totalQuantity % 1 == 0) {
        // whole double;
        q = newCart.items[i].totalQuantity.toStringAsFixed(0);
      } else
        q = newCart.items[i].totalQuantity.toString();
      Item it = new Item(
        itemId: newCart.items[i].id,
        name: newCart.items[i].name,
        totalPrice: "${newCart.items[i].totalPrice}",
        totalQuantity:
            "$q ${newCart.items[i].details[0].quantity.quantityMetric}",
      );
      itemList.add(it);
    }
    newOrder.items = itemList;
    var jsonBody = fromOrderModelToJson(newOrder);
    var response =
        await http.post(url, headers: requestHeaders, body: jsonBody);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Order posted!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      // clear the cart here
      newCart.clearCart();
      Navigator.pushReplacementNamed(context, "/ordersNew");
    } else if (response.statusCode == 404) {
      Fluttertoast.showToast(
          msg: "Failed to place order. Please contact Support..",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      Navigator.pushReplacementNamed(context, "/main");
    } else if (response.statusCode == 500) {
      Fluttertoast.showToast(
          msg: "Failed to place order. Please contact Support.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      Navigator.pushReplacementNamed(context, "/main");
    } else
      throw Exception("Server error!");
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<NewCartModel>(context);
    if (_postOnce) _postDataToServer(this.widget.paymentId, cart);
    return Material(
      child: Scaffold(
        body: Center(
          child: CommonGreenIndicator(),
        ),
      ),
    );
  }
}
