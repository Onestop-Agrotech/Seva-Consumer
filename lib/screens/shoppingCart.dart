import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/cart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:provider/provider.dart';

class ShoppingCartScreen extends StatefulWidget {
  final String businessUserName;
  ShoppingCartScreen({this.businessUserName});
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {

  _listbuilder(cart) {
    int cLength = cart.listLength;
    if (cLength > 0) {
      var items = cart.items;
      return ListView.builder(
          itemCount: cLength,
          itemBuilder: (ctxt, index) {
            int counter = index + 1;
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('$counter.'),
                    Text('${items[index].name}'),
                    Text('${items[index].totalQuantity}'),
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          cart.removeItem(items[index]);
                        })
                  ],
                ),
              ],
            );
          });
    } else if (cLength == 0) {
      return Container(
        child: Center(
          child: Text("Shopping cart is empty!"),
        ),
      );
    } else
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);
    cart.firstTimeAddition();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Consumer<CartModel>(
              builder: (context, consumerCart, child) {
                return Expanded(
                  child: _listbuilder(consumerCart),
                );
              },
            ),
            ButtonTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: ThemeColoursSeva().dkGreen,
                textColor: Colors.white,
                child: Text("Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
