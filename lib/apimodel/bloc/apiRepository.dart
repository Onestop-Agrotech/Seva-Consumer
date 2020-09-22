import 'package:mvp/apimodel/bloc/apidataProvider.dart';
import 'package:mvp/models/storeProducts.dart';

class ApiRepository {
  ApiDataProvider _playerApiProvider = ApiDataProvider();

  Future<List<StoreProduct>> getBSellers(String hubid) =>
      _playerApiProvider.getBestSellers(hubid);
 
}