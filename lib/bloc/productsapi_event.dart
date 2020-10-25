part of 'productsapi_bloc.dart';

@immutable
abstract class ProductsapiEvent {}

class GetProducts extends ProductsapiEvent {
  final String type;
  GetProducts({@required this.type}) : assert(type != null);
}

