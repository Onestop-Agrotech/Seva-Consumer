import 'dart:convert';

List<CategoryJSON> jsonToCategory(String str) => List<CategoryJSON>.from(json.decode(str).map((x) => CategoryJSON.fromJson(x)));

String categoryToJson(List<CategoryJSON> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryJSON {
    CategoryJSON({
        this.name,
        this.categoryName,
        this.hasData,
    });

    String name;
    String categoryName;
    bool hasData;

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
