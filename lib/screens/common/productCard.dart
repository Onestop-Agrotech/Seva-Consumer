import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/common/AnimatedCard/modalContainer.dart';

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
            child: AddItemModal()
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
                        // this.widget.shopping
                        //     ? Expanded(
                        //         child: IconButton(
                        //             icon: Icon(Icons.delete),
                        //             onPressed: () {
                        //               print("something");
                        //             }),
                        //       )
                        //     : Container(),
                        SizedBox(height: 20),
                        ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: 67.3, maxHeight: 160),
                          child: CachedNetworkImage(
                              imageUrl: products[index].pictureUrl),
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
                back: this.widget.shopping
                    ? Container(
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
                    : Container()),
          )),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 0.0,
    );
  }
}
