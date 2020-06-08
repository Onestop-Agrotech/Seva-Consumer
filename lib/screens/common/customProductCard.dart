import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/cart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final StoreProduct product;
  ProductCard({this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _loading;

  @override
  initState(){
    super.initState();
    _loading = false;
  }

  _showLoading(cart, item, setState) {
    if (_loading == true) {
      return CircularProgressIndicator(
        backgroundColor: ThemeColoursSeva().black,
        strokeWidth: 4.0,
        valueColor: AlwaysStoppedAnimation<Color>(ThemeColoursSeva().grey),
      );
    } else if(_loading == false)
      return Row(
        children: <Widget>[
          FlatButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                });
                cart.clearCart();
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                  cart.addItem(item);
                  setState(() {
                    _loading = false;
                  });
                });
              },
              child: Text('Remove')),
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel')),
        ],
      );
  }

  _showCartAlert(cart, item) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Items in Cart'),
            content: Text(
                'You have items in your cart. Items will be deleted if you add from another store. Proceed ?'),
            actions: <Widget>[
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return _showLoading(cart, item, setState);
              })
            ],
          );
        });
  }

  _showQ(consumerCart, item) {
    int qty = 0;
    if (consumerCart.listLength > 0) {
      // items exists
      consumerCart.items.forEach((a) {
        if (a.uniqueId == item.uniqueId) {
          qty = a.totalQuantity;
          return;
        }
      });
    }
    return Text('$qty');
  }

  _checkForAddition(consumerCart, item) {
    if (consumerCart.listLength > 0) {
      // check if item exists in cart and update
      // also add if it doesn't exist

      // if cart has items from another store
      // produce an alert here to remove items from store
      String user1 = consumerCart.items[0].uniqueId.split("-")[0];
      String user2 = item.uniqueId.split("-")[0];
      if (user1 == user2) {
        consumerCart.updateQtyByOne(item);
      } else {
        _showCartAlert(consumerCart, item);
      }
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

  _qtyBuilder(cart, StoreProduct product) {
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
              _checkForDeletion(cart, product);
            },
            iconSize: 15.0,
          ),
          _showQ(cart, product),
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {
              _checkForAddition(cart, product);
            },
            iconSize: 15.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     color: ThemeColoursSeva().grey,
      //     width: 0.6
      //   )
      // ),
      height: 280.0,
      width: width * 0.43,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // image
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 5.0),
            child: Container(
              height: 130.0,
              child: CachedNetworkImage(
                imageUrl: widget.product.pictureUrl,
                placeholder: (context, url) =>
                    Container(height: 50.0, child: Text("Loading...")),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 17.0),
            child: Text(
              widget.product.name,
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: ThemeColoursSeva().black),
            ),
          ),
          SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.only(left: 17.0),
            child: Text(
              "${widget.product.description}",
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                  color: ThemeColoursSeva().grey),
            ),
          ),
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Rs ${widget.product.price}",
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: ThemeColoursSeva().black),
                ),
                Text(
                  "${widget.product.quantity.quantityValue} ${widget.product.quantity.quantityMetric}",
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: ThemeColoursSeva().black),
                )
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Consumer<CartModel>(
            builder: (context, cart, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _qtyBuilder(cart, widget.product),
                  Text("Qty")
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
