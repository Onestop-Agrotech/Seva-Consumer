import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:provider/provider.dart';

class AddItemModal extends StatefulWidget {
  final StoreProduct product;
  AddItemModal({@required this.product});
  @override
  _AddItemModalState createState() => _AddItemModalState();
}

class _AddItemModalState extends State<AddItemModal> {
  void helper(int index, newCart, bool addToCart) {
    double p, q;

    // Kg, Kgs, Gms, Pc - Types of Quantities

    // For Kg & Pc
    if (widget.product.quantity.allowedQuantities[index].metric == "Kg") {
      q = 1;
      p = double.parse("${widget.product.price}");
    }
    // For Gms && ML
    else if (widget.product.quantity.allowedQuantities[index].metric == "Gms" ||
        widget.product.quantity.allowedQuantities[index].metric == "ML") {
      q = (widget.product.quantity.allowedQuantities[index].value / 1000.0);
      p = (widget.product.quantity.allowedQuantities[index].value / 1000.0) *
          widget.product.price;
    }
    // For Pc, Kgs & Ltr
    else if (widget.product.quantity.allowedQuantities[index].metric == "Pc" ||
        widget.product.quantity.allowedQuantities[index].metric == "Kgs" ||
        widget.product.quantity.allowedQuantities[index].metric == "Ltr") {
      q = double.parse(
          "${widget.product.quantity.allowedQuantities[index].value}");
      p = widget.product.price * q;
    }

    if (addToCart)
      newCart.addToNewCart(widget.product, p, q, index);
    else
      newCart.removeFromNewCart(widget.product, p, q, index);
  }

  Text _showQ(newCart, item, index) {
    int qty = 0;
    newCart.items.forEach((e) {
      if (e.id == item.id) {
        qty = e.quantity.allowedQuantities[index].qty;
      }
    });
    return Text("$qty");
  }

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
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Text _showTotalItemQty(newCart) {
    double totalQ = 0.0;
    newCart.items.forEach((e) {
      if (e.id == widget.product.id) {
        totalQ = widget.product.totalQuantity;
      }
    });

    return Text(
      totalQ != 0.0 ? "$totalQ ${widget.product.quantity.quantityMetric}" : "0",
      style: TextStyle(
        color: ThemeColoursSeva().dkGreen,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Text _showTotalCartPrice(newCart) {
    double price;
    price = newCart.getCartTotalPrice();
    return Text(
      "Rs $price",
      style: TextStyle(
        color: ThemeColoursSeva().dkGreen,
        fontSize: 20.0,
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
            width: MediaQuery.of(context).size.width - 50,
            height: MediaQuery.of(context).size.height - 300,
            padding: EdgeInsets.all(20),
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
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        color: ThemeColoursSeva().dkGreen,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300,
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
                  "Rs ${widget.product.price} for ${widget.product.quantity.quantityValue} ${widget.product.quantity.quantityMetric}",
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: ThemeColoursSeva().dkGreen,
                    fontSize: 20.0,
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
                          imageUrl: widget.product.pictureUrl),
                      Column(
                        children: [
                          SizedBox(
                            height: 125.0,
                            width: 80.0,
                            child: ListView.builder(
                              itemCount: widget
                                  .product.quantity.allowedQuantities.length,
                              itemBuilder: (builder, i) {
                                return Column(
                                  children: [
                                    SizedBox(height: 10.0),
                                    Text(
                                      "${widget.product.quantity.allowedQuantities[i].value} ${widget.product.quantity.allowedQuantities[i].metric}",
                                      style: TextStyle(
                                          color: ThemeColoursSeva().dkGreen,
                                          fontSize: 17.0,
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
                            height: 125.0,
                            width: 110.0,
                            child: ListView.builder(
                              itemCount: widget
                                  .product.quantity.allowedQuantities.length,
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
                Text(
                  (widget.product.funFact == "" ||
                          widget.product.funFact == null)
                      ? ""
                      : widget.product.funFact,
                  style: TextStyle(
                    color: ThemeColoursSeva().dkGreen,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Item Total Quantity",
                      style: TextStyle(
                        color: ThemeColoursSeva().dkGreen,
                        fontSize: 20.0,
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
                        fontSize: 20.0,
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
                        fontSize: 20.0,
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
