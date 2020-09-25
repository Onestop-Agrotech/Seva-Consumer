import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final StoreProduct p;
  ProductDetails({@required this.p});
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

  Widget getNameAndPrice(height, width) {
    return Container(
      height: height * 0.08,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(widget.p.name),
          Text(
              "Rs ${widget.p.details[0].price} per ${widget.p.details[0].quantity.quantityMetric}")
        ],
      ),
    );
  }

  Widget getImage(height, width) {
    return Container(
      width: width,
      height: height * 0.2,
      child: Hero(
          tag: widget.p.name,
          child: CachedNetworkImage(imageUrl: widget.p.pictureURL)),
    );
  }

  Widget getQuantities(String quantity, double height) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Column(
        children: [
          Text(
            quantity,
            style: TextStyle(fontSize: 24.0, color: Colors.deepPurpleAccent),
          ),
          SizedBox(height: height * 0.009),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Icon(Icons.remove), Text("0"), Icon(Icons.add)],
          )
        ],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Product name"),
        ),
        body: Container(
          height: height * 0.88,
          width: width,
          child: Column(
            children: [
              getImage(height, width),
              getNameAndPrice(height, width),
              Container(
                height: height * 0.4,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: width * 0.33,
                      height: height * 0.4,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: widget.p.details[0].quantity
                                  .allowedQuantities.length,
                              itemBuilder: (context, index) {
                                return getQuantities(
                                    "${widget.p.details[0].quantity.allowedQuantities[index].value} ${widget.p.details[0].quantity.allowedQuantities[index].metric}",
                                    height);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [Text("Item Total Quantity"), Text("2kgs")],
                        ),
                        Column(
                          children: [Text("Item Total Quantity"), Text("2kgs")],
                        ),
                        Column(
                          children: [Text("Item Total Quantity"), Text("2kgs")],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: height * 0.035),
              Container(
                height: height * 0.1,
                width: width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "A fun fact or some kind of product description over here, which may include product grade, quality etc.",
                    style: TextStyle(fontSize: 20.0, color: Colors.blueGrey),
                  ),
                ),
              ),
            ],
          ),
        ));
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
