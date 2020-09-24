import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final StoreProduct p;
  final String cat;
  ProductDetails({@required this.p, this.cat});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int i;
  // shows/edit the total quantity of the product
  Text _showTotalItemQty(newCart) {
    double totalQ = 0.0;
    newCart.items.forEach((e) {
      if (e.id == widget.p.id) {
        totalQ = e.totalQuantity;
      }
    });

    return Text(
      totalQ != 0.0
          ? "${totalQ.toStringAsFixed(2)} ${widget.p.details[0].quantity.quantityMetric}"
          : "0",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    );
  }

  // shows/edit the total price of a particular item
  Text _showItemTotalPrice(newCart) {
    double price = 0;
    newCart.items.forEach((e) {
      if (e.id == widget.p.id) {
        price = e.totalPrice;
      }
    });
    return Text(
      "Rs $price",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    );
  }

  // shows/edit the total cart price
  Text _showTotalCartPrice(newCart) {
    double price;
    price = newCart.getCartTotalPrice();
    return Text(
      "Rs $price",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    );
  }

  void helper(int index, newCart, bool addToCart) {
    double p, q;

    // Kg, Kgs, Gms, Pc - Types of Quantities

    // For Kg & Pc

    if (widget.p.details[0].quantity.allowedQuantities[index].metric == "Kg") {
      q = 1;
      p = double.parse("${widget.p.details[0].price}");
    }
    // For Gms && ML
    else if (widget.p.details[0].quantity.allowedQuantities[index].metric ==
            "Gms" ||
        widget.p.details[0].quantity.allowedQuantities[index].metric == "ML") {
      q = (widget.p.details[0].quantity.allowedQuantities[index].value /
          1000.0);
      p = (widget.p.details[0].quantity.allowedQuantities[index].value /
              1000.0) *
          widget.p.details[0].price;
    }
    // For Pc, Pack, Kgs & Ltr
    else if (widget.p.details[0].quantity.allowedQuantities[index].metric ==
            "Pc" ||
        widget.p.details[0].quantity.allowedQuantities[index].metric == "Kgs" ||
        widget.p.details[0].quantity.allowedQuantities[index].metric == "Ltr" ||
        widget.p.details[0].quantity.allowedQuantities[index].metric ==
            "Pack") {
      q = double.parse(
          "${widget.p.details[0].quantity.allowedQuantities[index].value}");
      p = widget.p.details[0].price * q;
    }

    if (addToCart)
      newCart.addToNewCart(widget.p, p, q, index);
    else
      newCart.removeFromNewCart(widget.p, p, q, index);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text(widget.cat),
      // ),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200, maxHeight: 220),
                  child: Hero(
                    tag: this.widget.p.name,
                    child:
                        CachedNetworkImage(imageUrl: this.widget.p.pictureURL),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(widget.p.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(
                    "Rs ${widget.p.details[0].price} per ${widget.p.details[0].quantity.quantityValue} ${widget.p.details[0].quantity.quantityMetric}",
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: ThemeColoursSeva().dkGreen,
                      fontSize: 2.5 * SizeConfig.heightMultiplier,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Consumer<NewCartModel>(builder: (context, newCart, child) {
                    return Column(children: [
                      for (i = 0;
                          i <
                              widget.p.details[0].quantity.allowedQuantities
                                  .length;
                          i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.p.details[0].quantity.allowedQuantities[i].value} ${widget.p.details[0].quantity.allowedQuantities[i].metric}",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Row(children: [
                          Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                )),
                                        Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                )),
                        ],)
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     GestureDetector(
                            // child: Container(
                            //     decoration: BoxDecoration(
                            //         color: Colors.green,
                            //         borderRadius: BorderRadius.circular(20)),
                            //     child: Icon(
                            //       Icons.remove,
                            //       color: Colors.white,
                            //     )),
                      //       onTap: () {
                      //         helper(i, newCart, false);
                      //       },
                      //     ),
                      //     Text(
                      //         "${widget.p.details[0].quantity.allowedQuantities[i].qty}"),
                      //     GestureDetector(
                      //         child: Container(
                      //           decoration: BoxDecoration(
                      //               color: Colors.green,
                      //               borderRadius: BorderRadius.circular(20)),
                      //           child: Icon(Icons.add, color: Colors.white),
                      //         ),
                      //         onTap: () {
                      //           helper(i, newCart, true);
                      //         }),
                      //   ],
                      // ),
                    ]);
                  }),
                  // Text("hauksdh");
                  // return SizedBox(
                  //   width: 100,
                  //   height: 100,
                  //   child:
                  //   ListView.builder(
                  // itemCount: widget
                  //     .p.details[0].quantity.allowedQuantities.length,
                  //     itemBuilder: (builder, i) {
                  //       return Column(
                  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //         children: [
                  // Row(
                  //   mainAxisAlignment:
                  //       MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "${widget.p.details[0].quantity.allowedQuantities[i].value} ${widget.p.details[0].quantity.allowedQuantities[i].metric}",
                  //       style: TextStyle(fontSize: 18),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisAlignment:
                  //       MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     GestureDetector(
                  //       child: Container(
                  //           decoration: BoxDecoration(
                  //               color: Colors.green,
                  //               borderRadius:
                  //                   BorderRadius.circular(20)),
                  //           child: Icon(
                  //             Icons.remove,
                  //             color: Colors.white,
                  //           )),
                  //       onTap: () {
                  //         helper(i, newCart, false);
                  //       },
                  //     ),
                  //     Text(
                  //         "${widget.p.details[0].quantity.allowedQuantities[i].qty}"),
                  //     GestureDetector(
                  //         child: Container(
                  //           decoration: BoxDecoration(
                  //               color: Colors.green,
                  //               borderRadius:
                  //                   BorderRadius.circular(20)),
                  //           child: Icon(Icons.add,
                  //               color: Colors.white),
                  //         ),
                  //         onTap: () {
                  //           helper(i, newCart, true);
                  //         }),
                  //   ],
                  // ),
                  //         ],
                  //       );
                  //     },
                  //   ),
                  // );
                  Consumer<NewCartModel>(builder: (context, newCart, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Item Total Quantity",
                                style: TextStyle(fontSize: 17)),
                            SizedBox(
                              height: 5,
                            ),
                            _showTotalItemQty(newCart),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Item Total Price",
                                style: TextStyle(fontSize: 17)),
                            SizedBox(
                              height: 5,
                            ),
                            _showItemTotalPrice(newCart),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Cart Total Price",
                                style: TextStyle(fontSize: 17)),
                            SizedBox(
                              height: 5,
                            ),
                            _showTotalCartPrice(newCart),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
