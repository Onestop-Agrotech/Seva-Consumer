import 'package:flutter/material.dart';

class OrderDetailsModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width*0.3,
        height: MediaQuery.of(context).size.height*0.4,
        padding: EdgeInsets.all(20),
        child: Text("Order details here!"),
      ),
    );
  }
}
