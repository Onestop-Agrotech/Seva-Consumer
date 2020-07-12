import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

import '../storeProductList.dart';

class StoreListCard extends StatefulWidget {
  final bool vegetablesOnly;
  final bool fruitsOnly;
  final String shopName;
  final String businessUserName;
  final String distance;
  final bool online;
  final String pictureURL;

  StoreListCard(
      {this.vegetablesOnly,
      this.fruitsOnly,
      this.shopName,
      this.businessUserName,
      this.distance,
      this.online,
      this.pictureURL});

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
            fontWeight: FontWeight.w500,
            color:
                widget.online == false ? Colors.grey : ThemeColoursSeva().black,
          ),
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
          if (widget.online == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoreProductsScreen(
                    businessUsername: widget.businessUserName,
                    shopName: widget.shopName,
                    distance: widget.distance,
                  ),
                ));
          } else {
            print("shop is close");
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 130.0,
          // decoration: BoxDecoration(border: Border.all(width: 0.1)),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 3.0),
            child: Row(
              children: <Widget>[
                // image container
                Stack(
                  children: <Widget>[
                    Container(
                      height: 110.0,
                      width: MediaQuery.of(context).size.width * 0.375,
                      child: CachedNetworkImage(
                        imageUrl: widget.pictureURL,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                          backgroundColor: ThemeColoursSeva().black,
                          strokeWidth: 4.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ThemeColoursSeva().grey),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    widget.online == false
                        ? Container(
                            height: 110.0,
                            width: MediaQuery.of(context).size.width * 0.375,
                            color: Colors.grey.withOpacity(0.75),
                            child: Center(
                              child: Text(
                                "Closed",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.transparent,
                          ),
                  ],
                ),
                SizedBox(width: 20.0),
                // description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.46,
                      child: Text(
                        widget.shopName,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w500,
                            color: widget.online == false
                                ? Colors.grey
                                : ThemeColoursSeva().black,
                            fontSize: 14.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      widget.distance,
                      style: TextStyle(
                          fontFamily: "Raleway",
                          color: widget.online == false
                              ? Colors.grey
                              : ThemeColoursSeva().black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5),
                    ),
                    SizedBox(height: 20.0),
                    _tagsForStores()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
