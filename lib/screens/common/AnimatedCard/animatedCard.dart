import 'dart:ffi';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/storeProducts.dart';

import 'modalContainer.dart';

class AnimatedCard extends StatefulWidget {
  final bool shopping;
  final String categorySelected;

  AnimatedCard({this.shopping, this.categorySelected});
  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
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
  String heightofContainer;
  double newscreenheight;
  @override
  void initState() {
    super.initState();
    print(this.widget.categorySelected);
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
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

  // open the modal for product addition
  void onClickProduct() {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(child: AddItemModal());
        });
  }

  // animation toggler
  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Material(
            child: Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(pi * animationController.value),
              child: animationController.value <= 0.5
                  ? GestureDetector(
                      onTap: () {
                        if (!this.widget.shopping) onClickProduct();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: ThemeColoursSeva().pallete3,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
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
                                    ? Expanded(
                                        child: IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              toggle();
                                              setState(() {
                                                heightofContainer =
                                                    '${context.size.height}';
                                              });
                                              newscreenheight = double.parse(
                                                  heightofContainer);
                                            }),
                                      )
                                    : Container(),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: 67.3, maxHeight: 160),
                                  child: CachedNetworkImage(
                                      imageUrl: products[0].pictureUrl),
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
                    )
                  : this.widget.shopping
                      ? GestureDetector(
                          onTap: () {
                            toggle();
                          },
                          child: Container(
                            height: newscreenheight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: ThemeColoursSeva().pallete3,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Transform(
                                alignment: FractionalOffset.center,
                                transform: Matrix4.identity()..rotateY(pi),
                                child: Text("Done")),
                          ),
                        )
                      : Container(),
            ),
          );
        });
  }
}
