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

  /// Add the product to the Cart Items Box
  ///
  Future<void> addToCIBox(StoreProduct a) {
    return _box.put(a.id, a);
  }

  /// Remove the product from the Cart Items Box
  ///
  Future<void> removeFromCIBox(StoreProduct a) {
    return _box.delete(a.id);
  }

  /// Edit the Cart Item
  ///
  void editItemInCIBox(
      {StoreProduct sp,
      double totalPrice,
      double totalQuantity,
      int index,
      int qty}) {
    StoreProduct product = _box.get(sp.id);
    product.totalPrice = totalPrice;
    product.totalQuantity = totalQuantity;
    product.details[0].quantity.allowedQuantities[index].qty = qty;
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
