import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/screens/orders/orderDetails.dart';

class OrdersCard extends StatefulWidget {
  @override
  _OrdersCardState createState() => _OrdersCardState();
}

class _OrdersCardState extends State<OrdersCard> {

  void showDetails(){
    showModalBottomSheet(context: context, builder: (context){
      return OrderDetailsModal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.0),
        Container(
          width: MediaQuery.of(context).size.height * 0.45,
          height: MediaQuery.of(context).size.height * 0.18,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(20.0),
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
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Order number here"),
                  ),
                  Text("Ordered date here"),
                  Text("Ordered time here"),
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
