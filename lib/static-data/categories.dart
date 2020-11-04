import 'package:mvp/models/category.dart';

final List<Category> catArray = [
  Category(
      name: "Vegetables",
      categoryName: "vegetable",
      hasData: true,
      imgURL:
          "https://storepictures.theonestop.co.in/products/all-vegetables.jpg"),
  Category(
      name: "Fruits",
      categoryName: "fruit",
      hasData: true,
      imgURL: "https://storepictures.theonestop.co.in/new2/AllFruits.jpg"),
  Category(
      name: "Milk, Eggs & Bread",
      categoryName: "dailyEssential",
      hasData: true,
      imgURL:
          "https://storepictures.theonestop.co.in/illustrations/supermarket.png"),
  // Category(name: "Groceries", categoryName: "groceries", hasData: true),
  Category(
      name: "More Coming soon!", categoryName: "", hasData: false, imgURL: "")
];
