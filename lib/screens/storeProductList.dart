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
          "http://10.0.2.2:8000/api/businesses/${widget.businessUsername}/products";
      Map<String, String> requestHeaders = {
        'x-auth-token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlZDYzNzE4YzNlN2M3OWYzZWY1ZWRmMSIsImlhdCI6MTU5MTE4NjkwMywiZXhwIjoxNTkxMTkwNTAzfQ.0sL6rvaBTpXl_kAQ_Ehc_Nt7KduAu6PND3DQpt9yPYw'
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

  // _showQtyText(cart, item) {
  //   var index = -1;
  //   cart.items.forEach((a) =>
  //       {if (a.uniqueId == item.uniqueId) index = cart.items.indexOf(a)});
  //   if (index != -1)
  //     return Text('${cart.items[index].totalQuantity}');
  //   else
  //     return Text('${item.totalQuantity}');
  // }

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
                                    if (arr[index].totalQuantity != 0) {
                                      arr[index].totalQuantity =
                                          arr[index].totalQuantity - 1;
                                      if (arr[index].totalQuantity != 0) {
                                        consumerCart.minusQtyByOne(arr[index],
                                            arr[index].totalQuantity);
                                      } else if (arr[index].totalQuantity ==
                                          0) {
                                        // remove from cart
                                        cart.removeItem(arr[index]);
                                      }
                                    }
                                  }),
                              Text('${arr[index].totalQuantity}'),
                              IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    if (arr[index].totalQuantity == 0) {
                                      // first time addition to cart, so update quantity to 1 and add to cart
                                      arr[index].totalQuantity =
                                          arr[index].totalQuantity + 1;
                                      consumerCart.addItem(arr[index], 1, 100);
                                    } else {
                                      arr[index].totalQuantity =
                                          arr[index].totalQuantity + 1;
                                      consumerCart.updateQtyByOne(
                                          arr[index], arr[index].totalQuantity);
                                    }
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
