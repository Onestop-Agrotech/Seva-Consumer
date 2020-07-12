// import 'package:async/async.dart';
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
  // final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  initState() {
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
                              storeName: widget.shopName,
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

  _fetchProductsFromStore() async {
    StorageSharedPrefs p = new StorageSharedPrefs();
      String token = await p.getToken();
      String url = APIService.businessProductsListAPI +
          "${widget.businessUsername}/products";
      Map<String, String> requestHeaders = {'x-auth-token': token};
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        return jsonToStoreProductModel(response.body);
      } else {
        throw Exception('something is wrong');
      }
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

  // NEW CODE *************************************************************************

  _scrollViewProducts(arr, heightOfScreen) {
    return Expanded(
      child: Scrollbar(
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: <Widget>[
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: heightOfScreen > 850
                    ? MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.5)
                    : heightOfScreen > 700
                        ? MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.5)
                        : MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.1),
              ),
              delegate: SliverChildBuilderDelegate((context, productIndex) {
                return ProductCard(
                  product: arr[productIndex],
                );
                // return
              }, childCount: arr.length),
            ),
          ],
        ),
      ),
    );
  }

  // NEW CODE *************************************************************************

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var heightOfScreen = size.longestSide;
    var cart = Provider.of<CartModel>(context);
    cart.checkCartItemsMatch();
    cart.firstTimeAddition();
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(
                child: Text(
                  "Vegetables",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "Fruits",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ]),
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
          floatingActionButton: cart.listLength > 0
              ? FloatingActionButton.extended(
                  backgroundColor: ThemeColoursSeva().dkGreen,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShoppingCartScreen(
                                  businessUserName: widget.businessUsername,
                                  distance: widget.distance,
                                  storeName: widget.shopName,
                                )));
                  },
                  label: Text("Cart"),
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                )
              : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: TabBarView(children: [
            Column(
              children: <Widget>[
                SizedBox(height: 20),
                FutureBuilder(
                  future: _fetchProductsFromStore(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<StoreProduct> arr = snapshot.data;
                      if (cart.listLength > 0) {
                        if (cart.items[0].uniqueId == arr[0].uniqueId) {
                          // matched, so update the quantity
                          arr = _updateQuantityFromCart(cart, arr);
                        }
                      }
                      arr.sort((a, b) => a.name.compareTo(b.name));
                      arr.removeWhere((element) => element.type != "vegetable");
                      if (arr.length > 0) {
                        return _scrollViewProducts(arr, heightOfScreen);
                      } else {
                        return Center(
                          child: Text("No Products Found."),
                        );
                      }
                    } else
                      return Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
            Column(
              children: <Widget>[
                SizedBox(height: 20),
                FutureBuilder(
                  future: _fetchProductsFromStore(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<StoreProduct> arr = snapshot.data;
                      if (cart.listLength > 0) {
                        if (cart.items[0].uniqueId == arr[0].uniqueId) {
                          // matched, so update the quantity
                          arr = _updateQuantityFromCart(cart, arr);
                        }
                      }
                      arr.sort((a, b) => a.name.compareTo(b.name));
                      arr.removeWhere((element) => element.type != "fruit");
                      if (arr.length > 0) {
                        return _scrollViewProducts(arr, heightOfScreen);
                      } else {
                        return Center(
                          child: Text("No Products Found."),
                        );
                      }
                    } else
                      return Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ]),
        ));
  }

}

