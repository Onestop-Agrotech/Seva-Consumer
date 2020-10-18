import 'package:flutter/cupertino.dart';
import 'package:mvp/screens/productsNew/newUI.dart';

class Routes {
  // common function for routing
  static void routeto(Widget screen, context, index) {
    Navigator.of(context)
        .push(CupertinoPageRoute<Null>(builder: (BuildContext context) {
      // return ProductsUINew(tagFromMain: screen.index);
    }));
  }
}
