part of 'orders_bloc.dart';

@immutable
abstract class OrdersEvent {}

class GetOrders extends OrdersEvent {}
