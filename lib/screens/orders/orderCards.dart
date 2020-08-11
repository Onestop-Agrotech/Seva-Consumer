import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/ordersModel.dart';
import 'package:mvp/screens/orders/orderDetails.dart';

class OrdersCard extends StatefulWidget {
  final OrderModel order;

  const OrdersCard({Key key, this.order}) : super(key: key);

  @override
  _OrdersCardState createState() => _OrdersCardState();
}

class _OrdersCardState extends State<OrdersCard> {
  void showDetails() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return OrderDetailsModal();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Container(
          width: MediaQuery.of(context).size.height * 0.45,
          height: MediaQuery.of(context).size.height * 0.18,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: ThemeColoursSeva().pallete3,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      "#${widget.order.orderNumber}",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: ThemeColoursSeva().dkGreen),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Text(
                    "${widget.order.timestamp}",
                    style: TextStyle(
                        color: ThemeColoursSeva().pallete1,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${widget.order.timestamp}",
                    style: TextStyle(
                        color: ThemeColoursSeva().pallete1,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: () {
                  showDetails();
                },
                color: ThemeColoursSeva().pallete1,
                textColor: Colors.white,
                child: Text("View Details"),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.0),
      ],
    );
  }
}
