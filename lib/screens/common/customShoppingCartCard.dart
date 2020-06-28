import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/cart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:provider/provider.dart';

class ShoppingCartCard extends StatefulWidget {
  final StoreProduct product;

  ShoppingCartCard({this.product});
  @override
  _ShoppingCartCardState createState() => _ShoppingCartCardState();
}

class _ShoppingCartCardState extends State<ShoppingCartCard> {
  _checkForAddition(consumerCart, item) {
    if (consumerCart.listLength > 0) {
      // check if item exists in cart and update
      // also add if it doesn't exist
      consumerCart.updateQtyByOne(item);
    } else {
      // add item to cart
      consumerCart.addItem(item);
    }
  }

  _checkForDeletion(consumerCart, item) {
    if (consumerCart.listLength > 0) {
      // check if item exists and remove quantity by 1
      // if it doesn't exist, do nothing
      consumerCart.minusQtyByOne(item);
    }
  }

  _qtyBuilder(consumerCart) {
    return Container(
      width: 105.0,
      height: 30.0,
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColoursSeva().black, width: 0.2),
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.remove,
            ),
            onPressed: () {
              _checkForDeletion(consumerCart, widget.product);
            },
            iconSize: 15.0,
          ),
          // _showQ(cart, product),
          Text('${widget.product.totalQuantity}'),
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {
              _checkForAddition(consumerCart, widget.product);
            },
            iconSize: 15.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 130.0,
            width: 160.0,
            child: CachedNetworkImage(
              imageUrl: widget.product.pictureUrl,
              placeholder: (context, url) =>
                  Container(height: 50.0, child: Text("Loading...")),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Consumer<CartModel>(
            builder: (context, consumerCart, child) {
              return Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            widget.product.name,
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text("x ${widget.product.totalQuantity}")
                        ],
                      ),
                      Text(
                        "${widget.product.description}",
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: ThemeColoursSeva().grey,
                        ),
                      ),
                      Text(
                        "Rs ${widget.product.totalPrice}",
                        style: TextStyle(
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0),
                      ),
                      _qtyBuilder(consumerCart),
                    ],
                  ),
                  Center(
                    child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          consumerCart.removeItem(widget.product);
                        }),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
