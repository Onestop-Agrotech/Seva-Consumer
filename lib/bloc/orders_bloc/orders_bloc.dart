import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mvp/domain/exceptions.dart';
import 'package:mvp/domain/orders_repository.dart';
import 'package:mvp/models/ordersModel.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepositoryImpl _ordersRepository;
  OrdersBloc(this._ordersRepository) : super(OrdersInitial());

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is GetOrders) {
      yield* _loadBestSellers(_ordersRepository.fetchOrders);
    }
  }

  Stream<OrdersState> _loadBestSellers(func) async* {
    try {
      yield OrdersLoading();
      final products = await func();
      yield OrdersLoaded(products);
    } on UnauthorisedException {
      yield* _exceptionHandler(func);
    } catch (err) {
      yield OrdersError(err.toString());
    }
  }

  Stream<OrdersState> _exceptionHandler(func) async* {
    yield OrdersLoading();
    await _ordersRepository.refreshToken();
    final products = await func();
    yield OrdersLoaded(products);
  }
}
