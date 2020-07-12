import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/ordersModel.dart';
import 'package:mvp/screens/common/topText.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;
  static final TextStyle _tStyle = TextStyle(
      fontFamily: "Raleway", fontSize: 16.0, color: ThemeColoursSeva().black);

  OrderDetailsScreen({this.order});

  _launchURL() async {
    String url =
        "https://www.google.com/maps/dir/?api=1&origin=${order.orderOriginLat},${order.orderOriginLong}&destination=${order.orderDestLat},${order.orderDestLong}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _buildArray() {
    List<Item> iArr = this.order.items;
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: ListView.builder(
              itemCount: iArr.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("${iArr[index].name}",
                        style: TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 16.0,
                            color: ThemeColoursSeva().black)),
                    Text("x ${iArr[index].totalQuantity}",
                        style: TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 16.0,
                            color: ThemeColoursSeva().black)),
                    Text("Rs ${iArr[index].totalPrice}",
                        style: TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 16.0,
                            color: ThemeColoursSeva().black)),
                  ],
                );
              }),
        ),
      ],
    );
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
                Navigator.pop(context);
              }),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TopText(txt: 'Order - ${order.orderNumber}'),
          centerTitle: true,
        ),
      ),
      body: Container(
        height: 350.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                "From ${order.storeName}",
                style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w500,
                    color: ThemeColoursSeva().black),
                overflow: TextOverflow.clip,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
                order.orderType != "Delivery"
                    ? "TOKEN ${order.tokenNumber}"
                    : "",
                style: TextStyle(
                    fontFamily: "Raleway",
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: ThemeColoursSeva().black)),
            SizedBox(height: 20.0),
            Expanded(
              child: _buildArray(),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Sub total", style: _tStyle),
                    Text("Delivery Charges", style: _tStyle),
                    Text("Grand Total", style: _tStyle)
                  ],
                ),
                SizedBox(width: 40.0),
                Column(
                  children: <Widget>[
                    Text("Rs ${order.finalItemsPrice}", style: _tStyle),
                    Text("Rs ${order.deliveryPrice}", style: _tStyle),
                    Text("Rs ${order.customerFinalPrice}", style: _tStyle)
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
            order.orderType == "Delivery"
                ? Text("Address: ${order.customerAddress}")
                : Text(""),
            SizedBox(
              height: 20.0,
            ),
            order.orderType == "Pick Up" && order.orderStatus != "finished"
                ? RaisedButton(
                    onPressed: () {
                      _launchURL();
                    },
                    child: Text("Get directions"),
                  )
                : Text("")
          ],
        ),
      ),
    );
  }
}
