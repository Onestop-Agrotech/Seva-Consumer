import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'inAppNotification.dart';

class InAppMessageHandler {
  final Map<String, dynamic> message;
  BuildContext context;
  InAppMessageHandler({@required this.message, @required this.context});

  void newUpdate() async {
   
    String url =
        "https://play.google.com/store/apps/details?id=com.onestop.seva";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void newUpdateAlert() {
    var notificationData = message['data'];
    var view = notificationData['view'];
    if (view == "new_update") {
      InAppNotificationHandler x = new InAppNotificationHandler(
          context: context,
          title: message["notification"]["title"],
          contentText: message["notification"]["body"],
          okButtonText: "Download",
          noButtonText: "Not now",
          okBtn: () async {
            newUpdate();
            Navigator.pop(context);
          },
          noBtn: () {
            Navigator.pop(context);
          });
      x.showAlertBox();
    }
  }

  
}
