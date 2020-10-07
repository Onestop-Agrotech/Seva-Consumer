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

  /// model a new object
  ///
  StoreProduct makeObject(StoreProduct a) {
    StoreProduct n = new StoreProduct();
    n.id = a.id;
    n.name = a.name;
    n.uniqueId = n.uniqueId;
    n.description = a.description;
    n.pictureURL = a.pictureURL;
    n.totalPrice = a.totalPrice;
    n.totalQuantity = a.totalQuantity;
    List<Details> dList = [];
    Details d = new Details();
    d.hubid = a.details[0].hubid;
    d.id = a.details[0].id;
    d.price = a.details[0].price;
    d.outOfStock = a.details[0].outOfStock;
    d.bestseller = a.details[0].bestseller;
    Quantity q = new Quantity();
    q.quantityValue = a.details[0].quantity.quantityValue;
    q.quantityMetric = a.details[0].quantity.quantityMetric;
    List<AllowedQuantity> aList = [];
    a.details[0].quantity.allowedQuantities.forEach((aq) {
      AllowedQuantity aquantity = new AllowedQuantity();
      aquantity.id = aq.id;
      aquantity.value = aq.value;
      aquantity.metric = aq.metric;
      aquantity.qty = aq.qty;
      aList.add(aquantity);
    });
    q.allowedQuantities = aList;
    d.quantity = q;
    dList.add(d);
    n.details = dList;
    return n;
  }

  /// Add the product to the Cart Items Box
  ///
  Future<void> addToCIBox(StoreProduct a) {
    StoreProduct n = makeObject(a);
    return _box.put(n.id, n);
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
