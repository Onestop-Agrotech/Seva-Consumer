import 'package:flutter/material.dart';
import 'package:mvp/models/cart.dart';
import 'package:provider/provider.dart';

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  _listbuilder(cart) {
    int cLength = cart.listLength;
    var items = cart.items;
    if (cLength > 0) {
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
                      },
                    )
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
        child: _listbuilder(cart),
      ),
    );
  }
}
