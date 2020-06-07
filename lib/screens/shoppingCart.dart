import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/cart.dart';
import 'package:mvp/screens/common/customShoppingCartCard.dart';
import 'package:mvp/screens/common/topText.dart';
import 'package:provider/provider.dart';

class ShoppingCartScreen extends StatefulWidget {
  final String businessUserName;
  ShoppingCartScreen({this.businessUserName});
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {

  // _showClearCart(cart){
  //   if(cart.listLength > 0){
  //     return Material(
  //             child: InkWell(
  //               onTap: () {
  //                 cart.clearCart();
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.only(top: 20.0, right: 10.0),
  //                 child: Text(
  //                   "Clear Cart",
  //                   style: TextStyle(
  //                     color: Colors.red,
  //                     fontSize: 12.0,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           );
  //   }else {
  //     return Container();
  //   }
  // }

  _showButton(cartItems) {
    if (cartItems.listLength > 0) {
      return FloatingActionButton.extended(
        onPressed: () {},
        label: Text(
          "Proceed",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ThemeColoursSeva().dkGreen,
      );
    } else
      return Container();
  }

  _listbuilder(cart) {
    cart.removeDuplicates();
    int cLength = cart.listLength;
    if (cLength > 0) {
      var items = cart.items;
      return ListView.builder(
          itemCount: cLength,
          itemBuilder: (ctxt, index) {
            return Column(
              children: <Widget>[
                ShoppingCartCard(
                  product: items[index],
                ),
                SizedBox(height: 20.0)
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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: ThemeColoursSeva().black,
                size: 40.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TopText(txt: 'Shopping Cart'),
          centerTitle: true,
          actions: <Widget>[
            // _showClearCart(cart)
          ],
        ),
      ),
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
            SizedBox(height: 70.0)
          ],
        ),
      ),
      floatingActionButton: _showButton(cart),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
