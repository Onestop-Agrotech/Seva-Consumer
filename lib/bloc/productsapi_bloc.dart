import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mvp/models/storeProducts.dart';

part 'productsapi_event.dart';
part 'productsapi_state.dart';

class ProductsapiBloc extends Bloc<ProductsapiEvent, ProductsapiState> {
  ProductsapiBloc() : super(ProductsapiInitial());

  @override
  Stream<ProductsapiState> mapEventToState(
    ProductsapiEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
