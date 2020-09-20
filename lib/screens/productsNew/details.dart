import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/models/storeProducts.dart';

class ProductDetails extends StatefulWidget {
  final StoreProduct p;
  ProductDetails({@required this.p});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200, maxHeight: 220),
          child: Hero(
            tag: this.widget.p.name,
            child: CachedNetworkImage(imageUrl: this.widget.p.pictureURL),
          ),
        ),
      )),
    );
  }
}
