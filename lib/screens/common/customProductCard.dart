import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Color cc;

  ProductCard({this.cc});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 240.0,
      width: width*0.43,
      decoration: BoxDecoration(
        color: cc,
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }
}