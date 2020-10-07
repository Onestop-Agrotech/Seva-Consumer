// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{03-09-2020}

import 'package:flutter/cupertino.dart';

///
/// @fileoverview Shopping Cart Screen : Summary of the shopping cart .
///

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/screens/promocodescreen.dart';
import 'package:mvp/screens/shoppingCart/loading.dart';
import 'package:mvp/screens/shoppingCart/razorpay.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:slider_button/slider_button.dart';
import '../common/animatedCard.dart';

class ShoppingCartNew extends StatefulWidget {
  @override
  _ShoppingCartNewState createState() => _ShoppingCartNewState();
}

class _ShoppingCartNewState extends State<ShoppingCartNew> {
  String _rzpAPIKey;
  Razorpay _rzp;
  String _userMobile;
  String _userEmail;
  bool _allowedDeliveries;
  bool _loadingDeliveries;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  initState() {
    super.initState();
    _allowedDeliveries = false;
    _loadingDeliveries = true;
    getAllowedStatus();
    _getUserDetails();
    getKey();
    _rzp = Razorpay();
    _rzp.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _rzp.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _rzp.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  //
  getAllowedStatus() async {
    final p = await Preferences.getInstance();
    String token = await p.getData("token");
    String url = APIService.deliveriesAllowedAPI;
    Map<String, String> requestHeaders = {'x-auth-token': token};
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var x = json.decode(response.body)["obj"]["deliveries"];
      setState(() {
        _allowedDeliveries = x;
        _loadingDeliveries = false;
      });
    }
  }

  // handle successful payment
  handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return OrderLoader(
        paymentId: response.paymentId,
      );
    }));
  }

  // handle payment failure
  handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }

  // handle external wallet
  handleExternalWallet(ExternalWalletResponse response) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return OrderLoader(
        paymentId: response.walletName,
      );
    }));
  }

  // get user details
  _getUserDetails() async {
    final p = await Preferences.getInstance();
    String userId = await p.getData("id");
    String token = await p.getData("token");
    String url = APIService.getUserAPI + "$userId";
    Map<String, String> requestHeaders = {'x-auth-token': token};
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      this._userMobile = json.decode(response.body)["mobile"];
      this._userEmail = json.decode(response.body)["email"];
    } else {
      throw Exception('something is wrong');
    }
  }

  void openCheckout(price, key) async {
    var options = {
      'key': key,
      'amount': price * 100,
      'prefill': {'contact': this._userMobile, 'email': this._userEmail},
    };

    try {
      this._rzp.open(options);
    } catch (e) {
      print(e);
    }
  }

  getKey() async {
    // get razorpay key for checkout options
    String apiKey = await RazorPaySeva().getRzpAPIKEY();
    setState(() {
      _rzpAPIKey = apiKey;
    });
  }

  _showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "Summary",
                  style: TextStyle(fontSize: SizeConfig.textMultiplier * 3),
                ),
                Text(
                  "Self pick up coming soon!",
                  style: TextStyle(
                      color: ThemeColoursSeva().grey,
                      fontSize: SizeConfig.textMultiplier * 2),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          "Cart Price: ",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 2.5),
                        ),
                        Consumer<NewCartModel>(
                          builder: (context, newCart, child) {
                            return Text(
                              "Rs ${newCart.getCartTotalPrice()}",
                              style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 2.5),
                            );
                          },
                        ),
                      ],
                    ),
                    this._userEmail != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("Delivery Fee: ",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.textMultiplier * 2.5)),
                              Text("Rs 0",
                                  style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2.5,
                                  ))
                            ],
                          )
                        : Text(""),
                    this._userMobile != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("Total Price: ",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.textMultiplier * 2.5)),
                              Consumer<NewCartModel>(
                                builder: (context, newCart, child) {
                                  return Text(
                                    "Rs ${newCart.getCartTotalPrice()}",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.textMultiplier * 2.5),
                                  );
                                },
                              ),
                            ],
                          )
                        : Text(""),
                  ],
                ),
                Consumer<NewCartModel>(
                  builder: (context, newCart, child) {
                    return this._userEmail != null
                        ? Column(
                            children: [
                              // Container(
                              //   child: RaisedButton(
                              //     color: ThemeColoursSeva().pallete1,
                              //     textColor: Colors.white,
                              //     onPressed: () {
                              //       Navigator.of(context).push(
                              //         CupertinoPageRoute<Null>(
                              //           builder: (BuildContext context) {
                              //             return PromoCodeScreen();
                              //           },
                              //         ),
                              //       );
                              //     },
                              //     child: Text("Have a Promo?"),
                              //   ),
                              // ),
                              SizedBox(
                                height: 60.0,
                              ),
                              SliderButton(
                                  shimmer: false,
                                  height: 50.0,
                                  buttonSize: 40.0,
                                  width: 200.0,
                                  radius: 50.0,
                                  vibrationFlag: true,
                                  dismissible: false,
                                  action: () {
                                    openCheckout(newCart.getCartTotalPrice(),
                                        _rzpAPIKey);
                                    Navigator.pop(context);
                                  },
                                  label: Text(
                                    "Slide to Pay",
                                    style: TextStyle(
                                        color: ThemeColoursSeva().dkGreen,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.9),
                                  ),
                                  icon: Icon(
                                    Icons.payment,
                                    color: ThemeColoursSeva().pallete1,
                                  )),
                            ],
                          )
                        : Text("Loading...");
                  },
                ),
              ],
            );
          });
        });
  }

  properText() {
    if (!_allowedDeliveries && _loadingDeliveries) {
      return Text(
        "Loading...",
        overflow: TextOverflow.clip,
        style: TextStyle(
            color: ThemeColoursSeva().pallete1,
            fontSize: 20.0,
            fontWeight: FontWeight.w600),
      );
    }
    // deliveries are closed
    else if (!_allowedDeliveries && !_loadingDeliveries) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: FloatingActionButton.extended(
          backgroundColor: ThemeColoursSeva().dkGreen,
          onPressed: () {},
          label: Text("Deliveries Closed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<NewCartModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 25.0,
                    color: ThemeColoursSeva().dkGreen,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  "My Shopping Cart",
                  style: TextStyle(
                      color: ThemeColoursSeva().dkGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 30.0,
                    color: ThemeColoursSeva().pallete1,
                  ),
                  onPressed: () {
                    print("REMOVE ALL CART ITEMS");
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Consumer<NewCartModel>(
              builder: (context, newCart, child) {
                if (newCart.totalItems == 0) {
                  return Center(
                    child: Text(
                      "No items in your cart!",
                      style: TextStyle(
                          color: ThemeColoursSeva().pallete1,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600),
                    ),
                  );
                }
                return Expanded(
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    itemCount: newCart.totalItems,
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 0.0,
                    itemBuilder: (BuildContext categories, int index) {
                      return Row(
                        children: <Widget>[
                          SizedBox(width: 12.0),
                          Expanded(
                              child: AnimatedCard(
                            shopping: true,
                            product: newCart.items[index],
                          )),
                          SizedBox(width: 9.0)
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: cart.totalItems > 0 && _allowedDeliveries
          ? RaisedButton(
              onPressed: () {
                // open the bottomsheet
                _showModal();
              },
              child: Text(
                "Proceed",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              color: ThemeColoursSeva().dkGreen,
            )
          : Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, bottom: 20.0, right: 10.0),
              child: properText(),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
