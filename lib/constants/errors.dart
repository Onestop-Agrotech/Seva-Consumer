// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}
import 'package:flutter/material.dart';

///
/// @fileoverview Error Class : having all the errors.
///

class ErrorClass {
  // when input fields are empty
  static Widget emptyFields(String text) {
    // checking if text field is empty or not
    if (text=="") {
      return Text("Field is required");
    }
    
    return null;
  }

  static Widget checkForMobile(String text) {
    // checking if text field is empty or not
    if (text.length<10) {
      return Text("Min 10 digit number should be there");
    }
    
    return null;
  }
}
