part of 'productsapi_bloc.dart';

@immutable
abstract class ProductsapiState {}

class ProductsapiInitial extends ProductsapiState {}

class ProductsapiLoading extends ProductsapiState {}

class ProductsapiLoaded extends ProductsapiState {
  final List<StoreProduct> products;

  ProductsapiLoaded(this.products);
}

class BestSellerLoaded extends ProductsapiState {
  final List<StoreProduct> bestSellers;
  BestSellerLoaded(this.bestSellers);
}

class ProductsapiError extends ProductsapiState {
  final String msg;

  ProductsapiError(this.msg);
}
