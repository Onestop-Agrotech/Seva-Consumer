import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/cart.dart';
import 'package:mvp/screens/common/customShoppingCartCard.dart';
import 'package:mvp/screens/common/topText.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ShoppingCartScreen extends StatefulWidget {
  final String businessUserName;
  ShoppingCartScreen({this.businessUserName});
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  Razorpay _razorpay;
  bool _payment;

  @override
  initState() {
    super.initState();
    _payment=false;

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    Fluttertoast.showToast(
        msg: "Paid Successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
    setState(() {
      _payment=true;
    });
    Navigator.pushReplacementNamed(context, '/orders');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }

  void openCheckout(price) async {
    var options = {
      'key': 'rzp_test_3PrnV481o0a0aV',
      'amount': price * 100,
      'prefill': {'contact': '9663395018', 'email': 'onestopagro@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  _showButton(cartItems) {
    if (cartItems.listLength > 0) {
      return FloatingActionButton.extended(
        onPressed: () {
          // testing payments
          var price = cartItems.calTotalPrice();

          openCheckout(price);
        },
        label: Text(
          "Proceed",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ThemeColoursSeva().dkGreen,
      );
    } else
      return Container();
  }

  _listbuilder(cart) {
    cart.removeDuplicates();
    int cLength = cart.listLength;
    if (cLength > 0) {
      var items = cart.items;
      return ListView.builder(
          itemCount: cLength,
          itemBuilder: (ctxt, index) {
            return Column(
              children: <Widget>[
                ShoppingCartCard(
                  product: items[index],
                ),
                SizedBox(height: 20.0)
              ],
            );
          });
    } else if (cLength == 0) {
      return Container(
        child: Center(
          child: Text("Shopping cart is empty!"),
        ),
      );
    } else
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);
    if(_payment==true) cart.clearCartWithoutNotify();
    cart.firstTimeAddition();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: ThemeColoursSeva().black,
                size: 40.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TopText(txt: 'Shopping Cart'),
          centerTitle: true,
          actions: <Widget>[
            // _showClearCart(cart)
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Consumer<CartModel>(
              builder: (context, consumerCart, child) {
                return Expanded(
                  child: _listbuilder(consumerCart),
                );
              },
            ),
            SizedBox(height: 70.0)
          ],
        ),
      ),
      floatingActionButton: _showButton(cart),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
