// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}
///
/// @fileoverview Error Class : having all the errors.
///

class ErrorClass {
  // when input fields are empty
  static bool emptyFields(String text) {
    // checking if text field is empty or not
    if (text.isEmpty) {
      return true;
    }
    return false;
  }
}
