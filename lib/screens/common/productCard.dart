import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mvp/constants/themeColours.dart';

class ProductCardNew extends StatefulWidget {
  final bool shopping;
  ProductCardNew({this.shopping});
  
  // onClickProduct() {
  //   showGeneralDialog(
        // context: context,
        // barrierDismissible: true,
        // barrierLabel:
        //     MaterialLocalizations.of(context).modalBarrierDismissLabel,
        // barrierColor: Colors.black45,
        // transitionDuration: const Duration(milliseconds: 200),
        // pageBuilder: (BuildContext buildContext, Animation animation,
        //     Animation secondaryAnimation) {
        //   return Material(
        //     type: MaterialType.transparency,
        //     child: Center(
        //       child: Container(
        //         width: MediaQuery.of(context).size.width - 50,
        //         height: MediaQuery.of(context).size.height - 300,
        //         padding: EdgeInsets.all(20),
        //         color: Colors.white,
        //         child: Column(
        //           children: [
        //             RaisedButton(
        //               onPressed: () {
        //                 Navigator.of(context).pop();
        //               },
        //               child: Text(
        //                 "Save",
        //                 style: TextStyle(color: Colors.white),
        //               ),
        //               color: const Color(0xFF1BC0C5),
        //             ),
        //             Text(
        //               "Apple - Red Delicious",
        //               style: TextStyle(
        //                   color: ThemeColoursSeva().pallete2,
        //                   fontSize: 25.0,
        //                   fontWeight: FontWeight.w500),
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             Text("Rs 120 - 1 Kg",
        //                 overflow: TextOverflow.clip,
        //                 style: TextStyle(
        //                     color: ThemeColoursSeva().pallete2,
        //                     fontSize: 25.0,
        //                     fontWeight: FontWeight.w500)),
        //             SizedBox(height: 10),
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               children: <Widget>[
        //                 // ConstrainedBox(
        //                 //     constraints:
        //                 //         BoxConstraints(minWidth: 600, maxHeight: 160),
        //                 //     child: CachedNetworkImage(
        //                 //         imageUrl:
        //                 //             "https://storepictures.theonestop.co.in/products/pineapple.png")
        //                 //             ),
        //                 CachedNetworkImage(
        //                     width: 200,
        //                     height: 140,
        //                     imageUrl:
        //                         "https://storepictures.theonestop.co.in/products/pineapple.png"),
        //                 Column(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   // crossAxisAlignment: CrossAxisAlignment.,
        //                   children: <Widget>[
        //                     Text(
        //                       "200 Gms",
        //                       style: TextStyle(
        //                           color: ThemeColoursSeva().pallete2,
        //                           fontSize: 20.0,
        //                           fontWeight: FontWeight.w500),
        //                     ),
        //                     Text(
        //                       "200 Gms",
        //                       style: TextStyle(
        //                           color: ThemeColoursSeva().pallete2,
        //                           fontSize: 20.0,
        //                           fontWeight: FontWeight.w500),
        //                     ),
        //                     Text(
        //                       "200 Gms",
        //                       style: TextStyle(
        //                           color: ThemeColoursSeva().pallete2,
        //                           fontSize: 20.0,
        //                           fontWeight: FontWeight.w500),
        //                     ),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             Text(
        //                 "Apples contain  no fat, sodium or cholestrol and are a good source"),
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                   crossAxisAlignment: CrossAxisAlignment.center,
        //                   children: <Widget>[
        //                     Text("Item Total Price"),
        //                     Text("250")
        //                   ],
        //                 )
        //           ],
        //         ),
        //       ),
        //     ),
        //   );
        // });
  // }

  @override
  _ProductCardNewState createState() => _ProductCardNewState();
}

class _ProductCardNewState extends State<ProductCardNew> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) => Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: FlipCard(
                key: cardKey,
                flipOnTouch: false,
                front: Container(
                  width: 100.0,
                  decoration: BoxDecoration(
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
                        "Apple - Red Delicious",
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
                              ? IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    cardKey.currentState.toggleCard();
                                  })
                              : Container(),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: 67.3, maxHeight: 160),
                            child: CachedNetworkImage(
                                imageUrl:
                                    "https://storepictures.theonestop.co.in/products/pineapple.png"),
                          ),
                          this.widget.shopping
                              ? IconButton(
                                  icon: Icon(Icons.delete), onPressed: () {})
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
                        child: RaisedButton(
                          onPressed: () {
                            cardKey.currentState.toggleCard();
                          },
                          child: Text("Done"),
                        ),
                      )
                    : Container()),
          )),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 0.0,
    );
  }
}
