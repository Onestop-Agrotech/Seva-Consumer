import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/cart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/screens/common/customProductCard.dart';
import 'package:mvp/screens/common/topText.dart';
import 'package:mvp/screens/shoppingCart.dart';
import 'package:provider/provider.dart';

class StoreProductsScreen extends StatefulWidget {
  final String businessUsername;
  final String shopName;
  final String distance;

  StoreProductsScreen({this.businessUsername, this.shopName, this.distance});
  @override
  _StoreProductsScreenState createState() => _StoreProductsScreenState();
}

class _StoreProductsScreenState extends State<StoreProductsScreen> {
  // var cart = Provider.of<CartModel>(context);
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  initState(){
    super.initState();
    
    // cart.firstTimeAddition();
  }

  // UI design and Widgets
  Widget _shoppingCartIcon() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          child: IconButton(
              color: ThemeColoursSeva().black,
              iconSize: 30.0,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                // Handle shopping cart
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShoppingCartScreen(
                              businessUserName: widget.businessUsername,
                              distance: widget.distance,
                            )));
              }),
        ),
        Positioned(left: 28.0, top: 5.0, child: _checkCartItems()),
      ],
    );
  }

  Widget _checkCartItems() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      height: 22.0,
      decoration: BoxDecoration(
        color: ThemeColoursSeva().lgGreen,
        shape: BoxShape.circle,
      ),
      child: Consumer<CartModel>(
        builder: (context, cart, child) {
          cart.removeDuplicates();
          return Center(
            child: Text(
              cart.listLength == null ? '0' : cart.listLength.toString(),
            ),
          );
        },
      ),
    );
  }

  // Application Logic
  _splitAndArrange(List<StoreProduct> data) {
    int len = data.length;
    int size = 2;
    List<List<StoreProduct>> chunks = [];
    for (var i = 0; i < len; i += size) {
      var end = (i + size < len) ? i + size : len;
      chunks.add(data.sublist(i, end));
    }
    return chunks;
  }

  _fetchProductsFromStore() async {
    return this._memoizer.runOnce(() async {
      StorageSharedPrefs p = new StorageSharedPrefs();
      String token = await p.getToken();
      String url = APIService.businessProductsListAPI+"${widget.businessUsername}/products";
      Map<String, String> requestHeaders = {'x-auth-token': token};
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

  // List Builder
  FutureBuilder _buildArrayFromFuture(cart) {
    return FutureBuilder(
        future: _fetchProductsFromStore(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<StoreProduct> arr = snapshot.data;
            arr.sort((a, b) => a.name.compareTo(b.name));
            _splitAndArrange(arr);
            // check if cart items match current store products
            if (cart.listLength > 0) {
              if (cart.items[0].uniqueId == arr[0].uniqueId) {
                // matched, so update the quantity
                arr = _updateQuantityFromCart(cart, arr);
              }
            }
            var subArr = _splitAndArrange(arr);
            return ListView.builder(
                itemCount: subArr.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Consumer<CartModel>(
                        builder: (context, consumerCart, child) {
                          return Container(
                            height: 250.0,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: subArr[index].length,
                                      itemBuilder: (context, subIndex) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 16.0),
                                          child: ProductCard(product: subArr[index][subIndex],),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                });
          } else if (snapshot.hasError)
            return Text('${snapshot.error}');
          else
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: ThemeColoursSeva().black,
                  strokeWidth: 4.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ThemeColoursSeva().grey),
                ),
              ),
            );
        });
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);
    cart.checkCartItemsMatch();
    cart.firstTimeAddition();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
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
          title: TopText(txt: widget.shopName),
          centerTitle: true,
          actions: <Widget>[_shoppingCartIcon()],
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: _buildArrayFromFuture(cart)),
          SizedBox(height: 40.0)
        ],
      ),
    );
  }
}
