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
          return OrderDetailsModal(
            order: widget.order,
          );
        });
  }

  Text returnOrderTime(DateTime time) {
    var hour;
    var isAM = true;
    if (time.hour > 12) {
      hour = time.hour - 12;
      isAM = false;
    } else
      hour = time.hour;
    String timeString = "";
    if (isAM)
      timeString = "$hour:${time.minute} AM";
    else
      timeString = "$hour:${time.minute} PM";
    return Text(
      timeString,
      style: TextStyle(
          color: ThemeColoursSeva().pallete1, fontWeight: FontWeight.w600),
    );
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
                  returnOrderTime(widget.order.time.orderTimestamp),
                  Text(
                    "${widget.order.time.orderTimestamp.day}-${widget.order.time.orderTimestamp.month}-${widget.order.time.orderTimestamp.year}",
                    style: TextStyle(
                        color: ThemeColoursSeva().pallete1,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: () {
                      showDetails();
                    },
                    color: ThemeColoursSeva().pallete1,
                    textColor: Colors.white,
                    child: Text("View Details"),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "${widget.order.orderStatus}",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: (widget.order.orderStatus == "Delivered"
                            ? ThemeColoursSeva().pallete1
                            : ThemeColoursSeva().dkGreen)),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 6.0),
      ],
    );
  }
}
