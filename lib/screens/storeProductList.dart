import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/cart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class StoreProductsScreen extends StatefulWidget {
  final String businessUsername;

  StoreProductsScreen({this.businessUsername});
  @override
  _StoreProductsScreenState createState() => _StoreProductsScreenState();
}

class _StoreProductsScreenState extends State<StoreProductsScreen> {
  Future<List<StoreProduct>> _fetchProductsFromStore() async {
    String url =
        "http://10.0.2.2:8000/api/businesses/${widget.businessUsername}/products";
    Map<String, String> requestHeaders = {
      'x-auth-token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlZDYzNzE4YzNlN2M3OWYzZWY1ZWRmMSIsImlhdCI6MTU5MTE1NzMzNiwiZXhwIjoxNTkxMTYwOTM2fQ._KKD1kU7Vj1iytZnpbS8itIaMbQJqW8i1jXh1eQcyF0'
    };
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      return jsonToStoreProductModel(response.body);
    } else {
      throw Exception('something is wrong');
    }
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
                          ButtonTheme(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: RaisedButton(
                              onPressed: () {
                                cart.addItem(arr[index]);
                              },
                              color: ThemeColoursSeva().dkGreen,
                              textColor: Colors.white,
                              child: Text("Add to cart"),
                            ),
                          )
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
        child: _buildArrayFromFuture(cart),
      ),
    );
  }
}
