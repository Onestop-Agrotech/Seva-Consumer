import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: SizeConfig.textMultiplier * 2.1,
          color: Colors.blueGrey),
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
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: SizeConfig.textMultiplier * 2.1,
          color: Colors.blueGrey),
    );
  }

  // shows/edit the total cart price
  Text _showTotalCartPrice(newCart) {
    double price;
    price = newCart.getCartTotalPrice();
    return Text(
      "Rs $price",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: SizeConfig.textMultiplier * 2.1,
          color: Colors.blueGrey),
    );
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
          Text(
            widget.p.name,
            style: TextStyle(
                fontSize: SizeConfig.textMultiplier * 2.5,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          Text(
              "Rs ${widget.p.details[0].price} per ${widget.p.details[0].quantity.quantityMetric}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 2.5,
                  color: Colors.blueGrey))
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

  Widget getQuantities(String quantity, double height, newCart, index) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Column(
        children: [
          Text(
            quantity,
            style: TextStyle(
                fontSize: SizeConfig.textMultiplier * 2.5,
                color: Colors.black54),
          ),
          SizedBox(height: height * 0.009),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  helper(index, newCart, false);
                },
                child: Container(
                    width: SizeConfig.widthMultiplier * 8,
                    height: SizeConfig.widthMultiplier * 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green),
                    child: Icon(Icons.remove, color: Colors.white54)),
              ),
              _showQ(newCart, widget.p, index),
              GestureDetector(
                onTap: () {
                  helper(index, newCart, true);
                },
                child: Container(
                    width: SizeConfig.widthMultiplier * 8,
                    height: SizeConfig.widthMultiplier * 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green),
                    child: Icon(Icons.add, color: Colors.white54)),
              )
            ],
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
        body: Consumer<NewCartModel>(builder: (context, newCart, child) {
          return Container(
            height: height * 0.88,
            width: width,
            child: ListView(
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
                                      height,
                                      newCart,
                                      index);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Item Total Quantity",
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2.1,
                                    color: Colors.black54),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _showTotalItemQty(newCart)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Item Total Price",
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2.1,
                                    color: Colors.black54),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _showItemTotalPrice(newCart)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cart Total Price",
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2.1,
                                    color: Colors.black54),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _showTotalCartPrice(newCart)
                            ],
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
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "A fun fact or some kind of product description over here, which may include product grade, quality etc.",
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 2.5,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
