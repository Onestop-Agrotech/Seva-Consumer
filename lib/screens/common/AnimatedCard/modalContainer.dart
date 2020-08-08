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

    // Kg, Kgs, Gm, Gms, Pc - Types of Quantities

    // For Kg & Pc
    if (widget.product.quantity.allowedQuantities[index].metric == "Kg" ||
        widget.product.quantity.allowedQuantities[index].metric == "Pc") {
      q = 1;
      p = double.parse("${widget.product.price}");
    }
    // For Gms
    else if (widget.product.quantity.allowedQuantities[index].metric == "Gms") {
      q = (widget.product.quantity.allowedQuantities[index].value / 1000);
      p = (widget.product.quantity.allowedQuantities[index].value / 1000) *
          widget.product.price;
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
                Text(
                  widget.product.name,
                  style: TextStyle(
                    color: ThemeColoursSeva().dkGreen,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w300,
                  ),
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
                                          fontSize: 20.0,
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
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove),
                                          iconSize: 25.0,
                                          onPressed: () {
                                            // remove from cart
                                            helper(i, newCart, false);
                                          },
                                        ),
                                        _showQ(newCart, widget.product, i),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          iconSize: 25.0,
                                          onPressed: () {
                                            // add to cart
                                            helper(i, newCart, true);
                                          },
                                        ),
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
                  "Apples contain no fat, sodium or cholestrol and are a good source of fibre.",
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
