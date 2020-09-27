// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview ModalContainer modal : contains the info about the product.
///

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:provider/provider.dart';

class AddItemModal extends StatefulWidget {
  final StoreProduct product;
  AddItemModal({@required this.product});
  @override
  _AddItemModalState createState() => _AddItemModalState();
}

class _AddItemModalState extends State<AddItemModal> {
  void helper(int index, NewCartModel newCart, bool addToCart) {
    double p, q;

    // Kg, Kgs, Gms, Pc - Types of Quantities

    // For Kg & Pc
    if (widget.product.details[0].quantity.allowedQuantities[index].metric ==
        "Kg") {
      q = 1;
      p = double.parse("${widget.product.details[0].price}");
    }
    // For Gms && ML
    else if (widget
                .product.details[0].quantity.allowedQuantities[index].metric ==
            "Gms" ||
        widget.product.details[0].quantity.allowedQuantities[index].metric ==
            "ML") {
      q = (widget.product.details[0].quantity.allowedQuantities[index].value /
          1000.0);
      p = (widget.product.details[0].quantity.allowedQuantities[index].value /
              1000.0) *
          widget.product.details[0].price;
    }
    // For Pc, Pack, Kgs & Ltr
    else if (widget
                .product.details[0].quantity.allowedQuantities[index].metric ==
            "Pc" ||
        widget.product.details[0].quantity.allowedQuantities[index].metric ==
            "Kgs" ||
        widget.product.details[0].quantity.allowedQuantities[index].metric ==
            "Ltr" ||
        widget.product.details[0].quantity.allowedQuantities[index].metric ==
            "Pack") {
      q = double.parse(
          "${widget.product.details[0].quantity.allowedQuantities[index].value}");
      p = widget.product.details[0].price * q;
    }

    addToCart
        ? newCart.addToCart(widget.product, index, p, q)
        : newCart.removeFromCart(widget.product, index, p, q);
  }

  // shows/edit the quantity of the product
  Text _showQ(newCart, item, index) {
    int qty = 0;
    newCart.items.forEach((e) {
      if (e.id == item.id) {
        qty = e.details[0].quantity.allowedQuantities[index].qty;
      }
    });
    return Text("$qty");
  }

  // shows/edit the total price of a particular item
  Text _showItemTotalPrice(newCart) {
    double price = 0;
    newCart.items.forEach((e) {
      if (e.id == widget.product.id) {
        price = e.totalPrice;
      }
    });
    return Text(
      "Rs $price",
      style: TextStyle(
        color: ThemeColoursSeva().dkGreen,
        fontSize: 1.9 * SizeConfig.textMultiplier,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // shows/edit the total quantity of the product
  Text _showTotalItemQty(newCart) {
    double totalQ = 0.0;
    newCart.items.forEach((e) {
      if (e.id == widget.product.id) {
        totalQ = e.totalQuantity;
      }
    });

    return Text(
      totalQ != 0.0
          ? "${totalQ.toStringAsFixed(2)} ${widget.product.details[0].quantity.quantityMetric}"
          : "0",
      style: TextStyle(
        color: ThemeColoursSeva().dkGreen,
        fontSize: 1.9 * SizeConfig.heightMultiplier,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // shows/edit the total cart price
  Text _showTotalCartPrice(newCart) {
    double price;
    price = newCart.getCartTotalPrice();
    return Text(
      "Rs $price",
      style: TextStyle(
        color: ThemeColoursSeva().dkGreen,
        fontSize: 1.9 * SizeConfig.textMultiplier,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<NewCartModel>(
        builder: (context, newCart, child) {
          return Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 350,
            padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 30.0,
                    ),
                    Expanded(
                      child: Text(
                        widget.product.name,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ThemeColoursSeva().dkGreen,
                          fontSize: 2.8 * SizeConfig.heightMultiplier,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.cancel,
                        color: ThemeColoursSeva().binColor,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Rs ${widget.product.details[0].price} for ${widget.product.details[0].quantity.quantityValue} ${widget.product.details[0].quantity.quantityMetric}",
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: ThemeColoursSeva().dkGreen,
                    fontSize: 2.5 * SizeConfig.heightMultiplier,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // image
                      CachedNetworkImage(
                          width: 90,
                          height: 120,
                          imageUrl: widget.product.pictureURL),
                      Column(
                        children: [
                          SizedBox(
                            height: 15.625 * SizeConfig.heightMultiplier,
                            width: 80.0,
                            child: ListView.builder(
                              itemCount: widget.product.details[0].quantity
                                  .allowedQuantities.length,
                              itemBuilder: (builder, i) {
                                return Column(
                                  children: [
                                    SizedBox(height: 10.0),
                                    Text(
                                      "${widget.product.details[0].quantity.allowedQuantities[i].value} ${widget.product.details[0].quantity.allowedQuantities[i].metric}",
                                      style: TextStyle(
                                          color: ThemeColoursSeva().dkGreen,
                                          fontSize:
                                              1.9 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    SizedBox(height: 10.0)
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 15.625 * SizeConfig.heightMultiplier,
                            width: 110.0,
                            child: ListView.builder(
                              itemCount: widget.product.details[0].quantity
                                  .allowedQuantities.length,
                              itemBuilder: (builder, i) {
                                return Column(
                                  children: [
                                    SizedBox(height: 13.0),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            helper(i, newCart, false);
                                          },
                                          child: Icon(Icons.remove),
                                        ),
                                        SizedBox(width: 15.0),
                                        _showQ(newCart, widget.product, i),
                                        SizedBox(width: 15.0),
                                        GestureDetector(
                                            onTap: () {
                                              helper(i, newCart, true);
                                            },
                                            child: Icon(Icons.add)),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Text(
                //   (widget.product.funFact == "" ||
                //           widget.product.funFact == null)
                //       ? ""
                //       : widget.product.funFact,
                //   style: TextStyle(
                //     color: ThemeColoursSeva().dkGreen,
                //     fontSize: 20.0,
                //     fontWeight: FontWeight.w300,
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Item Total Quantity",
                      style: TextStyle(
                        color: ThemeColoursSeva().dkGreen,
                        fontSize: 1.9 * SizeConfig.heightMultiplier,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _showTotalItemQty(newCart),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Item Total Price",
                      style: TextStyle(
                        color: ThemeColoursSeva().dkGreen,
                        fontSize: 1.9 * SizeConfig.heightMultiplier,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _showItemTotalPrice(newCart),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Cart Total Price",
                      style: TextStyle(
                        color: ThemeColoursSeva().dkGreen,
                        fontSize: 1.9 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _showTotalCartPrice(newCart),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
