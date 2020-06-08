import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/cart.dart';
import 'package:mvp/models/ordersModel.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/common/customShoppingCartCard.dart';
import 'package:mvp/screens/common/topText.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class ShoppingCartScreen extends StatefulWidget {
  final String businessUserName;
  ShoppingCartScreen({this.businessUserName});
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  Razorpay _razorpay;
  bool _payment;
  String _pid = '';

  @override
  initState() {
    super.initState();
    _payment = false;

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

  List<Item> _modelItems(order, cart) {
    List<Item> arr = [];
    cart.items.forEach((e) {
      Item i = new Item();
      i.itemId = e.id;
      i.name = e.name;
      i.totalPrice = e.totalPrice.toString();
      i.totalQuantity = e.totalQuantity.toString();
      i.itemStoreId = e.uniqueId;
      Quantity q = new Quantity();
      q.quantityValue = e.quantity.quantityValue;
      q.quantityMetric = e.quantity.quantityMetric;
      i.quantity = q;
      arr.add(i);
    });
    return arr;
  }

  OrderModel _modelTheCart(cart, pid) {
    OrderModel newOrder = OrderModel();
    newOrder.customerUsername = 'rahul';
    newOrder.customerId = '5ed9dabb936d884d1a2e5e6d';
    newOrder.storeId = 'Seva1234';
    newOrder.storeUserName = widget.businessUserName;
    List<Item> items = _modelItems(newOrder, cart);
    newOrder.items = items;
    newOrder.orderType = 'Delivery';
    newOrder.finalItemsPrice = cart.calTotalPrice().toString();
    newOrder.deliveryPrice = '10';
    var cfp = cart.calTotalPrice() + 10;
    newOrder.customerFinalPrice = cfp.toString();
    newOrder.paymentType = 'Online';
    newOrder.paymentTransactionId = pid;
    return newOrder;
  }

  // post order to server here
  _postOrderToServer(cart, pid) async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String token = await p.getToken();
    // String _username = await p.getUsername();
    String url = "http://localhost:8000/api/orders/${widget.businessUserName}/";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "x-auth-token": token
    };
    OrderModel order = _modelTheCart(cart, pid);
    String body = fromOrderModelToJson(order);
    // post
    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      print("success");
    } else {
      throw Exception('something is wrong');
    }
    // print(body);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    Fluttertoast.showToast(
        msg: "Order placed!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);

    setState(() {
      _pid = response.paymentId;
      _payment = true;
    });
    Future.delayed(const Duration(seconds: 2), (){
      Navigator.pushReplacementNamed(context, '/orders');
    });
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
    if (_payment == true) {
      // post order here
      _postOrderToServer(cart, _pid);
      Future.delayed(const Duration(seconds: 2), () {
        cart.clearCartWithoutNotify();
      });
    }
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
