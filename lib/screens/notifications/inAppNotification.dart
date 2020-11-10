import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

class InAppNotificationHandler {
  final String title;
  final String contentText;
  final String okButtonText;
  final String noButtonText;
  final BuildContext context;
  Function okBtn;
  Function noBtn;

  InAppNotificationHandler(
      {@required this.context,
      @required this.title,
      @required this.contentText,
      @required this.okButtonText,
      @required this.noButtonText,
      this.okBtn,
      this.noBtn});

  void showAlertBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(this.title),
            content: Text(this.contentText),
            actions: <Widget>[
              RaisedButton(
                  onPressed: () async {
                    this.okBtn();
                  },
                  color: ThemeColoursSeva().pallete1,
                  textColor: Colors.white,
                  child: Text(this.okButtonText)),
              RaisedButton(
                  onPressed: () {
                    this.noBtn();
                  },
                  color: Colors.white,
                  textColor: ThemeColoursSeva().pallete1,
                  child: Text(this.noButtonText))
            ],
          );
        });
  }
}
