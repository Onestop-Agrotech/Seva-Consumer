import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/shoppingCart/razorpay.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../common/AnimatedCard/animatedCard.dart';

class ShoppingCartNew extends StatefulWidget {
  @override
  _ShoppingCartNewState createState() => _ShoppingCartNewState();
}

class _ShoppingCartNewState extends State<ShoppingCartNew> {
  List<StoreProduct> p = [];
  StoreProduct a;
  StoreProduct b;
  StoreProduct c;
  StoreProduct d;
  String _rzpAPIKey;
  Razorpay _rzp;
  String _userMobile;
  String _userEmail;

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
      name: "Pineapple",
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
    d = new StoreProduct(
        name: "Carrots",
        pictureUrl: "https://storepictures.theonestop.co.in/products/orange.jpg",
        quantity: q,
        description: "local",
        price: 30);
    p.add(a);
    p.add(b);
    p.add(c);
    p.add(d);
    getKey();
    _rzp = Razorpay();
    _rzp.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _rzp.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _rzp.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  // handle successful payment
  handlePaymentSuccess(PaymentSuccessResponse response) {
    print("success");
  }

  // handle payment failure
  handlePaymentError(PaymentFailureResponse response) {
    print("fail");
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }

  // handle external wallet
  handleExternalWallet(ExternalWalletResponse response) {
    print("external");
  }

  // get user details
  _getUserDetails() async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String userId = await p.getId();
    String token = await p.getToken();
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
    await _getUserDetails();
    var options = {
      'key': key,
      'amount': price * 100,
      'prefill': {'contact': this._userMobile, 'email': this._userEmail},
      'external': {
        'wallets': ['paytm']
      }
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

  onSlidePay() {
    openCheckout(50, this._rzpAPIKey);
  }

  _showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Summary"),
                // text and promo btn
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[Text("Cart Price: "), Text("Rs 220")],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[Text("Cart Price: "), Text("Rs 220")],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[Text("Cart Price: "), Text("Rs 220")],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[Text("Cart Price: "), Text("Rs 220")],
                    ),
                    SizedBox(height: 30.0),
                    RaisedButton(onPressed: () {}, child: Text("Apply Promo"))
                  ],
                ),
                // slide to pay btn
                RaisedButton(
                    onPressed: () {
                      onSlidePay();
                    },
                    child: Text("Slide to pay"))
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_left),
          color: Colors.black,
          iconSize: 40.0,
          onPressed: () {},
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("My Shopping Cart",
            style: TextStyle(
                color: ThemeColoursSeva().dkGreen,
                fontSize: 25,
                fontWeight: FontWeight.w600)),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: this.p.length,
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
                      product: p[index],
                    )),
                    SizedBox(width: 9.0)
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: RaisedButton(
        onPressed: () {
          // open the bottomsheet
          _showModal();
        },
        child: Text(
          "Proceed",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        color: ThemeColoursSeva().dkGreen,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
