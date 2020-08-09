import 'package:flutter/material.dart';
import 'package:mvp/screens/orders/orderDetails.dart';

class OrdersCard extends StatefulWidget {
  @override
  _OrdersCardState createState() => _OrdersCardState();
}

class _OrdersCardState extends State<OrdersCard> {
  // open Modal for order details
  void onClickOrder() {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return OrderDetailsModal();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.0),
        Container(
          width: MediaQuery.of(context).size.height * 0.4,
          height: MediaQuery.of(context).size.height * 0.14,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        SizedBox(height: 6.0),
      ],
    );
  }
}
