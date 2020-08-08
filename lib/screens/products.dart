import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/common/AnimatedCard/animatedCard.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List categories = ['Vegetables', 'Fruits', 'Daily Essentials'];
  int tapped;
  String selected;

  @override
  void initState() {
    super.initState();
  }

  Future<List<StoreProduct>> getProducts() async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String token = await p.getToken();
    Map<String, String> requestHeaders = {'x-auth-token': token};
    String url = "https://api.theonestop.co.in/api/products/fruit";
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      List<StoreProduct> x = jsonToStoreProductModel(response.body);
      return x;
    } else {
      throw Exception("Some error");
    }
  }

  _renderCartIcon() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          child: IconButton(
              color: ThemeColoursSeva().black,
              iconSize: 30.0,
              icon: Icon(Icons.shopping_basket),
              onPressed: () {
                // Handle shopping cart
              }),
        ),
        Positioned(
          left: 28.0,
          top: 10.0,
          child: _checkCartItems(),
        ),
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
      child: Consumer<NewCartModel>(
        builder: (context, cart, child) {
          return Center(
            child: Text(
              cart.totalItems == null ? '0' : cart.totalItems.toString(),
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 30.0,
                  color: ThemeColoursSeva().dkGreen,
                ),
                onPressed: () {},
              ),
              Text(
                "Fresh Fruits",
                style: TextStyle(
                    color: ThemeColoursSeva().dkGreen,
                    fontSize: 25,
                    fontWeight: FontWeight.w600),
              ),
              _renderCartIcon(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              for (int i = 0; i < categories.length; i++)
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color:
                      tapped == i ? ThemeColoursSeva().dkGreen : Colors.white,
                  onPressed: () {
                    setState(() {
                      tapped = i;
                      selected = categories[i];
                      print(selected);
                    });
                  },
                  child: Text(
                    categories[i],
                    style: TextStyle(
                        color: tapped == i
                            ? Colors.white
                            : ThemeColoursSeva().dkGreen),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          // AnimatedCard(shopping: false)

          Consumer<NewCartModel>(
            builder: (context, newCart, child) {
              return FutureBuilder(
                future: getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<StoreProduct> arr = snapshot.data;
                    return Expanded(
                      child: StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        itemCount: arr.length,
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.fit(2),
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 0.0,
                        itemBuilder: (BuildContext buildContext, int index) {
                          return Container(
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: AnimatedCard(
                                    shopping: false,
                                    categorySelected: selected,
                                    product: arr[index],
                                  ),
                                ),
                                SizedBox(width: 9.0)
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            },
          )
        ],
      )),
    );
  }
}
