import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/ordersModel.dart';
import 'package:mvp/screens/common/topText.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  OrderDetailsScreen({this.order});

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
        height: 300.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Token No. ${order.tokenNumber}",
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
                    Text("Sub total",
                        style: TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 16.0,
                            color: ThemeColoursSeva().black)),
                    Text("Delivery Charges",
                        style: TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 16.0,
                            color: ThemeColoursSeva().black)),
                    Text("Grand Total",
                        style: TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 16.0,
                            color: ThemeColoursSeva().black))
                  ],
                ),
                SizedBox(width: 40.0),
                Column(
                  children: <Widget>[
                    Text("Rs ${order.finalItemsPrice}",
                        style: TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 16.0,
                            color: ThemeColoursSeva().black)),
                    Text("Rs ${order.deliveryPrice}",
                        style: TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 16.0,
                            color: ThemeColoursSeva().black)),
                    Text("Rs ${order.customerFinalPrice}",
                        style: TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 16.0,
                            color: ThemeColoursSeva().black))
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
