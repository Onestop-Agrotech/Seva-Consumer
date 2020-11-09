// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
///@fileoverview InputTextField : common input field.
///

import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType textInputType;
  final Key key;

  InputTextField(
      {@required this.controller,
      @required this.labelText,
      @required this.textInputType,
      this.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 40.0, bottom: 10.0),
          child: Text(labelText,
              style: TextStyle(
                  color: ThemeColoursSeva().black,
                  fontSize: 1.7 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: TextFormField(
            keyboardType: textInputType,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              // fillColor: ThemeColoursSeva().black,
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.7),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.7),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.7),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.7),
              ),
            ),
            validator: (String str) {
              if (str.isEmpty) {
                return "This Field cannot be empty!";
              } else if (str.isNotEmpty) {
                if (textInputType == TextInputType.emailAddress) {
                  if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(str) ==
                      false) {
                    return "Not a valid email!";
                  }
                } else if (textInputType == TextInputType.number) {
                  if (RegExp(r"^[0-9]{10}$").hasMatch(str) == false) {
                    return "Not a valid mobile!";
                  }
                }
              }
              return null;
            },
            maxLength: labelText == "Mobile" ? 10 : null,
            onChanged: (str) {
              return false;
            },
          ),
        ),
      ],
    );
  }
}
