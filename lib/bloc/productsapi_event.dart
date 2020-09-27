part of 'productsapi_bloc.dart';

@immutable
abstract class ProductsapiEvent {}

class GetVegetables extends ProductsapiEvent{}
class GetFruits extends ProductsapiEvent{}
class GetDailyEssentials extends ProductsapiEvent{}
