import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/cart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/screens/shoppingCart.dart';
import 'package:provider/provider.dart';

class StoreProductsScreen extends StatefulWidget {
  final String businessUsername;

  StoreProductsScreen({this.businessUsername});
  @override
  _StoreProductsScreenState createState() => _StoreProductsScreenState();
}

class _StoreProductsScreenState extends State<StoreProductsScreen> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  _fetchProductsFromStore() async {
    return this._memoizer.runOnce(() async {
      String url =
          "http://localhost:8000/api/businesses/${widget.businessUsername}/products";
      Map<String, String> requestHeaders = {
        'x-auth-token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlZDYzNzE4YzNlN2M3OWYzZWY1ZWRmMSIsImlhdCI6MTU5MTI0NzA2MywiZXhwIjoxNTkxMjUwNjYzfQ.vHrGy_Q4qAa8p8RNqfEnIkOfS_XyaUkWk6Le2CSSO1k'
      };

      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        return jsonToStoreProductModel(response.body);
      } else {
        throw Exception('something is wrong');
      }
    });
  }

  _updateQuantityFromCart(cart, arr) {
    cart.items.forEach((i) => {
          arr.forEach((a) => {
                if (i.uniqueId == a.uniqueId)
                  {a.totalQuantity = i.totalQuantity}
              })
        });
    return arr;
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
      consumerCart.updateQtyByOne(item);
    } else {
      // add item to cart
      consumerCart.addItem(item, 1, 100);
    }
  }

  _checkForDeletion(consumerCart, item) {
    if (consumerCart.listLength > 0) {
      // check if item exists and remove quantity by 1
      // if it doesn't exist, do nothing
      consumerCart.minusQtyByOne(item);
    }
  }

  FutureBuilder _buildArrayFromFuture(cart) {
    return FutureBuilder(
        future: _fetchProductsFromStore(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<StoreProduct> arr = snapshot.data;
            arr.sort((a, b) => a.name.compareTo(b.name));
            // check if cart items match current store products
            if (cart.listLength > 0) {
              if (cart.items[0].uniqueId == arr[0].uniqueId) {
                // matched, so update the quantity
                arr = _updateQuantityFromCart(cart, arr);
              }
            }
            return ListView.builder(
                itemCount: arr.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      Consumer<CartModel>(
                        builder: (context, consumerCart, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('${arr[index].name}'),
                              Text('${arr[index].pricePerQuantity}'),
                              IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    _checkForDeletion(consumerCart, arr[index]);
                                  }),
                              _showQ(consumerCart, arr[index]),
                              IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    _checkForAddition(consumerCart, arr[index]);
                                  }),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 20.0)
                    ],
                  );
                });
          } else if (snapshot.hasError)
            return Text('${snapshot.error}');
          else
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
        });
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);
    cart.firstTimeAddition();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(child: _buildArrayFromFuture(cart)),
            ButtonTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShoppingCartScreen(
                                businessUserName: widget.businessUsername,
                              )));
                },
                color: ThemeColoursSeva().dkGreen,
                textColor: Colors.white,
                child: Text("To cart"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
