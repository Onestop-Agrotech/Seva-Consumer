import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/orders/orderCards.dart';

class NewOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {},
              iconSize: 27.0,
              color: Colors.black,
            ),
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
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 3,
          itemBuilder: (builder, index) {
            return OrdersCard();
          }),
    );
  }
}
