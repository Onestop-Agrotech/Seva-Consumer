// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview users model : models the user when a user logs in or registers.
///

import 'dart:convert';

import 'package:hive/hive.dart';
part 'users.g.dart';

UserModel jsonToUserModel(String str) => UserModel.fromJson(json.decode(str));
String userModelRegister(UserModel data) => json.encode(data.toRegisterJson());
String userModelAddress(UserModel data) => json.encode(data.toAddressJson());

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String username;
  @HiveField(2)
  String email;
  @HiveField(3)
  String mobile;
  @HiveField(4)
  String pincode;
  @HiveField(5)
  String address;
  @HiveField(6)
  String longitude;
  @HiveField(7)
  String latitude;
  @HiveField(8)
  String token;
  @HiveField(9)
  String refreshToken;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.mobile,
    this.pincode,
    this.address,
    this.longitude,
    this.latitude,
    this.token,
    this.refreshToken
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        mobile: json["mobile"],
        pincode: json["pincode"],
        address: json["address"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        token: json["token"],
        refreshToken: json["refreshToken"]
      );

  Map<String, dynamic> toRegisterJson() => {
        "username": username,
        "email": email,
        "mobile": mobile,
      };

  Map<String, dynamic> toAddressJson() => {
        "email": email,
        "address": address,
        "longitude": longitude,
        "latitude": latitude,
      };
}
