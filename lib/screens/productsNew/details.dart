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
            SizedBox(height: 20,),
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
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "500 Gms",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "0",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25),
                      Text("Item Total Quantity",
                          style: TextStyle(fontSize: 17)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "2 Kgs",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  Consumer<NewCartModel>(
//                       builder: (context, newCart, child) {
//                         return Padding(
//                           padding: EdgeInsets.only(
//                               top: SizeConfig.heightMultiplier * 3),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               // daalo
//                               SizedBox(
//                                 width: 100,
//                                 height: 100,
//                                 child: ListView.builder(
//                                   scrollDirection: Axis.vertical,
//                                   itemCount: widget.p.details[0].quantity
//                                       .allowedQuantities.length,
//                                   itemBuilder: (builder, i) {
//                                     return Column(
//                                       children: [
//                                         SizedBox(height: 10.0),
//                                         Text(
//                                             "${widget.p.details[0].quantity.allowedQuantities[i].value} ${widget.p.details[0].quantity.allowedQuantities[i].metric}"),
//                                         SizedBox(height: 10.0),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 100,
//                                 height: 100,
//                                 child: ListView.builder(
//                                   scrollDirection: Axis.vertical,
//                                   itemCount: widget.p.details[0].quantity
//                                       .allowedQuantities.length,
//                                   itemBuilder: (builder, i) {
//                                     return Column(
//                                       children: [
//                                         SizedBox(height: 5.0),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             GestureDetector(
//                                               child: Icon(Icons.remove),
//                                               onTap: () {
//                                                 helper(i, newCart, false);
//                                               },
//                                             ),
//                                             SizedBox(width: 5.0),
//                                             Text(
//                                                 "${widget.p.details[0].quantity.allowedQuantities[i].qty}"),
//                                             SizedBox(width: 5.0),
//                                             GestureDetector(
//                                                 child: Icon(Icons.add),
//                                                 onTap: () {
//                                                   helper(i, newCart, true);
//                                                 }),
//                                           ],
//                                         ),
//                                         SizedBox(height: 5.0),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
