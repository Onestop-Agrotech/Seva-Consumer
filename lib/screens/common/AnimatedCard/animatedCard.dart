import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/storeProducts.dart';

import 'modalContainer.dart';

class AnimatedCard extends StatefulWidget {
  final bool shopping;
  final String categorySelected;
  final StoreProduct product;

  AnimatedCard({this.shopping, this.categorySelected, @required this.product});
  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  String heightofContainer;
  double newscreenheight;
  @override
  void initState() {
    super.initState();
    print(this.widget.categorySelected);
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
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
          return Center(
              child: AddItemModal(
            product: widget.product,
          ));
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
                              this.widget.product.name,
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
                                      imageUrl: this.widget.product.pictureUrl),
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
                            Text(
                                "Rs ${this.widget.product.price} - ${this.widget.product.quantity.quantityValue} ${this.widget.product.quantity.quantityMetric}",
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
