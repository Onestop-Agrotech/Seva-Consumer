import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/products/products.dart';

class ShowCards extends StatelessWidget {
  final StoreProduct sp;
  final bool store;
  final int index;
  ShowCards({this.sp, this.store, @required this.index});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (!this.store)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Products(type: this.index)),
          );
      },
      child: Container(
        // fallback height
        height: height * 0.22,
        width: width * 0.4,
        decoration: BoxDecoration(
            border: Border.all(
              color: ThemeColoursSeva().pallete3,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            store
                ? Text(
                    "${sp.name}",
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: ThemeColoursSeva().pallete1,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700),
                  )
                : SizedBox.shrink(),
            Container(
              height: height * 0.1,
              child: CachedNetworkImage(
                imageUrl: sp.pictureUrl,
                placeholder: (context, url) =>
                    Container(height: 50.0, child: Text("Loading...")),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            store
                ? Text(
                    "Rs ${sp.price} - ${sp.quantity.quantityValue} ${sp.quantity.quantityMetric}",
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: ThemeColoursSeva().pallete1,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700),
                  )
                : Text(
                    "${sp.name}",
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: ThemeColoursSeva().pallete1,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700),
                  )
          ],
        ),
      ),
    );
  }
}
