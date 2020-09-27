// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.9
// Date-{19-09-2020}

///
/// @fileoverview New Products Widget : Shows all the products available.
///

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvp/bloc/productsapi_bloc.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/productsNew/details.dart';
import 'package:http/http.dart' as http;
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:shimmer/shimmer.dart';

class ProductsUINew extends StatefulWidget {
  @override
  _ProductsUINewState createState() => _ProductsUINewState();
}

class _ProductsUINewState extends State<ProductsUINew> {
  ProductsapiBloc apiBloc;
  // Todo: Need to convert this static array to dynamic
  // will receive from server
  /// This Array is populated by the ListView Builder to show on
  /// the left side of the screen (1st row)
  final List<String> catArray = [
    "Vegetables",
    "Fruits",
    "Milk, Eggs & Bread",
    "More Coming Soon!",
  ];
  String category;

  /// This tag will be used for 2 things mainly -
  /// 1. To make sure the API calls are dynamic
  /// 2. To handle any UI chnanges (for eg - TextStyle change if selected)
  /// We can pass in the tag through constructor as well when we click on
  /// one of the categories from MainLanding screen
  /// and tag value is not mutated but same value can be
  /// used by multiple instances, so we can use - static
  static int tag;

  /// safer way to intialise the bloc
  /// and also dispose it properly
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    apiBloc = BlocProvider.of<ProductsapiBloc>(context);
    if (tag == 0) apiBloc.add(GetVegetables());
  }

  @override
  initState() {
    super.initState();

    /// Intialize it to 0 - by default to get Vegetables
    /// as it is on the first List Tile
    tag = 0;
  }

  /// A common [Future] to GET products as per the category
  /// It depends on the [tag] variable and also this can
  /// be optimised instead of [Switch] statement
  /// This is should be replaced by the Generic API system
  /// which also has BLOC pattern
  Future<List<StoreProduct>> getProducts() async {
    String type = '';
    switch (tag) {
      case 0:
        type = "vegetable";
        break;
      case 1:
        type = "fruit";
        break;
      case 2:
        type = "dailyEssential";
        break;
      default:
    }
    this.setState(() {
      // _category = catArray[tag];
    });
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

  // shimmer layout before page loads
  _shimmerLayout() {
    var array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: array.map((e) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// this func returns the cards widget
  /// Currently it only shows 2 things
  /// 1. Picture
  /// 2. Name of product
  /// It requires the [StoreProduct] object to extract
  /// picture and name from the object
  Widget getCard(StoreProduct p) {
    /// The entire card is Gesture Detector widget so that if the user
    /// taps on the card, there is a smooth animation to the Product
    /// Details screen of the particular product, and it requires the same
    /// instance of the [StoreProduct] to be sent
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            p: p,
          );
        }));
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// This shows the picture in a constrained box to make sure the
            /// resolution is maintained and it is not distorted
            /// Can be edited if the need arises to optimise
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 60, maxHeight: 60),

              /// The hero animation when tapped, makes sure there is a smooth
              /// transition to the details page. [tag] & [imageUrl] should be same here
              /// and in the product details page for the animation to work
              child: Hero(
                tag: p.name,
                child: CachedNetworkImage(imageUrl: p.pictureURL),
              ),
            ),
            Text(
              p.name,
              style: TextStyle(
                  fontSize: 1.5 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // width of screen
    double width = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Categories",
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        /// This is the main row that seperates 2 cols
        children: [
          /// The first column to the left side
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width * 0.17,
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: catArray.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: tag == index
                                ? ThemeColoursSeva().vlgGreen
                                : Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: Colors.greenAccent),
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              catArray[index],
                              style: TextStyle(
                                  fontSize: 1.5 * SizeConfig.textMultiplier,
                                  color: tag == index
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w300),
                            ),
                            onTap: () {
                              /// This [if] condition exists because we have only 3 types
                              /// of categories in the DB, as we add them up, this should be
                              /// dynamic, for now it is static
                              if (index < 3) {
                                setState(() {
                                  tag = index;
                                });
                                switch (index) {
                                  case 0:
                                    apiBloc.add(GetVegetables());
                                    break;
                                  case 1:
                                    apiBloc.add(GetFruits());
                                    break;
                                  case 2:
                                    apiBloc.add(GetDailyEssentials());
                                    break;
                                  default:
                                }
                              }
                            },
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: SizedBox(
              width: 69 * SizeConfig.widthMultiplier,
              child: BlocBuilder<ProductsapiBloc, ProductsapiState>(
                builder: (context, state) {
                  if (state is ProductsapiInitial ||
                      state is ProductsapiLoading) {
                    return Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: Colors.grey[300],
                      child: Container(
                        child: _shimmerLayout(),
                      ),
                    );
                  } else if (state is ProductsapiLoaded) {
                    List<StoreProduct> arr = state.products;
                    return GridView.count(
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: 2,
                      children: arr.map((e) {
                        return getCard(e);
                      }).toList(),
                    );
                  } else if (state is ProductsapiError) {
                    return Text(state.msg);
                  } else
                    return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
