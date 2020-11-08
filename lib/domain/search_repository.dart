import 'package:mvp/models/storeProducts.dart';

abstract class SearchRepository {
  Future<List<StoreProduct>> fetchProducts(String type);
}