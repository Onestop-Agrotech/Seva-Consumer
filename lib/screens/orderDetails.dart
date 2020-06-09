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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Total"),
            SizedBox(width: 20.0),
            Text("Rs ${order.customerFinalPrice}")
          ],
        ),
        SizedBox(height: 10.0),
        order.orderType == 'Delivery'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Delivery Charges"),
                  SizedBox(width: 20.0),
                  Text("Rs ${order.deliveryPrice}")
                ],
              )
            : Container(),
            SizedBox(height: 30.0),
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
          title: TopText(txt: 'Order Summary'),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: <Widget>[
          Text("Order #1234567899",
              style: TextStyle(
                  fontFamily: "Raleway",
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  color: ThemeColoursSeva().black)),
          SizedBox(height: 30.0),
          Expanded(
            child: _buildArray(),
          ),
        ],
      ),
    );
  }
}
