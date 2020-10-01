import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mvp/domain/product_repository.dart';
import 'package:mvp/models/storeProducts.dart';

part 'productsapi_event.dart';
part 'productsapi_state.dart';

class ProductsapiBloc extends Bloc<ProductsapiEvent, ProductsapiState> {
  final ProductRepositoryImpl _productRepository;

  ProductsapiBloc(this._productRepository) : super(ProductsapiInitial());

  @override
  Stream<ProductsapiState> mapEventToState(
    ProductsapiEvent event,
  ) async* {
    if (event is GetVegetables) {
      yield* _loadProducts(_productRepository.fetchVegetables);
    } else if (event is GetFruits) {
      yield* _loadProducts(_productRepository.fetchFruits);
    } else if (event is GetDailyEssentials) {
      yield* _loadProducts(_productRepository.fetchDailyEssentials);
    }
  }

  Stream<ProductsapiState> _loadProducts(func) async* {
    try {
      yield ProductsapiLoading();
      final products = await func();
      yield ProductsapiLoaded(products);
    } catch (err) {
      print(err);
      yield ProductsapiError(err.toString());
    }
  }
}
