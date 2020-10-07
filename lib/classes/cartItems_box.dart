import 'package:hive/hive.dart';
import 'package:mvp/models/storeProducts.dart';

/// Cart Items Box
///
class CIBox {
  static const _cartItemsBox = 'CartItems';
  final Box<StoreProduct> _box;

  CIBox._(this._box);

  /// Return Cart Items instance
  ///
  static Future<CIBox> getCIBoxInstance() async {
    final box = await Hive.openBox<StoreProduct>(_cartItemsBox);
    return CIBox._(box);
  }

  /// Get a Cart item
  ///
  getItem(StoreProduct a) {
    if (_box.containsKey(a.id))
      return _box.get(a.id);
    else
      return null;
  }

  /// Get all cart Items
  ///
  getAllItems() {
    return _box.values.toList();
  }

  /// Add the product to the Cart Items Box
  ///
  Future<void> addToCIBox(StoreProduct a) {
    return _box.put(a.id, a);
  }

  /// Remove the product from the Cart Items Box
  ///
  Future<void> removeFromCIBox(StoreProduct a) {
    StoreProduct product = _box.get(a.id);
    product.totalPrice = 0;
    product.totalQuantity = 0;
    product.details[0].quantity.allowedQuantities.forEach((i) {
      i.qty = 0;
    });
    return _box.delete(a.id);
  }

  /// Edit the Cart Item
  /// and add stuff like price
  ///
  void addStuffToItem(
      {StoreProduct sp, double totalPrice, double totalQuantity, int index}) {
    StoreProduct product = _box.get(sp.id);
    if (product != null) {
      product.totalPrice += totalPrice;
      product.totalQuantity += totalQuantity;
      product.details[0].quantity.allowedQuantities[index].qty += 1;
    }
  }

  /// Edit the Cart Item
  /// and remove stuff like price
  ///
  void removeStuffFromItem({
    StoreProduct sp,
    double totalPrice,
    double totalQuantity,
    int index,
  }) {
    StoreProduct product = _box.get(sp.id);
    if (product.details[0].quantity.allowedQuantities[index].qty - 1 >= 0) {
      product.totalPrice -= totalPrice;
      product.totalQuantity -= totalQuantity;
      product.details[0].quantity.allowedQuantities[index].qty -= 1;
    }
  }

  /// Clear the Cart Items box
  ///
  Future<void> clearBox() async {
    await _box.clear();
  }

  /// compact & close
  Future<void> close() async {
    await _box.compact();
    await _box.close();
  }
}
