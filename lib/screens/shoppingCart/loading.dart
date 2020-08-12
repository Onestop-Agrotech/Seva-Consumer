import 'package:flutter/material.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/ordersModel.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
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
    _postOnce=true;
  }

  // post the order
  _postDataToServer(responseId, newCart) async {
    _postOnce=false;
    StorageSharedPrefs p = new StorageSharedPrefs();
    String userId = await p.getId();
    String token = await p.getToken();
    String url = APIService.ordersAPI + "/new/$userId";
    Map<String, String> requestHeaders = {'x-auth-token': token};
    // make the body
    OrderModel newOrder = new OrderModel(
        orderType: "delivery",
        finalItemsPrice: "${newCart.getCartTotalPrice()}",
        deliveryPrice: "20",
        paymentType: "online",
        paymentTransactionId: responseId);
    // if (double.parse(_userOrders) < 3.0) newOrder.deliveryPrice = "0";
    newOrder.customerFinalPrice =
        "${double.parse(newOrder.deliveryPrice) + double.parse(newOrder.finalItemsPrice)}";
    List<Item> itemList = [];
    for (int i = 0; i < newCart.totalItems; i++) {
      Item it = new Item(
        itemId: newCart.items[i].id,
        name: newCart.items[i].name,
        totalPrice: "${newCart.items[i].totalPrice}",
        totalQuantity: "${newCart.items[i].totalQuantity} ${newCart.items[i].quantity.quantityMetric}",
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
          msg: "404 error",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } else if (response.statusCode == 500) {
      Fluttertoast.showToast(
          msg: "500 error",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } else
      throw Exception("Server error!");
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<NewCartModel>(context);
    if(_postOnce)_postDataToServer(this.widget.paymentId, cart);
    return Material(
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
