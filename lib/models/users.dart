// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview users model : models the user when a user logs in or registers.
///

import 'dart:convert';

UserModel jsonToUserModel(String str) => UserModel.fromJson(json.decode(str));
String userModelRegister(UserModel data) => json.encode(data.toRegisterJson());
String userModelAddress(UserModel data) => json.encode(data.toAddressJson());
String userModelLogin(UserModel data) => json.encode(data.toLoginJson());

class UserModel {
  UserModel({
    this.id,
    this.username,
    this.email,
    this.password,
    this.mobile,
    this.pincode,
    this.address,
    this.longitude,
    this.latitude,
  });

  String id;
  String username;
  String email;
  String password;
  String mobile;
  String pincode;
  String address;
  String longitude;
  String latitude;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        mobile: json["mobile"],
        pincode: json["pincode"],
        address: json["address"],
        longitude: json["longitude"],
        latitude: json["latitude"],
      );

  Map<String, dynamic> toRegisterJson() => {
        "username": username,
        "email": email,
        "mobile": mobile,
        "password": password,
        "pincode": pincode,
      };

  Map<String, dynamic> toAddressJson() => {
        "email": email,
        "address": address,
        "longitude": longitude,
        "latitude": latitude,
      };

  Map<String, dynamic> toLoginJson() => {"email": email, "password": password};
}
