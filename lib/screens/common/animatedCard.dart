// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview AnimateCard Modal : common product card.
///
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/common/common_functions.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:provider/provider.dart';

class AnimatedCard extends StatefulWidget {
  final bool shopping;
  final String categorySelected;
  final StoreProduct product;

  AnimatedCard({this.shopping, this.categorySelected, @required this.product});
  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  String heightofContainer;
  String widthofContainer;
  double newscreenheight;
  double newscreenwidth;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
  }

  // animation toggler
  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  // alert box while deleting
  void _showDeleteAlert(NewCartModel newCart, context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Remove item ?"),
            content:
                Text("${widget.product.name} will be removed from your cart."),
            actions: [
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                color: ThemeColoursSeva().pallete1,
              ),
              SizedBox(width: 20.0),
              RaisedButton(
                onPressed: () {
                  // delete the item
                  newCart.remove(widget.product);
                  Navigator.pop(context);
                },
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Material(
            child: Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(pi * animationController.value),
              child: animationController.value <= 0.5
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: !this.widget.product.details[0].outOfStock
                              ? ThemeColoursSeva().pallete3
                              : ThemeColoursSeva().grey,
                          width: !this.widget.product.details[0].outOfStock
                              ? 1.5
                              : 0.2,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Text(
                              this.widget.product.name,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color:
                                      !this.widget.product.details[0].outOfStock
                                          ? ThemeColoursSeva().pallete1
                                          : ThemeColoursSeva().grey,
                                  fontSize: 3.4 * SizeConfig.widthMultiplier,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              this.widget.shopping
                                  ? Expanded(
                                      child: IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            toggle();
                                            setState(() {
                                              heightofContainer =
                                                  '${context.size.height}';
                                              widthofContainer =
                                                  '${context.size.width}';
                                            });
                                            newscreenheight =
                                                double.parse(heightofContainer);
                                            newscreenwidth =
                                                double.parse(widthofContainer);
                                          }),
                                    )
                                  : Container(),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: 90, maxHeight: 130),
                                child: CachedNetworkImage(
                                    imageUrl: this.widget.product.pictureURL),
                              ),
                              this.widget.shopping
                                  ? Consumer<NewCartModel>(
                                      builder: (context, newCart, child) {
                                        return Expanded(
                                          child: IconButton(
                                              icon: Icon(Icons.delete),
                                              color:
                                                  ThemeColoursSeva().binColor,
                                              onPressed: () {
                                                // alert
                                                _showDeleteAlert(
                                                    newCart, context);
                                              }),
                                        );
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                          SizedBox(height: 20),
                          !this.widget.product.details[0].outOfStock
                              ? Text(
                                  !this.widget.shopping
                                      ? "Rs ${this.widget.product.details[0].price} - ${this.widget.product.details[0].quantity.quantityValue} ${this.widget.product.details[0].quantity.quantityMetric}"
                                      : "Rs ${this.widget.product.totalPrice} - ${this.widget.product.totalQuantity.toStringAsFixed(2)} ${this.widget.product.details[0].quantity.quantityMetric}",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: ThemeColoursSeva().pallete1,
                                      fontSize:
                                          3.4 * SizeConfig.widthMultiplier,
                                      fontWeight: FontWeight.w700))
                              : Text("Out of stock",
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: ThemeColoursSeva().grey,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    )
                  : this.widget.shopping
                      ? Container(
                          height: newscreenheight,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: ThemeColoursSeva().pallete3,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Transform(
                            alignment: FractionalOffset.center,
                            transform: Matrix4.identity()..rotateY(pi),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Column(
                                children: [
                                  Consumer<NewCartModel>(
                                    builder: (context, newCart, child) {
                                      return Row(
                                        children: [
                                          // daalo
                                          SizedBox(
                                            width: newscreenwidth * 0.42,
                                            height: newscreenheight * 0.65,
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              itemCount: widget
                                                  .product
                                                  .details[0]
                                                  .quantity
                                                  .allowedQuantities
                                                  .length,
                                              itemBuilder: (builder, i) {
                                                return Column(
                                                  children: [
                                                    SizedBox(height: 10.0),
                                                    Text(
                                                        "${widget.product.details[0].quantity.allowedQuantities[i].value} ${widget.product.details[0].quantity.allowedQuantities[i].metric}"),
                                                    SizedBox(height: 10.0),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: newscreenwidth * 0.55,
                                            height: newscreenheight * 0.65,
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              itemCount: widget
                                                  .product
                                                  .details[0]
                                                  .quantity
                                                  .allowedQuantities
                                                  .length,
                                              itemBuilder: (builder, i) {
                                                return Column(
                                                  children: [
                                                    SizedBox(height: 5.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        GestureDetector(
                                                          child: Icon(
                                                              Icons.remove),
                                                          onTap: () {
                                                            HelperFunctions
                                                                .helper(
                                                                    i,
                                                                    newCart,
                                                                    false,
                                                                    widget
                                                                        .product);
                                                          },
                                                        ),
                                                        SizedBox(width: 5.0),
                                                        Text(
                                                            "${widget.product.details[0].quantity.allowedQuantities[i].qty}"),
                                                        SizedBox(width: 5.0),
                                                        GestureDetector(
                                                            child:
                                                                Icon(Icons.add),
                                                            onTap: () {
                                                              HelperFunctions
                                                                  .helper(
                                                                      i,
                                                                      newCart,
                                                                      true,
                                                                      widget
                                                                          .product);
                                                            }),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5.0),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          toggle();
                                        },
                                        child: Icon(
                                          Icons.done,
                                          color: ThemeColoursSeva().dkGreen,
                                          size: 30.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
            ),
          );
        });
  }
}
