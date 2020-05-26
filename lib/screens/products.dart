import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/graphics/greenProducts.dart';
import 'package:mvp/screens/common/topText.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomPaint(
            painter: GreenPaintProducts(),
            child: Center(child: null),
          ),
          SafeArea(
            child: Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: LayoutBuilder(
                  builder: (BuildContext context,
                      BoxConstraints viewportConstraints) {
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TopText(txt:"Products"),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
