// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

import 'package:cached_network_image/cached_network_image.dart';

///
/// @fileoverview FeaturedCards Widget: Reusable and Customizable Cards.
///

import 'package:flutter/material.dart';
import 'package:mvp/models/featured.dart';
import 'package:mvp/screens/common/sidenavbar.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

typedef ShowDialog = void Function();

class FeaturedCards extends StatelessWidget {
  final Featured featuredItem;
  final int index;
  final String referralCode;
  // final ShowDialog showInstructions;
  FeaturedCards(
      {@required this.featuredItem, @required this.index, this.referralCode});

// referral dialog
  showInstructions(context) {
    Sidenav().showReferralInstructions(context, referralCode);
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        // if (index == 1) showInstructions(context);
      },
      child: Container(
        // fallback height
        height: 20 * SizeConfig.heightMultiplier,
        width: width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        // child: Padding(
        //   padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 10.0),
        //   child: Text(
        //     textToDisplay,
        //     style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 2.4 * SizeConfig.textMultiplier,
        //         fontWeight: FontWeight.w500),
        //     overflow: TextOverflow.clip,
        //   ),
        // ),
        child: CachedNetworkImage(imageUrl: this.featuredItem.imgURL),
      ),
    );
  }
}
