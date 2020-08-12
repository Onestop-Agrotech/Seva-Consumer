import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/newCart.dart';
import 'package:mvp/models/ordersModel.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/shoppingCart/razorpay.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../common/animatedCard/animatedCard.dart';

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
  String _userOrders;

  bool _paymentSuccess;
  String _paymentId;

  @override
  initState() {
    super.initState();
    _paymentSuccess = false;
    _paymentId = "";
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
        pictureUrl:
            "https://storepictures.theonestop.co.in/products/orange.jpg",
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

  _postDataToServer(responseId, newCart) async {
    _paymentSuccess=false;
    StorageSharedPrefs p = new StorageSharedPrefs();
    String userId = await p.getId();
    String token = await p.getToken();
    String url = APIService.ordersAPI + "/new/$userId";
    Map<String, String> requestHeaders = {'x-auth-token': token};
    // make the body
    OrderModel newOrder = new OrderModel(
        orderType: "delivery",
        finalItemsPrice: "${newCart.getCartTotalPrice()}",
        deliveryPrice: "20",
        paymentType: "online",
        paymentTransactionId: responseId);
    // if (double.parse(_userOrders) < 3.0) newOrder.deliveryPrice = "0";
    newOrder.customerFinalPrice =
        "${double.parse(newOrder.deliveryPrice) + double.parse(newOrder.finalItemsPrice)}";
    List<Item> itemList = [];
    for (int i = 0; i < newCart.totalItems; i++) {
      Item it = new Item(
        itemId: newCart.items[i].id,
        name: newCart.items[i].name,
        totalPrice: "${newCart.items[i].totalPrice}",
        totalQuantity: "${newCart.items[i].totalQuantity}",
      );
      itemList.add(it);
    }
    newOrder.items = itemList;
    var jsonBody = fromOrderModelToJson(newOrder);
    var response =
        await http.post(url, headers: requestHeaders, body: jsonBody);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Order posted!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } else if (response.statusCode == 404) {
      Fluttertoast.showToast(
          msg: "404 error",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } else if (response.statusCode == 500) {
      Fluttertoast.showToast(
          msg: "500 error",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } else
      throw Exception("Server error!");
  }

  // handle successful payment
  handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _paymentId = response.paymentId;
      _paymentSuccess = true;
    });
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
      this._userOrders = json.decode(response.body)["orders"];
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
                Text(
                  "Summary",
                  style: TextStyle(fontSize: 25),
                ),
                Text(
                  "Self pick up coming soon!",
                  style:
                      TextStyle(color: ThemeColoursSeva().grey, fontSize: 17.0),
                ),
                // text and promo btn
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          "Cart Price: ",
                          style: TextStyle(fontSize: 21),
                        ),
                        Consumer<NewCartModel>(
                          builder: (context, newCart, child) {
                            return Text(
                              "Rs ${newCart.getCartTotalPrice()}",
                              style: TextStyle(fontSize: 21),
                            );
                          },
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text("Delivery Fee: ", style: TextStyle(fontSize: 21)),
                        Text("Rs 0",
                            style: TextStyle(
                              fontSize: 21,
                            ))
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text("Total Price: ", style: TextStyle(fontSize: 21)),
                        Consumer<NewCartModel>(
                          builder: (context, newCart, child) {
                            return Text(
                              "Rs ${newCart.getCartTotalPrice()}",
                              style: TextStyle(fontSize: 21),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    // Promo code on Hold!
                    // ButtonTheme(
                    //     minWidth: 150.0,
                    //     height: 45.0,
                    //     child: RaisedButton(
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: new BorderRadius.circular(10.0)),
                    //         color: ThemeColoursSeva().dkGreen,
                    //         onPressed: () {},
                    //         child: Text(
                    //           "Apply Promo",
                    //           style: TextStyle(color: Colors.white),
                    //         )))
                  ],
                ),
                Consumer<NewCartModel>(
                  builder: (context, newCart, child) {
                    return ButtonTheme(
                      minWidth: 80.0,
                      height: 50.0,
                      child: RaisedButton(
                        color: ThemeColoursSeva().dkGreen,
                        onPressed: () {
                          openCheckout(newCart.getCartTotalPrice(), _rzpAPIKey);
                        },
                        child: Text(
                          "PAY",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<NewCartModel>(context);
    if (_paymentSuccess) _postDataToServer(_paymentId, cart);
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
                Container(
                  height: 10.0,
                  width: 100.0,
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
      floatingActionButton:
          cart.totalItems > 0 && cart.getCartTotalPrice() > 100.0
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
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    child: Text(
                      "Minimum order is Rs 100",
                      style: TextStyle(
                          color: ThemeColoursSeva().pallete1,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
