import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

customTextField({
  @required TextEditingController controller,
  @required String labelText,
  @required TextInputType textInputType,
  Function validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 40.0, bottom: 10.0),
        child: Text(labelText,
            style: TextStyle(
                color: ThemeColoursSeva().black,
                fontSize: 2.1 * SizeConfig.textMultiplier,
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
                    false) return "Not a valid email!";
              } else if (textInputType == TextInputType.number) {
                if (RegExp(r"^[0-9]{10}$").hasMatch(str) == false) {
                  return "Not a valid mobile!";
                }
              }
            }
            return null;
          },
          maxLength: labelText == "Mobile" ? 10 : null,
        ),
      ),
    ],
  );
}
