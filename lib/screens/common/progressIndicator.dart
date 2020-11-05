import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class CommonGreenIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: ThemeColoursSeva().pallete1,
      valueColor: AlwaysStoppedAnimation<Color>(ThemeColoursSeva().vlgColor),
    );
  }
}
