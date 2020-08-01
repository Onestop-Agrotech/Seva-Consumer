import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/storeProducts.dart';

class ProductCardNew extends StatefulWidget {
  final bool shopping;
  ProductCardNew({this.shopping});

  @override
  _ProductCardNewState createState() => _ProductCardNewState();
}

class _ProductCardNewState extends State<ProductCardNew> {
  List<StoreProduct> products = [];
  List<StoreProduct> categories = [];
  // static products
  StoreProduct a;
  StoreProduct b;
  StoreProduct c;
  // static categories
  StoreProduct d;
  StoreProduct e;
  StoreProduct f;

  onClickProduct() {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              height: MediaQuery.of(context).size.height - 300,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  // RaisedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: Text(
                  //     "Save",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  //   color: const Color(0xFF1BC0C5),
                  // ),
                  Text(
                    "Apple - Red Delicious",
                    style: TextStyle(
                      color: ThemeColoursSeva().pallete2,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Rs 120 - 1 Kg",
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: ThemeColoursSeva().pallete2,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      )),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CachedNetworkImage(
                          width: 200,
                          height: 140,
                          imageUrl:
                              "https://storepictures.theonestop.co.in/products/pineapple.png"),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.,
                        children: <Widget>[
                          Text(
                            "200 Gms",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: ThemeColoursSeva().pallete2,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "200 Gms",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: ThemeColoursSeva().pallete2,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "200 Gms",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: ThemeColoursSeva().pallete2,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Apples contain  no fat, sodium or cholestrol and are a good source",
                    style: TextStyle(
                        decoration: TextDecoration.none, fontSize: 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Item Total Price",
                        style: TextStyle(
                            decoration: TextDecoration.none, fontSize: 10),
                      ),
                      Text(
                        "250",
                        style: TextStyle(
                            decoration: TextDecoration.none, fontSize: 10),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  initState() {
    super.initState();
    Quantity q = new Quantity(quantityValue: 1, quantityMetric: "Kg");
    a = new StoreProduct(
        name: "Apple",
        pictureUrl: "https://storepictures.theonestop.co.in/products/apple.jpg",
        quantity: q,
        description: "local",
        price: 250);
    b = new StoreProduct(
      name: "Onion",
      pictureUrl:
          "https://storepictures.theonestop.co.in/products/pineapple.png",
      quantity: q,
      description: "local",
      price: 18,
    );
    c = new StoreProduct(
        name: "Carrots",
        pictureUrl: "https://storepictures.theonestop.co.in/products/onion.jpg",
        quantity: q,
        description: "local",
        price: 30);
    products.add(a);
    products.add(b);
    products.add(c);
    d = new StoreProduct(
      name: "Vegetables",
      pictureUrl:
          "https://storepictures.theonestop.co.in/illustrations/vegetable.png",
    );
    e = new StoreProduct(
      name: "Fruits",
      pictureUrl:
          "https://storepictures.theonestop.co.in/illustrations/viburnum-fruit.png",
    );
    f = new StoreProduct(
      name: "Daily Essentials",
      pictureUrl:
          "https://storepictures.theonestop.co.in/illustrations/supermarket.png",
    );
    categories.add(d);
    categories.add(e);
    categories.add(f);
  }

  Widget build(BuildContext context) {
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: categories.length,
      itemBuilder: (BuildContext categories, int index) => Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: FlipCard(
                // key: cardKey,
                flipOnTouch: this.widget.shopping ? true : false,
                front: Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ThemeColoursSeva().pallete3,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: GestureDetector(
                    onTap: () => this.widget.shopping ? null : onClickProduct(),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "apple",
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: ThemeColoursSeva().pallete2,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            this.widget.shopping
                                ? Expanded(child: Icon(Icons.edit))
                                : Container(),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: 67.3, maxHeight: 160),
                              child: CachedNetworkImage(
                                  imageUrl: products[index].pictureUrl),
                            ),
                            this.widget.shopping
                                ? Expanded(
                                    child: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          print("something");
                                        }),
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text("Rs 120 - 1 Kg",
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                color: ThemeColoursSeva().pallete2,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                ),
                back: Container(
                        height: MediaQuery.of(context).size.height * 0.22,
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ThemeColoursSeva().pallete3,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text("Done"),
                      )
                   ),
          )),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 0.0,
    );
  }
}
