import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mvp/constants/themeColours.dart';

List<CategoryJSON> jsonToCategory(String str) => List<CategoryJSON>.from(
    json.decode(str).map((x) => CategoryJSON.fromJson(x)));

String categoryToJson(List<CategoryJSON> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryJSON {
  CategoryJSON(
      {this.name,
      this.categoryName,
      this.hasData,
      this.backgroundColor = Colors.white,
      this.textColor}) {
    this.textColor = ThemeColoursSeva().pallete1;
  }

  String name;
  String categoryName;
  bool hasData;
  Color backgroundColor;
  Color textColor;

  factory CategoryJSON.fromJson(Map<String, dynamic> json) => CategoryJSON(
        name: json["name"],
        categoryName: json["categoryName"],
        hasData: json["hasData"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "categoryName": categoryName,
        "hasData": hasData,
      };
}
