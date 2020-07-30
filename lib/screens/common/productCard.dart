import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductCardNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) => Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Apple- Red Delicious",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 20),
                    ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 600,
                          maxHeight: 160),
                        child: CachedNetworkImage(
                            imageUrl:
                                "https://storepictures.theonestop.co.in/products/pineapple.png")),
                    SizedBox(height: 20),
                    Text("Rs 120 - 1 Kg",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          )),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 0.0,
    );
  }
}
