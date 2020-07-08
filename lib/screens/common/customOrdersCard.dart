import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/ordersModel.dart';
import 'package:mvp/screens/orderDetails.dart';

class CustomOrdersCard extends StatefulWidget {
  final OrderModel order;

  CustomOrdersCard({this.order});
  @override
  _CustomOrdersCardState createState() => _CustomOrdersCardState();
}

class _CustomOrdersCardState extends State<CustomOrdersCard> {
  var _time;
  bool _less = false;

  @override
  void initState() {
    super.initState();
    _time = DateTime.parse(widget.order.timestamp.toString()).toLocal();
    if (int.parse(_time.minute.toString()) < 10)
      setState(() {
        _less = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.0,
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "${widget.order.storeName}",
                style: TextStyle(
                    fontFamily: "Raleway",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ThemeColoursSeva().black),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              widget.order.otp != '0'
                  ? Text(
                      widget.order.orderType != "Delivery"
                          ? "OTP ${widget.order.otp}"
                          : "No OTP",
                      style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: ThemeColoursSeva().black),
                    )
                  : Text("Served"),
              SizedBox(height: 10.0),
              Text(
                "Order No. ${widget.order.orderNumber}",
                style: TextStyle(
                    fontFamily: "Raleway",
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: ThemeColoursSeva().black),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "${_time.day}/${_time.month}/${_time.year}",
                    style: TextStyle(
                        fontFamily: "Raleway",
                        fontSize: 14.0,
                        color: ThemeColoursSeva().black),
                  ),
                  SizedBox(width: 10.0),
                  _less
                      ? Text("${_time.hour}:0${_time.minute}",
                          style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 14.0,
                              color: ThemeColoursSeva().black))
                      : Text("${_time.hour}:${_time.minute}",
                          style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 14.0,
                              color: ThemeColoursSeva().black)),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                widget.order.orderType != "Delivery"
                    ? "TOKEN ${widget.order.tokenNumber}"
                    : "No TOKEN",
                style: TextStyle(
                    fontFamily: "Raleway",
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: ThemeColoursSeva().black),
              ),
              SizedBox(height: 10.0),
              Text("${widget.order.orderStatus}",
                  style: TextStyle(
                      fontFamily: "Raleway",
                      fontSize: 17.0,
                      color: Colors.deepOrange)),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  Text("${widget.order.orderType}",
                      style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 14.0,
                          color: ThemeColoursSeva().black)),
                  SizedBox(width: 10.0),
                  FlatButton(
                    shape: Border.all(width: 0.2),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailsScreen(
                              order: widget.order,
                            ),
                          ));
                    },
                    child: Text("More Details",
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 14.0,
                        )),
                    textColor: ThemeColoursSeva().dkGreen,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
