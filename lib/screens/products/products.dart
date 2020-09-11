// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview Products Widget : Shows all the products available.
///

import 'dart:async';
// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/common/animatedCard/animatedCard.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:provider/provider.dart';

class Products extends StatefulWidget {
  final int type;

  const Products({Key key, @required this.type}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List categories = ['Vegetables', 'Fruits', 'Daily Essentials'];
  int tapped;
  String selected;
  Timer x;
  @override
  void initState() {
    super.initState();
    tapped = widget.type;
    x = new Timer.periodic(Duration(seconds: 10), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    x.cancel();
    super.dispose();
  }

  Future<List<StoreProduct>> getProducts(String type) async {
    List<StoreProduct> prods = [];
    StorageSharedPrefs p = new StorageSharedPrefs();
    String token = await p.getToken();
    String hub = await p.gethub();
    Map<String, String> requestHeaders = {'x-auth-token': token};
    String url = APIService.getCategorywiseProducts(hub, type);
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      List<StoreProduct> x = jsonToCateogrywiseProductModel(response.body);
      return x;
    } else {
      return prods;
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
                Navigator.pushNamed(context, '/shoppingCartNew');
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

  String _renderTopText() {
    String text = "";
    if (tapped == 0)
      text = "Fresh Vegetables";
    else if (tapped == 1)
      text = "Fresh Fruits";
    else
      text = "Daily Essentials";
    return text;
  }

  FutureBuilder _buildProducts(type) {
    return FutureBuilder(
      future: getProducts(type),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<StoreProduct> arr = snapshot.data;
          arr.sort((a, b) => a.name.compareTo(b.name));
          if (arr.length == 0) {
            return Center(
              child: Text("No Products Available!"),
            );
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.80,
            // height: 25.0,
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: arr.length,
              staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
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
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 25.0,
                  color: ThemeColoursSeva().dkGreen,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                _renderTopText(),
                style: TextStyle(
                    color: ThemeColoursSeva().dkGreen,
                    fontSize: 2.9 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600),
              ),
              _renderCartIcon(),
            ],
          ),
          SizedBox(
            height: 10,
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
                    });
                  },
                  child: Text(
                    categories[i],
                    style: TextStyle(
                        fontSize: 3.2 * SizeConfig.widthMultiplier,
                        color: tapped == i
                            ? Colors.white
                            : ThemeColoursSeva().dkGreen),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Consumer<NewCartModel>(
            builder: (context, newCart, child) {
              return IndexedStack(
                index: tapped,
                children: [
                  _buildProducts("vegetable"),
                  _buildProducts("fruit"),
                  _buildProducts("dailyEssential")
                ],
              );
            },
          )
        ],
      )),
    );
  }
}
