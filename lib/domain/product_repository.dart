import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:http/http.dart' as http;

abstract class ProductRepository {
  Future<List<StoreProduct>> fetchVegetables();
}

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<StoreProduct>> fetchVegetables() async {
    try {
      StorageSharedPrefs p = new StorageSharedPrefs();
      String token = await p.getToken();
      String hub = await p.gethub();
      Map<String, String> requestHeaders = {'x-auth-token': token};
      String url = APIService.getCategorywiseProducts(hub, "vegetable");
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200)
        return jsonToCateogrywiseProductModel(response.body);
      else
        throw Exception();
    } on Exception {
      print("200 was not returned!");
      return [];
    }
  }
}
