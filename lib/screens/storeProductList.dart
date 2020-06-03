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
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlZDYzNzE4YzNlN2M3OWYzZWY1ZWRmMSIsImlhdCI6MTU5MTE2NzAyNSwiZXhwIjoxNTkxMTcwNjI1fQ.GiWrOJ8_Ozs9QJQELgRNmE5844EWpraixs7L_Al3Ucw'
      };

      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        return jsonToStoreProductModel(response.body);
      } else {
        throw Exception('something is wrong');
      }
    });
  }

  FutureBuilder _buildArrayFromFuture(cart) {
    return FutureBuilder(
        future: _fetchProductsFromStore(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<StoreProduct> arr = snapshot.data;
            return ListView.builder(
                itemCount: arr.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('${arr[index].name}'),
                          Text('${arr[index].pricePerQuantity}'),
                          IconButton(icon: Icon(Icons.remove), onPressed: (){
                            setState(() {
                              if(arr[index].totalQuantity != 0){
                                arr[index].totalQuantity--;
                              }
                            });
                          }),
                          Text('${arr[index].totalQuantity}'),
                          IconButton(icon: Icon(Icons.add), onPressed: () {
                            setState(() {
                              arr[index].totalQuantity++;
                            });
                          }),
                        ],
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
                          builder: (context) => ShoppingCartScreen()));
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
