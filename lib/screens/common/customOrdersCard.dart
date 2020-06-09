import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/ordersModel.dart';

class CustomOrdersCard extends StatefulWidget {
  final OrderModel order;

  CustomOrdersCard({this.order});
  @override
  _CustomOrdersCardState createState() => _CustomOrdersCardState();
}

class _CustomOrdersCardState extends State<CustomOrdersCard> {
  var _time;
  bool _less=false;

  @override
  void initState() {
    super.initState();
    _time = DateTime.parse(widget.order.timestamp.toString()).toLocal();
    if(int.parse(_time.minute.toString())<10)setState(() {
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
              Text("${widget.order.id}"),
              Row(
                children: <Widget>[
                  Text("${_time.day}/${_time.month}/${_time.year}"),
                  SizedBox(width: 10.0),
                  _less ? Text("${_time.hour}:0${_time.minute}") : Text("${_time.hour}:${_time.minute}"),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("${widget.order.orderStatus}"),
              Row(
                children: <Widget>[
                  Text("${widget.order.orderType}"),
                  FlatButton(onPressed: (){}, child: Text("More Details"), textColor: ThemeColoursSeva().dkGreen,)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}