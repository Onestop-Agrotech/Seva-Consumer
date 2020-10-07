import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:mvp/classes/cartItems_box.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/common/common_functions.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final StoreProduct p;
  ProductDetails({@required this.p});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  // shows/edit the total quantity of the product
  Text _showTotalItemQty(newCart) {
    double totalQ = 0.0;
    newCart.items.forEach((e) {
      if (e.id == widget.p.id) {
        totalQ = e.totalQuantity;
      }
    });

    return Text(
      totalQ != 0.0
          ? "${totalQ.toStringAsFixed(2)} ${widget.p.details[0].quantity.quantityMetric}"
          : "0",
      style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: SizeConfig.textMultiplier * 2.1,
          color: Colors.blueGrey),
    );
  }

  // shows/edit the total price of a particular item
  Text _showItemTotalPrice(newCart) {
    double price = 0;
    newCart.items.forEach((e) {
      if (e.id == widget.p.id) {
        price = e.totalPrice;
      }
    });
    return Text(
      "Rs $price",
      style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: SizeConfig.textMultiplier * 2.1,
          color: Colors.blueGrey),
    );
  }

  // shows/edit the total cart price
  Text _showTotalCartPrice(newCart) {
    double price;
    price = newCart.getCartTotalPrice();
    return Text(
      "Rs $price",
      style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: SizeConfig.textMultiplier * 2.1,
          color: Colors.blueGrey),
    );
  }

  // shows/edit the quantity of the product
  Text _showQ(NewCartModel newCart, StoreProduct item, int index) {
    int qty = 0;
    newCart.items.forEach((e) {
      if (e.id == item.id) {
        qty = e.details[0].quantity.allowedQuantities[index].qty;
      }
    });
    return Text("$qty");
  }

  //it will get the name and the price of that product.
  Widget getNameAndPrice(height, width) {
    return Container(
      height: height * 0.08,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            widget.p.name,
            style: TextStyle(
                fontSize: SizeConfig.textMultiplier * 2,
                fontWeight: FontWeight.w700,
                color: ThemeColoursSeva().pallete1),
          ),
          Text(
              "Rs ${widget.p.details[0].price} per ${widget.p.details[0].quantity.quantityMetric}",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.textMultiplier * 2,
                  color: ThemeColoursSeva().pallete1))
        ],
      ),
    );
  }

  //returns a widget image of the clicked product [with a hero animation]
  Widget getImage(height, width) {
    return Container(
      width: width,
      height: height * 0.2,
      child: Hero(
          tag: widget.p.name,
          child: CachedNetworkImage(imageUrl: widget.p.pictureURL)),
    );
  }

  // return all the quantites available for that product
  Widget getQuantities(
      String quantity, double height, NewCartModel newCart, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              quantity,
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 2.1,
                  color: ThemeColoursSeva().black),
            ),
          ),
          SizedBox(height: height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  HelperFunctions.helper(index, newCart, false, widget.p);
                },
                child: Container(
                    width: SizeConfig.widthMultiplier * 8,
                    height: SizeConfig.widthMultiplier * 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green),
                    child: Icon(Icons.remove, color: Colors.white)),
              ),
              // shows the quantity available.
              _showQ(newCart, widget.p, index),
              GestureDetector(
                onTap: () {
                  HelperFunctions.helper(index, newCart, true, widget.p);
                },
                child: Container(
                    width: SizeConfig.widthMultiplier * 8,
                    height: SizeConfig.widthMultiplier * 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green),
                    child: Icon(Icons.add, color: Colors.white)),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<NewCartModel>(builder: (context, newCart, child) {
          return Container(
            width: width,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      iconSize: 40.0,
                      icon: Icon(
                        Icons.close,
                        color: ThemeColoursSeva().pallete1,
                      ),
                      onPressed: () => Navigator.of(context).pop(null),
                    ),
                  ],
                ),
                getImage(height, width),
                getNameAndPrice(height, width),
                Container(
                  height: height * 0.4,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: width * 0.33,
                        height: height * 0.4,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: widget.p.details[0].quantity
                                    .allowedQuantities.length,
                                itemBuilder: (context, index) {
                                  return getQuantities(
                                      "${widget.p.details[0].quantity.allowedQuantities[index].value} ${widget.p.details[0].quantity.allowedQuantities[index].metric}",
                                      height,
                                      newCart,
                                      index);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeaderText(text: "Item Total Quantity"),
                              SizedBox(
                                height: 10,
                              ),
                              _showTotalItemQty(newCart)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeaderText(
                                text: "Item Total Price",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _showItemTotalPrice(newCart)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeaderText(
                                text: "Cart Total Price",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _showTotalCartPrice(newCart)
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: height * 0.035),
                Container(
                  height: height * 0.1,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text(
                      "",
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 2.2,
                          color: Colors.black54,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}

class HeaderText extends StatelessWidget {
  final String text;
  const HeaderText({
    @required this.text,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: SizeConfig.textMultiplier * 2.1,
          color: ThemeColoursSeva().black),
    );
  }
}
