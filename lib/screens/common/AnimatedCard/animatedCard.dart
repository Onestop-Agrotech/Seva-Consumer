import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:provider/provider.dart';

import 'modalContainer.dart';

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
    print(this.widget.categorySelected);
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
  }

  void helper(int index, newCart, bool addToCart) {
    double p, q;

    // Kg, Kgs, Gm, Gms, Pc - Types of Quantities

    // For Kg & Pc
    if (widget.product.quantity.allowedQuantities[index].metric == "Kg") {
      q = 1;
      p = double.parse("${widget.product.price}");
    }
    // For Gms
    else if (widget.product.quantity.allowedQuantities[index].metric == "Gms") {
      q = (widget.product.quantity.allowedQuantities[index].value / 1000.0);
      p = (widget.product.quantity.allowedQuantities[index].value / 1000.0) *
          widget.product.price;
    }
    // For Pc
    else if (widget.product.quantity.allowedQuantities[index].metric == "Pc") {
      q = double.parse(
          "${widget.product.quantity.allowedQuantities[index].value}");
      p = widget.product.price * q;
    }

    if (addToCart)
      newCart.addToNewCart(widget.product, p, q, index);
    else
      newCart.removeFromNewCart(widget.product, p, q, index);
  }

  // open the modal for product addition
  void onClickProduct() {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
              child: AddItemModal(
            product: widget.product,
          ));
        });
  }

  // animation toggler
  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  void _showDeleteAlert(newCart) {
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
                  newCart.removeItemFromNewCart(widget.product);
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
                  ? GestureDetector(
                      onTap: () {
                        if (!this.widget.shopping) onClickProduct();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: ThemeColoursSeva().pallete3,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              this.widget.product.name,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  color: ThemeColoursSeva().pallete1,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700),
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
                                              newscreenheight = double.parse(
                                                  heightofContainer);
                                              newscreenwidth = double.parse(
                                                  widthofContainer);
                                            }),
                                      )
                                    : Container(),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: 90, maxHeight: 130),
                                  child: CachedNetworkImage(
                                      imageUrl: this.widget.product.pictureUrl),
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
                                                  _showDeleteAlert(newCart);
                                                }),
                                          );
                                        },
                                      )
                                    : Container(),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                                !this.widget.shopping
                                    ? "Rs ${this.widget.product.price} - ${this.widget.product.quantity.quantityValue} ${this.widget.product.quantity.quantityMetric}"
                                    : "Rs ${this.widget.product.totalPrice} - ${this.widget.product.totalQuantity.toStringAsFixed(2)} ${this.widget.product.quantity.quantityMetric}",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: ThemeColoursSeva().pallete1,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
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
                                              itemCount: 3,
                                              itemBuilder: (builder, i) {
                                                return Column(
                                                  children: [
                                                    SizedBox(height: 10.0),
                                                    Text(
                                                        "${widget.product.quantity.allowedQuantities[i].value} ${widget.product.quantity.allowedQuantities[i].metric}"),
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
                                              itemCount: 3,
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
                                                            helper(i, newCart,
                                                                false);
                                                          },
                                                        ),
                                                        SizedBox(width: 5.0),
                                                        Text(
                                                            "${widget.product.quantity.allowedQuantities[i].qty}"),
                                                        SizedBox(width: 5.0),
                                                        GestureDetector(
                                                            child:
                                                                Icon(Icons.add),
                                                            onTap: () {
                                                              helper(i, newCart,
                                                                  true);
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
