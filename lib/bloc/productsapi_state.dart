part of 'productsapi_bloc.dart';

@immutable
abstract class ProductsapiState {}

class ProductsapiInitial extends ProductsapiState {}

class ProductsapiLoading extends ProductsapiState{}

class ProductsapiLoaded extends ProductsapiState{}

class ProductsapiError extends ProductsapiState{}