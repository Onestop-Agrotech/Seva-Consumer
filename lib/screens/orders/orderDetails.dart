import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/ordersModel.dart';

class OrderDetailsModal extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsModal({Key key, this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Details: #${order.orderNumber}",
              style: TextStyle(
                  color: ThemeColoursSeva().dkGreen,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20.0),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.30,
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        Text(
                          "Product1 x 3 Kgs",
                          style: TextStyle(
                              color: ThemeColoursSeva().pallete1,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4.0),
                      ],
                    );
                  }),
            ),
            SizedBox(height: 20.0),
            Text(
              "Delivery fee: Rs ${order.deliveryPrice}",
              style: TextStyle(
                  color: ThemeColoursSeva().dkGreen,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12.0),
            Text(
              "Order Price: Rs ${order.finalItemsPrice}",
              style: TextStyle(
                  color: ThemeColoursSeva().dkGreen,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12.0),
            Text(
              "Total Price: Rs ${order.customerFinalPrice}",
              style: TextStyle(
                  color: ThemeColoursSeva().dkGreen,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}