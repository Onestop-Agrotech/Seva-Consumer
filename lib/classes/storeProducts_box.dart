import 'package:hive/hive.dart';
import 'package:mvp/models/storeProducts.dart';

class SPBox {
  static const _storeProductsBox = 'StoreProducts';
  final Box<StoreProduct> _box;

  SPBox._(this._box);

  static Future<SPBox> getSPBoxInstance() async {
    final box = await Hive.openBox<StoreProduct>(_storeProductsBox);
    return SPBox._(box);
  }

  /// Add the product to the store products box
  Future<void> _addtoSPBox(StoreProduct a) {
    return _box.add(a);
  }

  /// Get the list of store products from API
  void addSPList(List<StoreProduct> l) {
    l.forEach((e) {
      _addtoSPBox(e);
    });
  }

  /// Get all products from the box with a type
  List<StoreProduct> getFromSPBox(String type) {
    final List<StoreProduct> l = _box.values.where((p) => p.type == type).toList();
    return l;
  }

  /// compact & close
  Future<void> close() async{
    await _box.clear();
    await _box.compact();
    await _box.close();
  }
}
