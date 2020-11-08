// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.9
// Date-{19-09-2020}

///
/// @fileoverview New Products Widget : Shows all the products available.
///

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:mvp/bloc/productsapi_bloc.dart';
import 'package:mvp/classes/storeProducts_box.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/domain/product_repository.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/common/cartIcon.dart';
import 'package:mvp/screens/common/progressIndicator.dart';
import 'package:mvp/screens/productsNew/details.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:mvp/static-data/categories.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class ProductsUINew extends StatefulWidget {
  final int tagFromMain;
  ProductsUINew({this.tagFromMain});
  @override
  _ProductsUINewState createState() => _ProductsUINewState();
}

class _ProductsUINewState extends State<ProductsUINew> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ProductsapiBloc apiBloc;
  // Todo: Need to convert this static array to dynamic
  // will receive from server
  /// This Array is populated by the ListView Builder to show on
  /// the left side of the screen (1st row)
  String category;

  /// This tag will be used for 2 things mainly -
  /// 1. To make sure the API calls are dynamic
  /// 2. To handle any UI chnanges (for eg - TextStyle change if selected)
  /// We can pass in the tag through constructor as well when we click on
  /// one of the categories from MainLanding screen
  /// and tag value is not mutated but same value can be
  /// used by multiple instances, so we can use - static
  static int tag;

  final controller = FloatingSearchBarController();

  /// safer way to intialise the bloc
  /// and also dispose it properly
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    apiBloc = BlocProvider.of<ProductsapiBloc>(context);
    catArray[tag].backgroundColor = ThemeColoursSeva().vlgGreen;
    catArray[tag].textColor = Colors.white;
    apiBloc.add(GetProducts(type: catArray[tag].categoryName));
  }

  @override
  initState() {
    super.initState();

    /// Intialize it to 0 - by default to get Vegetables
    /// as it is on the first List Tile
    /// Or get it from the Main Landing UI
    if (widget.tagFromMain != null)
      tag = widget.tagFromMain;
    else
      tag = 0;
    for (int i = 0; i < catArray.length; i++) {
      if (i != tag) {
        catArray[i].backgroundColor = Colors.white;
        catArray[i].textColor = ThemeColoursSeva().pallete1;
      }
    }
  }

  @override
  void dispose() async {
    super.dispose();
    final SPBox box = await SPBox.getSPBoxInstance();
    await box.clear();
  }

// for pull refresh
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // calling the function as per category
    apiBloc.add(GetProducts(type: catArray[tag].categoryName));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
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

// Check whether the product is outOfStock and show according
  Widget _returnFilteredImage(StoreProduct p) {
    if (p.details[0].outOfStock) {
      return ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.grey,
            BlendMode.saturation,
          ),
          child: CachedNetworkImage(imageUrl: p.pictureURL));
    } else
      return CachedNetworkImage(imageUrl: p.pictureURL);
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
        if (!p.details[0].outOfStock) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProductDetails(
              p: p,
            );
          }));
        } else {
          final snackBar = SnackBar(
            content: Text("Item is Out of stock!"),
            action: SnackBarAction(
                textColor: ThemeColoursSeva().pallete1,
                label: "OK",
                onPressed: () {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                }),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// This shows the picture in a constrained box to make sure the
            /// resolution is maintained and it is not distorted
            /// Can be edited if the need arises to optimise
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 70, maxHeight: 70),

              /// The hero animation when tapped, makes sure there is a smooth
              /// transition to the details page. [tag] & [imageUrl] should be same here
              /// and in the product details page for the animation to work
              child: Hero(
                tag: p.name,
                child: _returnFilteredImage(p),
              ),
            ),
            Text(
              p.name,
              style: TextStyle(
                  fontSize: 1.65 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500,
                  color: p.details[0].outOfStock
                      ? Colors.grey
                      : ThemeColoursSeva().pallete1),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget mainContent(double width) {
    return Row(
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
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 600),
                        curve: Curves.fastOutSlowIn,
                        decoration: BoxDecoration(
                          color: catArray[index].backgroundColor,
                          border: Border(
                            bottom: BorderSide(
                                width: 0.2, color: Colors.greenAccent),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            catArray[index].name,
                            style: TextStyle(
                                fontSize: 1.65 * SizeConfig.textMultiplier,
                                color: catArray[index].textColor,
                                fontWeight: FontWeight.w700),
                          ),
                          onTap: () {
                            /// This [if] condition exists because we have only 3 types
                            /// of categories in the DB, as we add them up, this should be
                            /// dynamic, for now it is static
                            if (index < catArray.length) {
                              setState(() {
                                tag = index;
                                for (int i = 0; i < catArray.length; i++) {
                                  if (i == index) {
                                    catArray[i].backgroundColor =
                                        ThemeColoursSeva().vlgGreen;
                                    catArray[i].textColor = Colors.white;
                                  } else {
                                    catArray[i].backgroundColor = Colors.white;
                                    catArray[i].textColor =
                                        ThemeColoursSeva().pallete1;
                                  }
                                }
                              });
                              apiBloc.add(GetProducts(
                                  type: catArray[index].categoryName));
                            }
                          },
                        ),
                      );
                    }),
              ),
            ),
          ),
        ),
        // Using Bloc to change the state as per the State Set
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
                  arr.sort((a, b) => a.name.compareTo(b.name));
                  // enclosed gridview in refresher
                  return SmartRefresher(
                      enablePullDown: true,
                      footer: CustomFooter(
                        builder: (BuildContext context, LoadStatus mode) {
                          if (mode == LoadStatus.loading) {
                            CupertinoActivityIndicator();
                          } else if (mode == LoadStatus.failed) {
                            Text("Load Failed!Please retry!");
                          }
                          return Container();
                        },
                      ),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: GridView.count(
                        // Create a grid with 2 columns. If you change the scrollDirection to
                        // horizontal, this produces 2 rows.
                        crossAxisCount: 2,
                        children: arr.map((e) {
                          return getCard(e);
                        }).toList(),
                      ));
                } else if (state is ProductsapiError) {
                  return Center(
                      child: Text(
                    state.msg,
                    style: TextStyle(
                        color: ThemeColoursSeva().dkGreen,
                        fontSize: 2 * SizeConfig.textMultiplier),
                  ));
                } else
                  return CommonGreenIndicator();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLayout() {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        // height of screen
        double h = MediaQuery.of(context).size.height;
        return mainContent(h);
      });
    });
  }

  Widget customFloatSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      margins: EdgeInsets.only(
          top: 40.0, right: MediaQuery.of(context).size.width * 0.16),
      controller: controller,
      hint: 'Search for products',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      maxWidth: MediaQuery.of(context).size.width * 0.8,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: Icon(Icons.list_alt_rounded),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider(
      create: (BuildContext context) =>
          ProductsapiBloc(ProductRepositoryImpl()),
    );
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 68.0),
                child: buildLayout(),
              ),
              Positioned(
                right: 7.0,
                top: 35.0,
                child: CartIcon(),
              ),
              customFloatSearchBar()
            ],
          ),
        );
      });
    });
  }
}
