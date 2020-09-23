import 'package:mvp/apimodel/bloc/apidataProvider.dart';

class ApiRepository {
  ApiDataProvider _playerApiProvider = ApiDataProvider();

  Future getBSellers() =>
      _playerApiProvider.getBestSellers();
 
}