part of 'productsapi_bloc.dart';

@immutable
abstract class ProductsapiEvent {}

class GetVegetablesAPI extends ProductsapiEvent{
  final List<StoreProduct> products;

  GetVegetablesAPI(this.products);
}