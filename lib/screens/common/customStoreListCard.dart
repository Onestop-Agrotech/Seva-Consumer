import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

import '../storeProductList.dart';

class StoreListCard extends StatefulWidget {
  final bool vegetablesOnly;
  final bool fruitsOnly;
  final String shopName;
  final String businessUserName;

  StoreListCard({this.vegetablesOnly, this.fruitsOnly, this.shopName, this.businessUserName});

  @override
  _StoreListCardState createState() => _StoreListCardState();
}

class _StoreListCardState extends State<StoreListCard> {
  Row _common(text) {
    return Row(
      children: <Widget>[
        Container(
          height: 5.0,
          width: 5.0,
          decoration:
              BoxDecoration(color: Colors.green, shape: BoxShape.circle),
        ),
        SizedBox(width: 8.0),
        Text(
          text,
          style: TextStyle(
              fontFamily: "Raleway",
              fontSize: 12.0,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  _tagsForStores() {
    if (widget.vegetablesOnly && !widget.fruitsOnly)
      return _common('Vegetables');
    else if (widget.fruitsOnly && !widget.vegetablesOnly)
      return _common('Fruits');
    else if (widget.vegetablesOnly && widget.fruitsOnly) {
      return Row(
        children: <Widget>[
          _common('Vegetables'),
          SizedBox(width: 20.0),
          _common('Fruits')
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => StoreProductsScreen(businessUsername: widget.businessUserName,),
          ));
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 100.0,
          child: Row(
            children: <Widget>[
              // image container
              CachedNetworkImage(
                imageUrl: "http://via.placeholder.com/200x150",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(width: 20.0),
              // description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      widget.shopName,
                      style: TextStyle(
                          fontFamily: "Raleway",
                          fontWeight: FontWeight.w500,
                          color: ThemeColoursSeva().black,
                          fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  _tagsForStores()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
