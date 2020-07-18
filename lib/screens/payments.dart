import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/models/cart.dart';
import 'package:mvp/models/ordersModel.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:mvp/screens/common/topText.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:upi_india/upi_india.dart';

class Payments extends StatefulWidget {
  final int price;
  final String businessUsername;
  final String storeName;
  final bool delivery;
  Payments({this.price, this.businessUsername, this.storeName, this.delivery});
  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  // Future<UpiResponse> _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp> apps;
  // bool _success;

  @override
  void initState() {
    super.initState();
    // _success = false;
    _upiIndia.getAllUpiApps().then((value) {
      value.removeWhere((element) => element.name == "Axis Mobile");
      value.removeWhere((element) => element.name == "iMobile");
      value.removeWhere((element) => element.name == "SHAREit");
      value.removeWhere((element) => element.name == "Truecaller");
      value.removeWhere((element) => element.name == "BHIM Axis Pay");
      value.removeWhere((element) => element.name == "MakeMyTrip");
      value.removeWhere((element) => element.name == "BHIM");
      setState(() {
        apps = value;
      });
      _showDisclaimerDialog();
    });
  }

  _showDisclaimerDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Disclaimer"),
            content: Text(
                "The following payment made will be transacted to a personal account as the app is still in development phase. This personal account belongs to one of the Directors of Onestop Agrotech Private Limited. The next app update will fix this issue. For any queries please contact +918595179521. We apologize for any inconvenice caused. Your payment is safe and secure!"),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Deny Payment'),
                color: Colors.red,
                textColor: Colors.white,
              ),
              SizedBox(width: 30.0),
              RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('I Understand'),
                  color: ThemeColoursSeva().lgGreen,
                  textColor: Colors.white)
            ],
          );
        });
  }

  initiateTransaction(String app, cart) async {
    var response = await _upiIndia.startTransaction(
        app: app,
        receiverUpiId: 'vk.rahul318@okaxis',
        receiverName: 'Seva By Onestop',
        transactionRefId: 'SevaOrderRefID-000',
        transactionNote: 'For Seva Order - Rs ${widget.price}',
        amount: double.parse("${widget.price}"),);
        // amount: 1.00);
    if (response.status == UpiPaymentStatus.SUCCESS) {
      Fluttertoast.showToast(
          msg: "Order placed!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
      await _postOrderToServer(cart, response.transactionId);
      cart.clearCartWithoutNotify();
      Navigator.pushReplacementNamed(context, '/stores');
    }
    // return response;
  }

  Widget displayUpiApps(cart) {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps.length == 0)
      return Center(child: Text("No apps found to handle transaction."));
    else
      return Center(
        child: Wrap(
          children: apps.map<Widget>((UpiApp app) {
            return GestureDetector(
              onTap: () {
                initiateTransaction(app.app, cart);
                // setState(() {});
              },
              child: Container(
                height: 100,
                width: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.memory(
                      app.icon,
                      height: 60,
                      width: 60,
                    ),
                    Text(app.name),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
  }

  OrderModel _modelTheCart(cart, pid) {
    OrderModel newOrder = OrderModel();
    newOrder.storeId = 'Seva1234';
    newOrder.storeUserName = widget.businessUsername;
    List<Item> items = _modelItems(newOrder, cart);
    newOrder.items = items;
    newOrder.storeName = widget.storeName;
    newOrder.orderType = widget.delivery ? 'Delivery' : 'Pick Up';
    newOrder.finalItemsPrice = cart.calTotalPrice().toString();
    newOrder.deliveryPrice = widget.delivery ? '10' : '0';
    var cfp =
        widget.delivery ? cart.calTotalPrice() + 10 : cart.calTotalPrice();
    newOrder.customerFinalPrice = cfp.toString();
    newOrder.paymentType = 'Online';
    newOrder.paymentTransactionId = pid;
    return newOrder;
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
      i.itemPictureURL = e.pictureUrl;
      Quantity q = new Quantity();
      q.quantityValue = e.quantity.quantityValue;
      q.quantityMetric = e.quantity.quantityMetric;
      i.quantity = q;
      arr.add(i);
    });
    return arr;
  }

// post order to server here
  _postOrderToServer(cart, pid) async {
    // setState(() {
    //   _orderPost = _orderPost + 1;
    // });

    StorageSharedPrefs p = new StorageSharedPrefs();
    String token = await p.getToken();
    String username = await p.getUsername();
    String id = await p.getId();
    String url = APIService.ordersAPI + "${widget.businessUsername}";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "x-auth-token": token
    };
    OrderModel order = _modelTheCart(cart, pid);
    order.customerUsername = username;
    order.customerId = id;
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

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TopText(txt: 'UPI Payment - Rs ${widget.price}'),
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: ThemeColoursSeva().black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: <Widget>[
          displayUpiApps(cart),
          // Expanded(
          //   flex: 2,
          //   child: FutureBuilder(
          //     future: _transaction,
          //     builder:
          //         (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         if (snapshot.hasError) {
          //           return Center(child: Text('An Unknown error has occured'));
          //         }
          //         UpiResponse _upiResponse;
          //         _upiResponse = snapshot.data;
          //         if (_upiResponse.error != null) {
          //           String text = '';
          //           switch (snapshot.data.error) {
          //             case UpiError.APP_NOT_INSTALLED:
          //               text = "Requested app not installed on device";
          //               break;
          //             case UpiError.INVALID_PARAMETERS:
          //               text = "Requested app cannot handle the transaction";
          //               break;
          //             case UpiError.NULL_RESPONSE:
          //               text = "requested app didn't returned any response";
          //               break;
          //             case UpiError.USER_CANCELLED:
          //               text = "You cancelled the transaction";
          //               break;
          //           }
          //           return Center(
          //             child: Text(text),
          //           );
          //         }
          //         String txnId = _upiResponse.transactionId;
          //         String resCode = _upiResponse.responseCode;
          //         String txnRef = _upiResponse.transactionRefId;
          //         String status = _upiResponse.status;
          //         String approvalRef = _upiResponse.approvalRefNo;
          //         switch (status) {
          //           case UpiPaymentStatus.SUCCESS:
          //             print('Transaction Successful');
          //             break;
          //           case UpiPaymentStatus.SUBMITTED:
          //             print('Transaction Submitted');
          //             break;
          //           case UpiPaymentStatus.FAILURE:
          //             print('Transaction Failed');
          //             break;
          //           default:
          //             print('Received an Unknown transaction status');
          //         }
          //         return Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: <Widget>[
          //             Text('Transaction Id: $txnId\n'),
          //             Text('Response Code: $resCode\n'),
          //             Text('Reference Id: $txnRef\n'),
          //             Text('Status: $status\n'),
          //             Text('Approval No: $approvalRef'),
          //           ],
          //         );
          //       } else
          //         return Text(' ');
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}
