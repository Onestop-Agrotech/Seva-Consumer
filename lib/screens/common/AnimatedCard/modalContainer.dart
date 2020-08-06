import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/storeProducts.dart';

class AddItemModal extends StatefulWidget {
  final StoreProduct product;
  AddItemModal({@required this.product});
  @override
  _AddItemModalState createState() => _AddItemModalState();
}

class _AddItemModalState extends State<AddItemModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      height: MediaQuery.of(context).size.height - 300,
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            widget.product.name,
            style: TextStyle(
              color: ThemeColoursSeva().pallete2,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
              "Rs ${widget.product.price} - ${widget.product.quantity.quantityValue} ${widget.product.quantity.quantityMetric}",
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: ThemeColoursSeva().pallete2,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              )),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CachedNetworkImage(
                  width: 100, height: 80, imageUrl: widget.product.pictureUrl),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        // shrinkWrap: true,
                        itemCount:
                            widget.product.quantity.allowedQuantities.length,
                        itemBuilder: (builder, i) {
                          return Column(
                            children: [
                              Text(
                                "${widget.product.quantity.allowedQuantities[i].value} ${widget.product.quantity.allowedQuantities[i].metric}",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: ThemeColoursSeva().pallete2,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 7.0),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Apples contain  no fat, sodium or cholestrol and are a good source",
            style: TextStyle(decoration: TextDecoration.none, fontSize: 10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Item Total Price",
                style: TextStyle(decoration: TextDecoration.none, fontSize: 10),
              ),
              Text(
                "250",
                style: TextStyle(decoration: TextDecoration.none, fontSize: 10),
              )
            ],
          )
        ],
      ),
    );
  }
}
