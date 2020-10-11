import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvp/constants/themeColours.dart';
import 'package:mvp/sizeconfig/sizeconfig.dart';

customTextField({
  TextEditingController controller,
  @required String labelText,
  TextInputType textInputType,
  Function validator,
  GlobalKey<FormState> formKey,
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
        child: Container(
          height: 50.0,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xffebedf0),
              borderRadius: BorderRadius.circular(20.0)),
          child: Container(
              width: 270.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextFormField(
                  keyboardType: textInputType,
                  controller: controller,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(
                      vertical: 1 * SizeConfig.textMultiplier,
                      horizontal: 10.0,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
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
              )),
        ),
      ),
    ],
  );
}
