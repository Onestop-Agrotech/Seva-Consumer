// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview OrderScreen Widget :
///

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvp/bloc/orders_bloc/orders_bloc.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/domain/orders_repository.dart';
import 'package:mvp/models/ordersModel.dart';
import 'package:mvp/screens/orders/orderCards.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class NewOrdersScreen extends StatefulWidget {
  @override
  _NewOrdersScreenState createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> {
  Timer x;
  OrdersBloc apiBloc;

  /// safer way to intialise the bloc
  /// and also dispose it properly
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    apiBloc = BlocProvider.of<OrdersBloc>(context);
    apiBloc.add(GetOrders());
  }

  @override
  initState() {
    super.initState();
    x = new Timer.periodic(Duration(seconds: 60), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    x.cancel();
    super.dispose();
  }

  // for pull refresh
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // calling the function as per category
    // apiBloc.add(GetProducts(type: catArray[tag].categoryName));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

// shimmer layout before page loads
  _shimmerLayout(width, height) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 10),
        for (int i = 0; i < 6; i++)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              width: height * 0.45,
              height: height * 0.18,
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider(
      create: (BuildContext context) => OrdersBloc(OrdersRepositoryImpl()),
    );
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "My Orders",
              style: TextStyle(
                  color: ThemeColoursSeva().pallete1,
                  fontWeight: FontWeight.w500),
            ),
            Container(
              width: 20.0,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SmartRefresher(
          enablePullDown: true,
          // enablePullUp: true,
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              if (mode == LoadStatus.loading) {
                CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                Text("Load Failed!Please retry!");
              }
              return Container();
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child:
              BlocBuilder<OrdersBloc, OrdersState>(builder: (context, state) {
            if (state is OrdersInitial || state is OrdersLoading) {
              return Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey[300],
                child: Container(
                  child: _shimmerLayout(width, height),
                ),
              );
            } else if (state is OrdersLoaded) {
              List<OrderModel> orders = state.orders;
              orders.sort((a, b) =>
                  b.time.orderTimestamp.compareTo(a.time.orderTimestamp));
              if (orders.length > 0)
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: orders.length,
                    itemBuilder: (builder, index) {
                      return OrdersCard(order: orders[index]);
                    });
              else
                return Container(
                  child: Center(
                      child: Text(
                    "No orders. Make one now!",
                    style: TextStyle(
                        color: ThemeColoursSeva().pallete1,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  )),
                );
            } else if (state is OrdersError) {
              return Center(
                  child: Text(
                state.msg,
                style: TextStyle(
                    color: ThemeColoursSeva().dkGreen,
                    fontSize: 2 * SizeConfig.textMultiplier),
              ));
            }
            return Container();
          })),
    );
  }
}
